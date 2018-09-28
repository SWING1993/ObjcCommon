//
//  SWStatusCellLayout.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusCellLayout.h"
#import "SWStatusComment.h"

#define kWXBlue  UIColorMakeWithRGBA(87, 107, 149, 1)

@implementation SWStatusCellLayout

- (id)copyWithZone:(NSZone *)zone {
    SWStatusCellLayout* one = [[SWStatusCellLayout alloc] init];
    one.statusModel = [self.statusModel copy];
    one.cellHeight = self.cellHeight;
    one.lineRect = self.lineRect;
    one.menuPosition = self.menuPosition;
    one.commentBgPosition = self.commentBgPosition;
    one.avatarPosition = self.avatarPosition;
    one.websitePosition = self.websitePosition;
    one.imagePostions = [self.imagePostions copy];
    return one;
}

//布局模型
- (id)initWithStatusModel:(SWStatus *)statusModel
                    index:(NSInteger)index
                    opend:(BOOL)open {
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.statusModel = statusModel;
            //头像模型 avatarImageStorage
            LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
            avatarStorage.contents = [SWStatus getDocumentImageWithName:statusModel.avator];
            avatarStorage.backgroundColor = UIColorForBackground;
            avatarStorage.frame = CGRectMake(10, 15, 40, 40);
            avatarStorage.placeholder = UIImageMake(@"defaultHead");
            avatarStorage.tag = 9;
            
            //名字模型 nameTextStorage
            LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
            nameTextStorage.text = statusModel.nickname;
            nameTextStorage.vericalAlignment = LWTextVericalAlignmentTop;
            nameTextStorage.font = UIFontPFMediumMake(15);
            nameTextStorage.textColor = kWXBlue;
            nameTextStorage.frame = CGRectMake(60.0f, 15.0f, SCREEN_WIDTH - 80.0f, 15);
            
            //正文内容模型 contentTextStorage
            LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
            contentTextStorage.maxNumberOfLines = open?10:5;//设置最大行数，超过则折叠
            contentTextStorage.linespacing = 1.5f;
            contentTextStorage.font = UIFontMake(15);
            contentTextStorage.textColor = RGBA(40, 40, 40, 1);
            contentTextStorage.text = statusModel.content;
            contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                                  nameTextStorage.bottom,
                                                  SCREEN_WIDTH - 80.0f,
                                                  CGFLOAT_MAX);
            
            CGFloat contentBottom;
            
            if (open) {
                //折叠文字
                LWTextStorage* closeStorage = [[LWTextStorage alloc] init];
                closeStorage.text = @"收起";
                closeStorage.font = UIFontMake(15);
                closeStorage.textColor = RGBA(40, 40, 40, 1);
                closeStorage.frame = CGRectMake(nameTextStorage.left,
                                                contentTextStorage.bottom + 5.0f,
                                                200.0f,
                                                20.0f);
                [closeStorage lw_addLinkWithData:kLinkClose
                                           range:NSMakeRange(0, closeStorage.text.length)
                                       linkColor:kWXBlue
                                  highLightColor:UIColorHighLightColor];
                [self addStorage:closeStorage];
                contentBottom = closeStorage.bottom;
            } else {
                //折叠的条件
                if (contentTextStorage.isTruncation) {
                    LWTextStorage* openStorage = [[LWTextStorage alloc] init];
                    openStorage.text = @"全文";
                    openStorage.font = UIFontMake(15);
                    openStorage.textColor = RGBA(40, 40, 40, 1);
                    openStorage.frame = CGRectMake(nameTextStorage.left,
                                                   contentTextStorage.bottom + 5.0f,
                                                   200.0f,
                                                   20.0f);
                    [openStorage lw_addLinkWithData:kLinkOpen
                                              range:NSMakeRange(0, openStorage.text.length)
                                          linkColor:kWXBlue
                                     highLightColor:UIColorHighLightColor];
                    [self addStorage:openStorage];
                    contentBottom = openStorage.bottom;
                } else {
                    contentBottom = contentTextStorage.bottom;
                }
            }

            //解析表情和主题
            //解析表情、主题、网址
            [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
            [LWTextParser parseHttpURLWithTextStorage:contentTextStorage
                                            linkColor:UIColorLink
                                       highlightColor:UIColorHighLightColor];
            
            //添加长按复制
            [contentTextStorage lw_addLongPressActionWithData:contentTextStorage.text
                                               highLightColor:UIColorHighLightColor];
            
            //发布的图片模型 imgsStorage
            NSArray *imageArray = [statusModel.images mj_JSONObject];
            CGFloat imageWidth = (SCREEN_WIDTH - 140.0f)/3.0f;
            NSInteger imageCount = [imageArray count];
            NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            
            if (statusModel.type == 1) {
                // type 2 视频
                UIImage *firstImage = [SWStatus getDocumentImageWithName:[imageArray firstObject]];
                CGFloat height;
                CGFloat width;
                height = firstImage.size.height;
                width = firstImage.size.width;
                CGRect imageRect;
                CGFloat x = width/height;
                if (x > 2.5f) {
                    x = 2.5f;
                }
                if (x < 0.4f) {
                    x = 0.4f;
                }
                if (x == 1.0f) {
                    imageRect = CGRectMake(nameTextStorage.left,
                                           contentBottom + 5.0f,
                                           imageWidth*1.7,
                                           imageWidth*1.7);
                } else if (x > 1.0f) {
                    CGFloat h = imageWidth*1.7;
                    CGFloat w = MIN(h*x, imageWidth*3);
                    imageRect = CGRectMake(nameTextStorage.left,
                                           contentBottom + 5.0f,
                                           w,
                                           h);
                } else  {
                    CGFloat w = imageWidth*1.7;
                    CGFloat h = MIN(w/x, imageWidth*3);
                    imageRect = CGRectMake(nameTextStorage.left,
                                           contentBottom + 5.0f,
                                           w,
                                           h);
                }
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:MESSAGE_TYPE_VIDEO];
                imageStorage.tag = 0;
                imageStorage.contentMode = UIViewContentModeScaleAspectFill;
                imageStorage.clipsToBounds = YES;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
                imageStorage.contents = firstImage;
                [imageStorageArray addObject:imageStorage];
            } else if (statusModel.type == 2) {
                // 链接
                //这个CGRect用来绘制背景颜色
                self.websitePosition = CGRectMake(nameTextStorage.left,
                                                  contentBottom + 5.0f,
                                                  SCREEN_WIDTH - 80.0f,
                                                  50.0f);
                
                //左边的图片
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:WEBSITE_COVER_IDENTIFIER];
                imageStorage.contents = [SWStatus getDocumentImageWithName:statusModel.webSiteImage];
                imageStorage.clipsToBounds = YES;
                imageStorage.contentMode = UIViewContentModeScaleAspectFill;
                imageStorage.placeholder = UIImageMake(@"defaultLink");
                imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f,
                                                contentBottom + 10.0f ,
                                                40.0f,
                                                40.0f);
                [imageStorageArray addObject:imageStorage];
                
                //右边的文字
                LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
                detailTextStorage.text = statusModel.webSiteDesc;
                detailTextStorage.font = UIFontMake(13);
                detailTextStorage.textColor = RGB(40, 40, 40, 1);
                detailTextStorage.maxNumberOfLines = 2;
                detailTextStorage.vericalAlignment = LWTextVericalAlignmentCenter;
                detailTextStorage.frame = CGRectMake(imageStorage.right + 10.0f,
                                                     contentBottom + 5.0f,
                                                     SCREEN_WIDTH - 140.0f,
                                                     50.0f);
                
                detailTextStorage.linespacing = 0.5f;
                [detailTextStorage lw_addLinkForWholeTextStorageWithData:statusModel.webSiteUrl
                                                          highLightColor:UIColorHighLightColor];
                [self addStorage:detailTextStorage];
                
            } else {
                NSInteger row = 0;
                NSInteger column = 0;
                if (imageCount == 1) {
                    UIImage *firstImage = [SWStatus getDocumentImageWithName:[imageArray firstObject]];
                    CGFloat height;
                    CGFloat width;
                    height = firstImage.size.height;
                    width = firstImage.size.width;
                    CGFloat x = width/height;
                    CGRect imageRect;
                    if (x > 2.5f) {
                        x = 2.5f;
                    }
                    if (x < 0.4f) {
                        x = 0.4f;
                    }
                    if (x == 1.0f) {
                        imageRect = CGRectMake(nameTextStorage.left,
                                               contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               imageWidth*2,
                                               imageWidth*2);
                    } else if (x > 1.0f) {
                        CGFloat h = imageWidth*1.7;
                        CGFloat w = MIN(h*x, imageWidth*3);
                        imageRect = CGRectMake(nameTextStorage.left,
                                               contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               w,
                                               h);
                    } else {
                        CGFloat w = imageWidth*1.7;
                        CGFloat h = MIN(w/x, imageWidth*3);
                        imageRect = CGRectMake(nameTextStorage.left,
                                               contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               w,
                                               h);
                    }
                    NSString* imagePositionString = NSStringFromCGRect(imageRect);
                    [imagePositionArray addObject:imagePositionString];
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:IMAGE_IDENTIFIER];
                    imageStorage.tag = 0;
                    imageStorage.contentMode = UIViewContentModeScaleAspectFill;
                    imageStorage.clipsToBounds = YES;
                    imageStorage.frame = imageRect;
                    imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
                    imageStorage.contents = firstImage;
                    [imageStorageArray addObject:imageStorage];
                } else {
                    for (NSInteger i = 0; i < imageCount; i ++) {
                        CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 5.0f)),
                                                      contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                                      imageWidth,
                                                      imageWidth);
                        NSString* imagePositionString = NSStringFromCGRect(imageRect);
                        [imagePositionArray addObject:imagePositionString];
                        LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:IMAGE_IDENTIFIER];
                        imageStorage.clipsToBounds = YES;
                        imageStorage.contentMode = UIViewContentModeScaleAspectFill;
                        imageStorage.tag = i;
                        imageStorage.frame = imageRect;
                        imageStorage.backgroundColor = RGBA(240, 240, 240, 1);
                        UIImage *image = [SWStatus getDocumentImageWithName:[imageArray objectAtIndex:i]];
                        imageStorage.contents = image;
                        [imageStorageArray addObject:imageStorage];
                        column = column + 1;
                        if (imageCount == 4) {
                            if (column > 1) {
                                column = 0;
                                row = row + 1;
                            }
                        } else {
                            if (column > 2) {
                                column = 0;
                                row = row + 1;
                            }
                        }
                    }
                }
            }
            
            //获取最后一张图片的模型
            LWImageStorage* lastImageStorage;
            if (imageStorageArray.count > 0) {
                lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
            } else {
                lastImageStorage = [[LWImageStorage alloc] init];
                CGRect imageRect = CGRectMake(nameTextStorage.left,
                                              contentBottom,
                                              0,
                                              0);
                lastImageStorage.frame = imageRect;
            }
            
            //生成时间的模型 dateTextStorage
            LWTextStorage* locationStorage = [[LWTextStorage alloc] init];
            locationStorage.text = statusModel.location;
            locationStorage.font = UIFontMake(12);
            locationStorage.textColor = kWXBlue;
            locationStorage.frame = CGRectMake(nameTextStorage.left,
                                               lastImageStorage.bottom + 8,
                                               SCREEN_WIDTH - 80.0f,
                                               CGFLOAT_MIN);
          
            
            //生成时间的模型 dateTextStorage
            LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
            dateTextStorage.text = kStringIsEmpty(statusModel.createdTime) ? @"现在" : statusModel.createdTime;
            dateTextStorage.font = UIFontMake(12);
            dateTextStorage.textColor = [UIColor grayColor];
            dateTextStorage.frame = CGRectMake(nameTextStorage.left,
                                               locationStorage.bottom + 8,
                                               SCREEN_WIDTH - 80.0f,
                                               12);
            if (statusModel.personal) {
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:IMAGE_IDENTIFIER];
                imageStorage.tag = 999;
                imageStorage.frame = CGRectMake(dateTextStorage.right + 15, dateTextStorage.top, 15, 12);
                imageStorage.contents = kGetImage(@"visibleType");
                [self addStorage:imageStorage];
            }
            
            //删除模型模型 deleteTextStorage
            /*
            if (statusModel.own) {
                LWTextStorage* deleteTextStorage = [[LWTextStorage alloc] init];
                deleteTextStorage.text = @"删除";
                deleteTextStorage.font = UIFontMake(12);
                CGFloat deleteTextStorageY = dateTextStorage.right + (statusModel.personal ? 45 : 15);
                deleteTextStorage.frame = CGRectMake(deleteTextStorageY, dateTextStorage.top, 60.0f, 12);
                [deleteTextStorage lw_addLinkWithData:kLinkDelete
                                                range:NSMakeRange(0,deleteTextStorage.text.length)
                                            linkColor:kWXBlue
                                       highLightColor:UIColorHighLightColor];
                [self addStorage:deleteTextStorage];
            }
             */
            
            //菜单按钮
            CGRect menuPosition = CGRectZero;
            menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f,
                                      lastImageStorage.bottom,
                                      44.0f,
                                      44.0f);
            
            //生成评论背景Storage
            LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
            NSArray* commentTextStorages = @[];
            CGRect commentBgPosition = CGRectZero;
            CGRect rect = CGRectMake(60.0f,
                                     dateTextStorage.bottom + 5.0f,
                                     SCREEN_WIDTH - 80,
                                     20);
            
            CGFloat offsetY = 0.0f;
            //点赞
            LWImageStorage* likeImageSotrage = [[LWImageStorage alloc] init];
            LWTextStorage* likeTextStorage = [[LWTextStorage alloc] init];
            NSArray *likeArray = [statusModel.likeNames componentsSeparatedByString:@","];
            
            if (likeArray.count != 0) {
                likeImageSotrage.contents = [UIImage imageNamed:@"Like"];
                likeImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                    rect.origin.y + 12.0f + offsetY,
                                                    13.0f,
                                                    13.0f);
                
                NSMutableString* mutableString = [[NSMutableString alloc] init];
                NSMutableArray* composeArray = [[NSMutableArray alloc] init];
                
                int rangeOffset = 0;
                for (NSInteger i = 0;i < likeArray.count; i ++) {
                    NSString *likeName = likeArray[i];
                    [mutableString appendString:likeName];
                    NSRange range = NSMakeRange(rangeOffset, likeName.length);
                    [composeArray addObject:[NSValue valueWithRange:range]];
                    rangeOffset += likeName.length;
                    if (i != likeArray.count - 1) {
                        NSString* dotString = @",";
                        [mutableString appendString:dotString];
                        rangeOffset += dotString.length;
                    }
                }
                
                likeTextStorage.text = mutableString;
                likeTextStorage.font = UIFontPFMediumMake(14);
                likeTextStorage.frame = CGRectMake(likeImageSotrage.right + 5.0f,
                                                   rect.origin.y + 8.0f,
                                                   SCREEN_WIDTH - 110.0f,
                                                   CGFLOAT_MAX);
                for (NSValue* rangeValue in composeArray) {
                    NSRange range = [rangeValue rangeValue];
                    [likeTextStorage lw_addLinkWithData:kLinkLike
                                                  range:range
                                              linkColor:kWXBlue
                                         highLightColor:UIColorHighLightColor];
                }

                offsetY += likeTextStorage.height + 5.0f;
            }
            if (statusModel.comments.count != 0) {
                if (likeArray.count != 0) {
                    self.lineRect = CGRectMake(nameTextStorage.left,
                                               likeTextStorage.bottom + 2.5f,
                                               SCREEN_WIDTH - 80,
                                               0.5f);
                }
                
                NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.comments.count];
                for (SWStatusComment *commentM in statusModel.comments) {
                    if (kStringIsEmpty(commentM.toNickname) == false) {
                        NSString* commentString = [NSString stringWithFormat:@"%@回复%@：%@",
                                                   commentM.fromNickname,
                                                   commentM.toNickname,
                                                   commentM.comment];
                        
                        LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                        commentTextStorage.text = commentString;
                        commentTextStorage.font = UIFontMake(14);
                        commentTextStorage.textColor = RGBA(40, 40, 40, 1);
                        commentTextStorage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                              rect.origin.y + 10.0f + offsetY,
                                                              SCREEN_WIDTH - 95.0f,
                                                              CGFLOAT_MAX);
                        
                        [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentM
                                                                   highLightColor:UIColorHighLightColor];
                    
                        [commentTextStorage lw_addLinkWithData:kLinkLike
                                                         range:NSMakeRange(0,commentM.fromNickname.length)
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontPFMediumMake(14)
                                                highLightColor:UIColorHighLightColor];
                        
                        [commentTextStorage lw_addLinkWithData:kLinkLike
                                                         range:NSMakeRange(commentM.fromNickname.length + 2,commentM.toNickname.length)
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontPFMediumMake(14)
                                                highLightColor:UIColorHighLightColor];
                        
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:kWXBlue
                                                   highlightColor:UIColorHighLightColor];
                        [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                        
                        
                        
                        [tmp addObject:commentTextStorage];
                        offsetY += commentTextStorage.height;
                    } else {
                        NSString* commentString = [NSString stringWithFormat:@"%@：%@",
                                                   commentM.fromNickname,
                                                   commentM.comment];
                        
                        LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                        commentTextStorage.text = commentString;
                        commentTextStorage.font = UIFontMake(14);
                        commentTextStorage.textAlignment = NSTextAlignmentLeft;
                        commentTextStorage.linespacing = 2.0f;
                        commentTextStorage.textColor = RGBA(40, 40, 40, 1);
                        commentTextStorage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                              rect.origin.y + 10.0f + offsetY,
                                                              SCREEN_WIDTH - 95.0f,
                                                              CGFLOAT_MAX);
                        
                        [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentM
                                                                   highLightColor:UIColorHighLightColor];
                        [commentTextStorage lw_addLinkWithData:kLinkLike
                                                         range:NSMakeRange(0,commentM.fromNickname.length)
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontPFMediumMake(14)
                                                highLightColor:UIColorHighLightColor];
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:kWXBlue
                                                   highlightColor:UIColorHighLightColor];
                        [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                        [tmp addObject:commentTextStorage];
                        offsetY += commentTextStorage.height;
                    }
                }
                //如果有评论，设置评论背景Storage
                commentTextStorages = tmp;
            }
            if (likeArray.count > 0 || statusModel.comments.count > 0) {
                CGFloat commentBgPositionH = 15.0f;
                if (statusModel.comments.count == 0) {
                    commentBgPositionH = 5.0f;
                }
                commentBgPosition = CGRectMake(60.0f,
                                               dateTextStorage.bottom + 5.0f,
                                               SCREEN_WIDTH - 80,
                                               offsetY + commentBgPositionH);
                
                commentBgStorage.frame = commentBgPosition;
                commentBgStorage.contents = [UIImage imageNamed:@"comment"];
                [commentBgStorage stretchableImageWithLeftCapWidth:40
                                                      topCapHeight:15];
            }
            
            [self addStorage:avatarStorage];
            [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
            [self addStorage:contentTextStorage];
            [self addStorages:imageStorageArray];//通过一个数组来添加storage，使用这个方法
            [self addStorage:locationStorage];
            [self addStorage:dateTextStorage];
            [self addStorages:commentTextStorages];//通过一个数组来添加storage，使用这个方法
            [self addStorage:commentBgStorage];
            [self addStorage:likeImageSotrage];
            [self addStorage:likeTextStorage];
            self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
            self.menuPosition = menuPosition;//右下角菜单按钮的位置
            self.commentBgPosition = commentBgPosition;//评论灰色背景位置
            self.imagePostions = imagePositionArray;//保存图片位置的数组
            //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
            self.cellHeight = [self suggestHeightWithBottomMargin:10.0f];
        }
    }
    return self;
}

@end
