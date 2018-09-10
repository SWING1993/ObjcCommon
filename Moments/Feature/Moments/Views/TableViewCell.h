#import <UIKit/UIKit.h>
#import "CellLayout.h"
#import "Gallop.h"
#import "CommentModel.h"
#import "Menu.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
@property (nonatomic,assign) BOOL displaysAsynchronously;//是否异步绘制
@property (nonatomic,assign) BOOL notNeedLine;//是否异步绘制
@property (nonatomic,strong) Menu* menu;
@property (nonatomic,strong) CellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,copy) void(^clickedImageCallback)(TableViewCell* cell,NSInteger imageIndex);
@property (nonatomic,copy) void(^clickedLikeButtonCallback)(TableViewCell* cell,BOOL isLike);
@property (nonatomic,copy) void(^clickedAvatarCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedReCommentCallback)(TableViewCell* cell,CommentModel* model);
@property (nonatomic,copy) void(^clickedCommentButtonCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedOpenCellCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedCloseCellCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedDeleteCellCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedVisibleCellCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedMenuCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedToUserInfoCallback)(NSString* userId);
@property (nonatomic,copy) void(^clickedToLinkURLCallback)(NSString* url);
@property (nonatomic,copy) void(^clickedToLinkPidCallback)(NSString* pid);
@property (nonatomic,copy) void(^clickedToTopicCallback)(NSString* topicId);

// 管理员操作
@property (nonatomic,copy) void(^clickedManagerDeleteCallback)(TableViewCell* cell);
@property (nonatomic,copy) void(^clickedManagerHideCallback)(TableViewCell* cell,BOOL isHide);
@property (nonatomic,copy) void(^clickedManagerShieldCallback)(TableViewCell* cell, BOOL isShield);

@end


