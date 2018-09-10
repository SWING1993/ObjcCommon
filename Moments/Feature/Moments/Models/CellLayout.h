

#import "LWLayout.h"
//#import "StatusModel.h"
#import "MomentEssayModel.h"
#import "ApproveModel.h"
#import "CommentModel.h"

#define MESSAGE_TYPE_IMAGE @"image"
#define MESSAGE_TYPE_WEBSITE @"website"
#define MESSAGE_TYPE_VIDEO @"video"
#define AVATAR_IDENTIFIER @"avatar"
#define IMAGE_IDENTIFIER @"image"
#define WEBSITE_COVER_IDENTIFIER @"cover"

#define kLinkOpen  @"open"
#define kLinkClose  @"close"
#define kLinkDelete @"delete"
#define kLinkUserId @"userId"
#define kLinkHref   @"href://"
#define kLinkPid    @"pid:"
#define kTopicId    @"topicId:"

@interface CellLayout : LWLayout <NSCopying>

@property (nonatomic,strong) MomentEssayModel* statusModel;
@property (nonatomic,strong) CommentModel* commentModel;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGRect lineRect;
@property (nonatomic,assign) CGRect menuPosition;
@property (nonatomic,assign) CGRect commentBgPosition;
@property (nonatomic,assign) CGRect avatarPosition;
@property (nonatomic,assign) CGRect websitePosition;
@property (nonatomic,copy) NSArray* imagePostions;

//文字过长时，折叠状态的布局模型
- (id)initWithStatusModel:(MomentEssayModel *)stautsModel
                    index:(NSInteger)index
            dateFormatter:(NSDateFormatter *)dateFormatter;


//文字过长时，打开状态的布局模型
- (id)initContentOpendLayoutWithStatusModel:(MomentEssayModel *)stautsModel
                                      index:(NSInteger)index
                              dateFormatter:(NSDateFormatter *)dateFormatter;



//详情界面的布局
- (id)initContentLayoutWithDetailStatusModel:(MomentEssayModel *)statusModel
                                       index:(NSInteger)index
                               dateFormatter:(NSDateFormatter *)dateFormatter;


//评论界面的布局
- (id)initContentLayoutWithCommentModel:(CommentModel *)commentModel
                                  index:(NSInteger)index
                          dateFormatter:(NSDateFormatter *)dateFormatter;

@end
