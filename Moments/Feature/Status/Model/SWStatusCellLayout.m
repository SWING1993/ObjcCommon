//
//  SWStatusCellLayout.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusCellLayout.h"
#import "SWStatusLike.h"
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

- (id)initWithStatusModel:(SWStatus *)statusModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.statusModel = statusModel;
            //头像模型 avatarImageStorage
            LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:AVATAR_IDENTIFIER];
//            avatarStorage.contents = @"头像";
//            avatarStorage.placeholder = kPlaceholderImage;
            avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
            avatarStorage.backgroundColor = [UIColor whiteColor];
            avatarStorage.frame = CGRectMake(10, 20, 40, 40);
            avatarStorage.tag = 9;
            avatarStorage.cornerBorderWidth = 1.0f;
            avatarStorage.cornerBorderColor = [UIColor grayColor];
            
            //名字模型 nameTextStorage
            LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
            nameTextStorage.text = statusModel.nickname;
            nameTextStorage.font = UIFontPFMediumMake(16);
            nameTextStorage.frame = CGRectMake(60.0f, 20.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
//            [nameTextStorage lw_addLinkWithData:@""
//                                          range:NSMakeRange(0,statusModel.nickname.length)
//                                      linkColor:kWXBlue
//                                 highLightColor:RGBA(0, 0, 0, 0.15)];
            
            //正文内容模型 contentTextStorage
            LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
            contentTextStorage.maxNumberOfLines = 5;//设置最大行数，超过则折叠
            contentTextStorage.linespacing = 1.0f;
            contentTextStorage.font = UIFontMake(15);
            contentTextStorage.textColor = RGBA(40, 40, 40, 1);
            contentTextStorage.text = statusModel.content;
            if (kStringIsEmpty(contentTextStorage.text) == false) {
                NSString *str = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
                NSError *error;
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:str options:NSRegularExpressionCaseInsensitive error:&error];
                NSArray *resultArray = [expression matchesInString:contentTextStorage.text options:0 range:NSMakeRange(0, contentTextStorage.text.length)];
                NSMutableAttributedString * replaceStr = [[NSMutableAttributedString alloc] initWithString:@"🔗网页链接" attributes:nil];
                for (NSInteger i = resultArray.count-1; i>= 0; i--) {
                    NSTextCheckingResult *match = resultArray[i];
                    NSString * subStringForMatch = [contentTextStorage.attributedText.string substringWithRange:match.range];
                    [contentTextStorage.attributedText replaceCharactersInRange:match.range withAttributedString:replaceStr];
                    [contentTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@%@",kLinkHref,subStringForMatch]
                                                     range:[contentTextStorage.attributedText.string rangeOfString:replaceStr.string]
                                                 linkColor:UIColorLink
                                            highLightColor:RGBA(0, 0, 0, 0.15f)];
                }
            }
            
            contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                                  nameTextStorage.bottom,
                                                  SCREEN_WIDTH - 80.0f,
                                                  CGFLOAT_MAX);
            CGFloat contentBottom = contentTextStorage.bottom;
            //折叠的条件
            if (contentTextStorage.isTruncation) {
                contentTextStorage.frame = CGRectMake(nameTextStorage.left,
                                                      nameTextStorage.bottom,
                                                      SCREEN_WIDTH - 80.0f,
                                                      CGFLOAT_MAX);
                
                LWTextStorage* openStorage = [[LWTextStorage alloc] init];
                openStorage.font = UIFontMake(15);
                openStorage.textColor = RGBA(40, 40, 40, 1);
                openStorage.frame = CGRectMake(nameTextStorage.left,
                                               contentTextStorage.bottom + 5.0f,
                                               200.0f,
                                               30.0f);
                openStorage.text = @"全文";
                [openStorage lw_addLinkWithData:kLinkOpen
                                          range:NSMakeRange(0, openStorage.text.length)
                                      linkColor:UIColorLink
                                 highLightColor:RGBA(0, 0, 0, 0.15f)];
                [self addStorage:openStorage];
                contentBottom = openStorage.bottom;
            }
            //解析表情和主题
            //解析表情、主题、网址
            [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
            [LWTextParser parseHttpURLWithTextStorage:contentTextStorage
                                            linkColor:UIColorLink
                                       highlightColor:RGBA(0, 0, 0, 0.15f)];
            
            //添加长按复制
            [contentTextStorage lw_addLongPressActionWithData:contentTextStorage.text
                                               highLightColor:RGBA(0, 0, 0, 0.25f)];
            
            //发布的图片模型 imgsStorage
            CGFloat imageWidth = (SCREEN_WIDTH - 110.0f)/3.0f;
            NSInteger imageCount = [statusModel.images count];
            NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
            
            // type 4 视频
            if ([statusModel.type isEqualToString:@"4"]) {
                NSDictionary *imageDict = [statusModel.images objectAtIndex:0];
                CGFloat height = [imageDict[@"videoHeight"] floatValue];
                CGFloat width = [imageDict[@"videoWidth"] floatValue];
                
                CGFloat x = width/height;
                if (x > 2.5f) {
                    x = 2.5f;
                }
                if (x < 0.4f) {
                    x = 0.4f;
                }
                
                CGRect imageRect;
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
//                imageStorage.contents = [HKConfig complementedImageURLWithComponent:imageDict[@"videoImageUrl"] withImageLongEdge:imageWidth*3 withImageShortEdge:imageWidth*3];
                [imageStorageArray addObject:imageStorage];
            } else {
                BOOL isImageData = [[statusModel.images firstObject] isKindOfClass:[UIImage class]] ? YES: NO;
                NSInteger row = 0;
                NSInteger column = 0;
                if (imageCount == 1) {
                    CGFloat height;
                    CGFloat width;
                    if (isImageData) {
                        UIImage *image = [statusModel.images firstObject];
                        height = image.size.height;
                        width = image.size.width;
                    } else {
                        NSDictionary *imageDict = [statusModel.images objectAtIndex:0];
                        height = [imageDict[@"height"] floatValue];
                        width = [imageDict[@"width"] floatValue];
                    }
                    CGFloat x = width/height;
                    if (x > 2.5f) {
                        x = 2.5f;
                    }
                    if (x < 0.4f) {
                        x = 0.4f;
                    }
                    CGRect imageRect;
                    if (x == 1.0f) {
                        imageRect = CGRectMake(nameTextStorage.left,
                                               contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               imageWidth*1.7,
                                               imageWidth*1.7);
                    } else if (x > 1.0f) {
                        CGFloat h = imageWidth*1.7;
                        CGFloat w = MIN(h*x, imageWidth*3);
                        imageRect = CGRectMake(nameTextStorage.left,
                                               contentBottom + 5.0f + (row * (imageWidth + 5.0f)),
                                               w,
                                               h);
                    } else  {
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
                    if (isImageData) {
                        imageStorage.contents = [statusModel.images firstObject];
                    } else {
                        NSDictionary *imageDict = [statusModel.images objectAtIndex:0];
//                        imageStorage.contents = [HKConfig complementedImageURLWithComponent:imageDict[@"url"] withImageLongEdge:imageWidth*3 withImageShortEdge:imageWidth*3];
                    }
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
                        
                        if (isImageData) {
                            UIImage *image = [statusModel.images objectAtIndex:i];
                            imageStorage.contents = image;
                        } else {
                            NSDictionary *imageDict = [statusModel.images objectAtIndex:i];
//                            imageStorage.contents = [HKConfig complementedImageURLWithComponent:imageDict[@"url"] withImageLongEdge:imageWidth withImageShortEdge:imageWidth];
                        }
                        
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
                                              contentBottom + 5.0f,
                                              0,
                                              0);
                lastImageStorage.frame = imageRect;
            }
            
            //生成时间的模型 dateTextStorage
            LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
            dateTextStorage.text = @"12年 xx日";
            dateTextStorage.font = UIFontMake(12);
            dateTextStorage.textColor = [UIColor grayColor];
            dateTextStorage.frame = CGRectMake(nameTextStorage.left,
                                               lastImageStorage.bottom,
                                               SCREEN_WIDTH - 80.0f,
                                               CGFLOAT_MAX);
            
            //菜单按钮
            CGRect menuPosition = CGRectZero;
            menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f,
                                      lastImageStorage.bottom - 14.5f,
                                      44.0f,
                                      44.0f);
            
            BOOL visible = YES;
            if (visible) {
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:IMAGE_IDENTIFIER];
                imageStorage.tag = 999;
                imageStorage.frame = CGRectMake(dateTextStorage.right + 15, dateTextStorage.frame.origin.y + 5, 15, 10);
                imageStorage.contents = kGetImage(@"visibleType");
                [self addStorage:imageStorage];
            }
            
            //删除模型模型 deleteTextStorage
            if (visible) {
                LWTextStorage* deleteTextStorage = [[LWTextStorage alloc] init];
                deleteTextStorage.text = @"删除";
                deleteTextStorage.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
                CGFloat deleteTextStorageY;
                if (visible) {
                    deleteTextStorageY = dateTextStorage.right + 45;
                } else {
                    deleteTextStorageY = dateTextStorage.right + 15;
                }
                deleteTextStorage.frame = CGRectMake(deleteTextStorageY, dateTextStorage.top, 60.0f, dateTextStorage.height);
                [deleteTextStorage lw_addLinkWithData:kLinkDelete
                                                range:NSMakeRange(0,deleteTextStorage.text.length)
                                            linkColor:UIColorLink
                                       highLightColor:RGBA(0, 0, 0, 0.15)];
                [self addStorage:deleteTextStorage];
            }
            
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
            if (statusModel.essayApproves.count != 0) {
                likeImageSotrage.contents = [UIImage imageNamed:@"Like"];
                likeImageSotrage.frame = CGRectMake(rect.origin.x + 10.0f,
                                                    rect.origin.y + 10.5f + offsetY,
                                                    13.0f,
                                                    13.0f);
                
                NSMutableString* mutableString = [[NSMutableString alloc] init];
                NSMutableArray* composeArray = [[NSMutableArray alloc] init];
                
                int rangeOffset = 0;
                for (NSInteger i = 0;i < statusModel.essayApproves.count; i ++) {
                    SWStatusLike *model = statusModel.essayApproves[i];
                    if (kStringIsEmpty(model.fromUserNickname) == false) {
                        [mutableString appendString:model.fromUserNickname];
                    }
                    NSRange range = NSMakeRange(rangeOffset, model.fromUserNickname.length);
                    [composeArray addObject:[NSValue valueWithRange:range]];
                    rangeOffset += model.fromUserNickname.length;
                    if (i != statusModel.essayApproves.count - 1) {
                        NSString* dotString = @"，";
                        [mutableString appendString:dotString];
                        rangeOffset += 1;
                    }
                }
                
                likeTextStorage.text = mutableString;
                likeTextStorage.font = UIFontMake(14);
                likeTextStorage.frame = CGRectMake(likeImageSotrage.right + 5.0f,
                                                   rect.origin.y + 7.0f,
                                                   SCREEN_WIDTH - 110.0f,
                                                   CGFLOAT_MAX);
                for (int index = 0; index < composeArray.count; index ++) {
                    NSValue* rangeValue = composeArray[index];
                    NSRange range = [rangeValue rangeValue];
                    SWStatusLike *model = statusModel.essayApproves[index];
                    [likeTextStorage lw_addLinkWithData:model
                                                  range:range
                                              linkColor:UIColorLink
                                         highLightColor:RGBA(0, 0, 0, 0.15)];
                }
                offsetY += likeTextStorage.height + 5.0f;
            }
            if (statusModel.essayComments.count != 0 && statusModel.essayComments != nil) {
                if (self.statusModel.essayApproves.count != 0) {
                    self.lineRect = CGRectMake(nameTextStorage.left,
                                               likeTextStorage.bottom + 2.5f,
                                               SCREEN_WIDTH - 80,
                                               0.5f);
                }
                
                NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.essayComments.count];
                for (SWStatusComment *commentM in statusModel.essayComments) {
                    commentM.index = index;
                    if (kStringIsEmpty(commentM.commentId) == false) {
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
                                                                   highLightColor:RGBA(0, 0, 0, 0.15)];
                        
                        [commentTextStorage lw_addLinkWithData:@{kLinkUserId:commentM.fromUserId?:@""}
                                                         range:NSMakeRange(0,[commentM.fromNickname length])
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontMake(14)
                                                highLightColor:RGBA(0, 0, 0, 0.15)];
                        
                        [commentTextStorage lw_addLinkWithData:@{kLinkUserId:commentM.toUserId?:@""}
                                                         range:NSMakeRange([commentM.fromNickname length] + 2,
                                                                           [commentM.toNickname length])
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontPFMediumMake(14)
                                                highLightColor:RGBA(0, 0, 0, 0.15)];
                        
                        
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:kWXBlue
                                                   highlightColor:RGBA(0, 0, 0, 0.15)];
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
                                                                   highLightColor:RGBA(0, 0, 0, 0.15)];
                        
                        [commentTextStorage lw_addLinkWithData:@{kLinkUserId:commentM.fromUserId?:@""}
                                                         range:NSMakeRange(0,[commentM.fromNickname length])
                                                     linkColor:kWXBlue
                                                      linkFont:UIFontPFMediumMake(14)
                                                highLightColor:RGBA(0, 0, 0, 0.15)];
                        
                        [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                        linkColor:kWXBlue
                                                   highlightColor:RGBA(0, 0, 0, 0.15)];
                        [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                        [tmp addObject:commentTextStorage];
                        offsetY += commentTextStorage.height;
                    }
                }
                //如果有评论，设置评论背景Storage
                commentTextStorages = tmp;
            }
            if (statusModel.essayApproves.count > 0 || statusModel.essayComments.count > 0) {
                CGFloat commentBgPositionH = 15.0f;
                if (statusModel.essayComments.count == 0) {
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
            
            [self addStorage:nameTextStorage];//将Storage添加到遵循LWLayoutProtocol协议的类
            [self addStorage:contentTextStorage];
            [self addStorage:dateTextStorage];
            [self addStorages:commentTextStorages];//通过一个数组来添加storage，使用这个方法
            [self addStorage:avatarStorage];
            [self addStorage:commentBgStorage];
            [self addStorage:likeImageSotrage];
            [self addStorages:imageStorageArray];//通过一个数组来添加storage，使用这个方法
            if (likeTextStorage) {
                [self addStorage:likeTextStorage];
            }
            self.avatarPosition = CGRectMake(10, 20, 40, 40);//头像的位置
            self.menuPosition = menuPosition;//右下角菜单按钮的位置
            self.commentBgPosition = commentBgPosition;//评论灰色背景位置
            self.imagePostions = imagePositionArray;//保存图片位置的数组
            //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
            self.cellHeight = [self suggestHeightWithBottomMargin:15.0f];
        }
    }
    return self;
}

@end
