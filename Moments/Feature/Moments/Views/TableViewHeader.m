
#import "TableViewHeader.h"
#import "Gallop.h"

@interface TableViewHeader ()

@property (nonatomic,strong) UIImageView* loadingView;

@end

@implementation TableViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,-frame.size.height-44,SCREEN_WIDTH,frame.size.height*2)];
//        displayView.backgroundColor = uicolor(46, 49, 50);
        [self addSubview:displayView];
        [self addSubview:self.loadingView];
        
        self.bg = [[UIImageView alloc] init];
        self.bg.userInteractionEnabled = YES;
//        [self.bg sd_setImageWithURL:[HKConfig fullImageURLWithComponent:[User sharedManager].clubBackgroundImg] placeholderImage:kGetImage(@"profilebg")];
        self.bg.contentMode = UIViewContentModeScaleAspectFill;
        self.bg.frame = CGRectMake(0.0f, displayView.bounds.size.height - SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_WIDTH);
        self.bg.clipsToBounds = YES;
        [displayView addSubview:self.bg];
        
        UIImage *imgMask = [UIImage imageNamed:@"MaskPPAlbum"];
        imgMask = [imgMask stretchableImageWithLeftCapWidth:kScreenW/2 topCapHeight:0];
        UIImageView * imageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bg.frame.size.height - 45, kScreenW, 45)];
        [imageMask setBackgroundColor:kColorClear];
        [imageMask setImage:imgMask];
        [imageMask setContentMode:UIViewContentModeScaleAspectFill];
        [imageMask setClipsToBounds:YES];
        [self.bg addSubview:imageMask];
        
        self.avtarBg = [[UIView alloc] init];
        self.avtarBg.frame = CGRectMake(SCREEN_WIDTH - 80.0f, displayView.bounds.size.height - 50.0f, 70.0f, 70.0f);
//        self.avtarBg.backgroundColor = KNoDataBackView;
        [displayView addSubview:self.avtarBg];
        
        self.avtar = [[UIImageView alloc] init];
        self.avtar.userInteractionEnabled = YES;
//        [self.avtar sd_setImageWithURL:[HKConfig complementedImageURLWithComponent:[User sharedManager].avatar withImageLongEdge:70.0f withImageShortEdge:70.0f] placeholderImage:kPlaceholderImage];
        self.avtar.frame = CGRectMake(0.5f, 0.5f, 69.0f, 69.0f);
        self.avtar.layer.borderColor = kColorWhite.CGColor;
        self.avtar.layer.borderWidth = 2.5f;
        [self.avtarBg addSubview:self.avtar];
        
        self.nickname = [[UILabel alloc] init];
//        self.nickname.text = [User sharedManager].nickname;
//        self.nickname.font = [UIFont kMediumFont:21];
        self.nickname.textAlignment = NSTextAlignmentRight;
        self.nickname.textColor = kColorWhite;
        [self.nickname setShadowColor:HKRGBAColor(33,34,39,1)];
        [self.nickname setShadowOffset:CGSizeMake(0, 1)];
        self.nickname.frame = CGRectMake(10.0f,displayView.bounds.size.height - 30, SCREEN_WIDTH - 110.0f, 25);
        [displayView addSubview:self.nickname];
        
        CGFloat btnWidth = kScaleFrom_iPhone6_Desgin(130);
        CGFloat btnHeight = btnWidth * 72/369;
        self.moreStar = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreStar.userInteractionEnabled = YES;
        [self.moreStar setImage:kGetImage(@"more_star") forState:UIControlStateNormal];
        self.moreStar.frame = CGRectMake(kScreenW - 10 - btnWidth, 10, btnWidth, btnHeight);
        [self.moreStar addTarget:self action:@selector(clickMoreStar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreStar];
    }
    return self;
}

- (void)clickMoreStar {
 
}

- (UIImageView *)loadingView {
    if (_loadingView) {
        return _loadingView;
    }
    _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f,-60.0f,25.0f,25.0f)];
    _loadingView.contentMode = UIViewContentModeScaleAspectFill;
    _loadingView.image = [UIImage imageNamed:@"loading"];
    _loadingView.clipsToBounds = YES;
    _loadingView.backgroundColor = [UIColor clearColor];
    return _loadingView;
}

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset {
    if (offset <= 0 && offset > - 200.0f) {
        self.loadingView.transform = CGAffineTransformMakeRotation(offset* 0.1);
    }
}

- (void)refreshingAnimateBegin {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimations"];
}

- (void)refreshingAnimateStop {
    [self.loadingView.layer removeAllAnimations];
}

@end
