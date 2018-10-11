//
//  IndexViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexViewController.h"
#import "SWColorViewController.h"
#import "SWTheme.h"
#import "IndexHeaderView.h"

@interface IndexViewController ()<GADBannerViewDelegate> {
    CGFloat _gradientProgress;
    CGFloat _minAlphaOffset;
    CGFloat _maxAlphaOffset;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IndexHeaderView* tableViewHeader;
@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorForBackground;
}

- (void)initTableView {
    [super initTableView];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableViewHeader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _minAlphaOffset = SCREEN_WIDTH*0.65 - 2*self.qmui_navigationBarMaxYInViewCoordinator;
    _maxAlphaOffset = SCREEN_WIDTH*0.65 - self.qmui_navigationBarMaxYInViewCoordinator;
    
    NSArray *colorSELArr = @[@[[UIColor flatBlackColor],[UIColor flatBlackColorDark]],
                             @[[UIColor flatBlueColor],[UIColor flatBlueColorDark]],
                             @[[UIColor flatBrownColor],[UIColor flatBrownColorDark]],
                             @[[UIColor flatCoffeeColor],[UIColor flatCoffeeColorDark]],
                             @[[UIColor flatForestGreenColor],[UIColor flatForestGreenColorDark]],
                             @[[UIColor flatGrayColor],[UIColor flatGrayColorDark]],
                             @[[UIColor flatGreenColor],[UIColor flatGreenColorDark]],
                             @[[UIColor flatLimeColor],[UIColor flatLimeColorDark]],
                             @[[UIColor flatMagentaColor],[UIColor flatMagentaColorDark]],
                             @[[UIColor flatMaroonColor],[UIColor flatMaroonColorDark]],
                             @[[UIColor flatMintColor],[UIColor flatMintColorDark]],
                             @[[UIColor flatNavyBlueColor],[UIColor flatNavyBlueColorDark]],
                             @[[UIColor flatOrangeColor],[UIColor flatOrangeColorDark]],
                             @[[UIColor flatPinkColor],[UIColor flatPinkColorDark]],
                             @[[UIColor flatPlumColor],[UIColor flatPlumColorDark]],
                             @[[UIColor flatPowderBlueColor],[UIColor flatPowderBlueColorDark]],
                             @[[UIColor flatPurpleColor],[UIColor flatPurpleColorDark]],
                             @[[UIColor flatRedColor],[UIColor flatRedColorDark]],
                             @[[UIColor flatSandColor],[UIColor flatSandColorDark]],
                             @[[UIColor flatSkyBlueColor],[UIColor flatSkyBlueColorDark]],
                             @[[UIColor flatTealColor],[UIColor flatTealColorDark]],
                             @[[UIColor flatWatermelonColor],[UIColor flatWatermelonColorDark]],
                             @[[UIColor flatWhiteColor],[UIColor flatWhiteColorDark]],
                             @[[UIColor flatYellowColor],[UIColor flatYellowColorDark]]];
    
    
    self.dataSource = [NSMutableArray arrayWithCapacity:colorSELArr.count];
    for (int index = 0; index < colorSELArr.count; index ++) {
        NSArray *colors = [colorSELArr objectAtIndex:index];
        SWTheme *theme = [[SWTheme alloc] init];
        theme.firstColor = [colors firstObject];
        theme.lastColor = [colors lastObject];
        [self.dataSource addObject:theme];
    }
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = UIColorMakeX(33);
        cell.detailTextLabel.textColor = UIColorGray;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    SWTheme *theme = self.dataSource[indexPath.row];
    UIView *themeView = [[UIView alloc] init];
    themeView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, (kScreenW - 30), (70)) andColors:@[theme.firstColor,theme.lastColor]];
    themeView.layer.cornerRadius = 5;
    [cell.contentView addSubview:themeView];
    [themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - 30);
        make.height.mas_equalTo(70);
        make.center.mas_equalTo(cell.contentView);
    }];
 
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWColorViewController *controller = [[SWColorViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - YPNavigationBarConfigureStyle

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    if (_gradientProgress < 0.5) {
        configurations |= YPNavigationBarStyleBlack;
    }
    if (_gradientProgress == 1) {
        configurations |= YPNavigationBarBackgroundStyleOpaque;
    }
    configurations |= YPNavigationBarBackgroundStyleColor;
    return configurations;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor colorWithWhite:1 - _gradientProgress alpha:1];
}

- (UIColor *) yp_navigationBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:_gradientProgress];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat progress = (offsetY - _minAlphaOffset) / (_maxAlphaOffset - _minAlphaOffset);
    CGFloat gradientProgress = MIN(1, MAX(0, progress));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        [self yp_refreshNavigationBarStyle];
    }
}

- (IndexHeaderView *)tableViewHeader {
    if (_tableViewHeader) {
        return _tableViewHeader;
    }
    _tableViewHeader = [[IndexHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                         0.0f,
                                                                         SCREEN_WIDTH,
                                                                         SCREEN_WIDTH*0.55)];
//    _tableViewHeader.navHeight = self.qmui_navigationBarMaxYInViewCoordinator;
//    @weakify(self)
//    [_tableViewHeader.bg bk_whenTapped:^{
//        @strongify(self)
//        [self changeHeaderBG];
//    }];
//    [_tableViewHeader.avtar bk_whenTapped:^{
//        @strongify(self)
//        SWAuthorAddViewController *controller = [[SWAuthorAddViewController alloc] init];
//        @weakify(self)
//        controller.completeBlock = ^(SWAuthor *author) {
//            if (author) {
//                @strongify(self)
//                [[RLMRealm defaultRealm] beginWriteTransaction];
//                if (!kStringIsEmpty(author.nickname)) {
//                    self.user.nickname = author.nickname;
//                    self.tableViewHeader.nickname.text = author.nickname;
//                }
//                if (!kStringIsEmpty(author.avatar)) {
//                    self.user.avatar = author.avatar;
//                    self.tableViewHeader.avtar.image = [SWStatus getDocumentImageWithName:author.avatar];
//                }
//                [[RLMRealm defaultRealm] addObject:self.user];
//                [[RLMRealm defaultRealm] commitWriteTransaction];
//            }
//        };
//        [self.navigationController pushViewController:controller animated:YES];
//    }];
    return _tableViewHeader;
}

@end
