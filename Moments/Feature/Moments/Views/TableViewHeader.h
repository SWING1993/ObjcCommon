
#import <UIKit/UIKit.h>
#import "MomentUserInfoM.h"

@interface TableViewHeader : UIView

@property (nonatomic, strong) UIImageView *bg;
@property (nonatomic, strong) UIView *avtarBg;
@property (nonatomic, strong) UIImageView *avtar;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UIButton *moreStar;

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset;
- (void)refreshingAnimateBegin;
- (void)refreshingAnimateStop;

//- (void)configTableViewUserInfoM:(MomentUserInfoM *)infoM;

@end
