//
//  MomentEssayModel.h
//  BlackCard
//
//  Created by Song on 2017/5/17.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "ApproveModel.h"

typedef NS_ENUM(NSUInteger, HKPersonalPhotoAlbumType) {
    HKPersonalPhotoAlbumTypeNote = 0,
    HKPersonalPhotoAlbumTypeZero,
    HKPersonalPhotoAlbumTypeDate,
    HKPersonalPhotoAlbumTypeYear,
};

@interface MomentEssayModel : NSObject

@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *failedIndex;
@property (nonatomic, copy  ) NSString *topicId;
@property (nonatomic, copy  ) NSString *topicName;
@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, strong) NSAttributedString *attContent;
@property (nonatomic, strong) NSAttributedString *attwhiteContent;
// 举报详情
@property (nonatomic, copy  ) NSString *reportId;
@property (nonatomic, copy  ) NSString *reportUserId;
@property (nonatomic, copy  ) NSString *reportNickname;
@property (nonatomic, copy  ) NSString *reportTypeFlag;
@property (nonatomic, copy  ) NSString *reportNote;

/** 时间戳 */
@property (nonatomic, assign) long long created;
@property (nonatomic, assign) long long checkTime;
@property (nonatomic, assign) long long updated;
@property (nonatomic, copy  ) NSString *nickname;
/** 类型：4=视频, 1=文本，2=图片，3=图文 */
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *userHeadurl;
/** 发表心情消息的用户id */
@property (nonatomic, copy  ) NSString *userId;
@property (nonatomic, assign) BOOL delFlag;
/** 隐藏标志位，0为未隐藏，1为已隐藏 */
@property (nonatomic, assign) BOOL hideFlag;
@property (nonatomic, assign) BOOL fromFlag;
/** 点赞标志位，0为当前用户未点赞，1为当前用户已点赞 */
@property (nonatomic, assign) BOOL approveFlag;
/** 广告标志位，0为普通心情消息，1为广告 */
@property (nonatomic, assign) BOOL advertFlag;
//广告右上角标签标志位，0时右上角显示"广告"，1时右上角显示"推荐"
@property (nonatomic, assign) NSInteger advertTagFlag;
//advertType为0(h5页面)时，为h5页面地址，advertType为1(商品详情)时，为商品详情id
@property (nonatomic, assign) NSInteger advertType;
@property (nonatomic, copy  ) NSString *advertOptionId;
/** 置顶标志位，0为未置顶，1为置顶 */
@property (nonatomic, assign) BOOL topFlag;
/** 屏蔽标志位，0为未屏蔽，1为已屏蔽 */
@property (nonatomic, assign) BOOL shieldFlag;
@property (nonatomic, assign) BOOL checkFlag;
/** 是否显示拍照图标 */
@property (nonatomic, assign) BOOL isCamera;
/** 个人主页的文本高度 */
@property (nonatomic, assign) CGFloat content_h;
/** 临时的图片数组-个人主页使用 */
@property (nonatomic, strong) NSMutableArray *arrayImages;
/** 0不使用毛玻璃效果，1使用毛玻璃效果 */
@property (nonatomic, assign) BOOL maskFlag;
/** 可见类型，0为仅好友可见，1为公开，会在大厅显示。 */
@property (nonatomic, assign) NSInteger visibleType;
/** 赞数量 */
@property (nonatomic, assign) NSInteger approvesCnt;
/** 评论数量 */
@property (nonatomic, assign) NSInteger commentsCnt;
@property (nonatomic, assign) NSInteger authType;
@property (nonatomic, retain) NSArray *authImgs;
@property (nonatomic, strong) NSArray <CommentModel*>*essayComments;
@property (nonatomic, strong) NSArray <ApproveModel*>*essayApproves;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy  ) NSString *dateText;
@property (nonatomic, copy  ) NSString *yearText;
@property (nonatomic, assign) BOOL dateHidden;
@property (nonatomic, assign) BOOL yearHidden;
@property (nonatomic, assign) HKPersonalPhotoAlbumType photoType;
@property (nonatomic, strong) UILabel *lblMessage;

+ (NSArray *)getMomentRowHeightsWithModels:(NSArray *)models;

@end
