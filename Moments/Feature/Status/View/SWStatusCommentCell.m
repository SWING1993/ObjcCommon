//
//  SWStatusCommentCell.m
//  Moments
//
//  Created by 宋国华 on 2018/10/8.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusCommentCell.h"
#import "SWStatusCellLayout.h"

@interface commentCell : UITableViewCell<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) LWAsyncDisplayView* displayView;
@property (nonatomic,strong) SWStatusCellLayout* cellLayout;

@end

@implementation commentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.displayView];
    }
    return self;
}

- (void)setCellLayout:(SWStatusCellLayout *)cellLayout {
    if (_cellLayout != cellLayout) {
        _cellLayout = cellLayout;
        self.displayView.layout = _cellLayout;
    }
}

////点击LWImageStorage
//- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
//   didCilickedImageStorage:(LWImageStorage *)imageStorage
//                     touch:(UITouch *)touch{
//    NSInteger tag = imageStorage.tag;
//    //tag 0~8 是图片，9是头像， 233点击评论头像
//    if (tag == 233 && kStringIsEmpty(imageStorage.identifier) == false) {
//        HKNewUserDetailController *controller = [[HKNewUserDetailController alloc] initWithDetailUserId:imageStorage.identifier];
//        [AppDelegate pushVC:controller];
//    }
//}
//
////点击LWTextStorage
//- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
//    didCilickedTextStorage:(LWTextStorage *)textStorage
//                  linkdata:(id)data {
//
//    if ([data isKindOfClass:[NSDictionary class]]) {
//        if (kStringIsEmpty(data[kLinkUserId]) == false) {
//            HKNewUserDetailController *controller = [[HKNewUserDetailController alloc] initWithDetailUserId:data[kLinkUserId]];
//            [AppDelegate pushVC:controller];
//        }
//    }
//}


- (void)layoutSubviews {
    self.displayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
}

- (LWAsyncDisplayView *)displayView {
    if (_displayView) {
        return _displayView;
    }
    _displayView = [[LWAsyncDisplayView alloc] initWithFrame:CGRectZero];
    _displayView.backgroundColor = UIColorClear;
    _displayView.delegate = self;
    return _displayView;
}

@end


@interface SWStatusCommentCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView*commentTableView;
@property (nonatomic,strong)NSArray*commentLayouts;
@property (nonatomic,strong)UIImageView*bgView;
@property (nonatomic,strong)UIView*lineView;

@end

@implementation SWStatusCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorWhite;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.commentTableView];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
- (void)_layoutSubviews {
    CGFloat bgViewTop;
    CGFloat tableViewTop;

    if (self.status.likes.count > 0) {
        bgViewTop = - 15;
        tableViewTop = 0;
        self.lineView.hidden = NO;
        self.lineView.frame = CGRectMake(10, 0, kScreenW - 20, 0.5);
    } else {
        bgViewTop = 0.5;
        tableViewTop = 10;
        self.lineView.hidden = YES;
    }
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgViewTop);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tableViewTop);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)_removeLayoutSubviews {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    [self.commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

- (void)setStatus:(SWStatus *)status {
    _status = status;
    [self configDataSource];
}


- (void)configDataSource {
    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:self.status.comments.count];
    for (int i = 0; i < self.status.comments.count; i ++) {
        SWStatusComment * comment = self.status.comments[i];
        [layouts addObject:[[SWStatusCellLayout alloc] initWithCommentModel:comment index:i]];
    }
    self.commentLayouts = layouts;
    if (self.commentLayouts.count > 0) {
        [self _layoutSubviews];
        [self.commentTableView reloadData];
    } else {
        [self _removeLayoutSubviews];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.status.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWStatusCellLayout* layout = self.commentLayouts[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    commentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[commentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    SWStatusCellLayout* layout = self.commentLayouts[indexPath.row];
    cell.cellLayout = layout;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWStatusCellLayout* layout = self.commentLayouts[indexPath.row];
    if (self.clickedReCommentCallback) {
        self.clickedReCommentCallback(layout.commentModel);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableView *)commentTableView {
    if (_commentTableView) {
        return _commentTableView;
    }
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _commentTableView.backgroundColor = UIColorClear;
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableView.scrollEnabled = NO;
    _commentTableView.estimatedRowHeight = CGFLOAT_MIN;
    _commentTableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    _commentTableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
    return _commentTableView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [kGetImage(@"comment") stretchableImageWithLeftCapWidth:40
                                                                   topCapHeight:15];
    }
    return _bgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorSeparator;
    }
    return _lineView;
}

+ (CGFloat)cellHeightWithStatus:(SWStatus *)status {
    if (status.comments.count == 0) {
        return CGFLOAT_MIN;
    }
    CGFloat height = status.likes.count > 0 ? 0.0f : 10.0f;
    for (SWStatusComment *comment in status.comments) {
        SWStatusCellLayout *layout = [[SWStatusCellLayout alloc] initWithCommentModel:comment index:0];;
        height += layout.cellHeight;
    }
    return height;
}

@end
