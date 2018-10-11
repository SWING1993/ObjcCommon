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


@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorForBackground;
    [self setTitle:@"发现"];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

@end
