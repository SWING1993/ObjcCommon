
#import <UIKit/UIKit.h>
#import "LikeButton.h"
#import "MomentEssayModel.h"

@interface Menu : UIView

//管理员操作
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *hideButton;
@property (nonatomic,strong) UIButton *shieldButton;

//普通用户
@property (nonatomic,strong) LikeButton *likeButton;
@property (nonatomic,strong) UIButton *commentButton;

@property (nonatomic,strong) MomentEssayModel *statusModel;

- (void)clickedMenu;
- (void)menuShow;
- (void)menuHide;

@end
