//
//  MomentEssayModel.m
//  BlackCard
//
//  Created by Song on 2017/5/17.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import "MomentEssayModel.h"
#import "MomentsController.h"


@implementation MomentEssayModel

- (void)setEssayComments:(NSArray<CommentModel *> *)essayComments {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:essayComments.count];
    for (NSDictionary *data in essayComments) {
        CommentModel *model = [CommentModel mj_objectWithKeyValues:data];
        [tempArr addObject:model];
    }
    _essayComments = [tempArr copy];
}

- (void)setEssayApproves:(NSArray<ApproveModel *> *)essayApproves {
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:essayApproves.count];
    for (NSDictionary *data in essayApproves) {
        ApproveModel *model = [ApproveModel mj_objectWithKeyValues:data];
        [tempArr addObject:model];
    }
    _essayApproves = [tempArr copy];
}

- (HKPersonalPhotoAlbumType)photoType {
    _photoType = HKPersonalPhotoAlbumTypeNote;
    if (!self.yearHidden) {
        _photoType = HKPersonalPhotoAlbumTypeYear;
    } else {
        if (!self.dateHidden) {
            _photoType = HKPersonalPhotoAlbumTypeDate;
        }
    }
    return _photoType;
}

- (NSDate *)date {
    if (_date == nil) {
        if (self.created > 0) {
            _date = [NSDate dateWithTimeIntervalSince1970:self.created/1000];
        }
    }
    return _date;
}

- (NSString *)dateText {
    if (_dateText == nil) {
        _dateText = [self.date stringBySendDate];
    }
    return _dateText;
}

- (NSString *)yearText {
    if (_yearText == nil) {
        _yearText = [self.date yearTextBySendDate];
    }
    return _yearText;
}

- (UILabel *)lblMessage {
    if (_lblMessage == nil) {
        _lblMessage = [UILabel new];
        [_lblMessage setBackgroundColor:[UIColor clearColor]];
        [_lblMessage setTextAlignment:NSTextAlignmentLeft];
        [_lblMessage setFont:[UIFont systemFontOfSize:15]];
        [_lblMessage setTextColor:[UIColor blackColor]];
        [_lblMessage setNumberOfLines:0];
    }
    return _lblMessage;
}

- (CGFloat)content_h {
    if (_content_h == 0.0) {
        CGFloat origin_x = self.images.count > 0 ? 79.0 : 2;
        CGSize size_msg = CGSizeMake(kScreenW-(origin_x+18.0), 20.0);
        if (![NSString isBlankString:self.content]) {
            [self.lblMessage setAttributedText:self.attContent];
            size_msg = [self.lblMessage sizeThatFits:CGSizeMake(size_msg.width, MAXFLOAT)];
            size_msg.height = MIN(46.0, size_msg.height);
        }
        _content_h = MAX(24.0, size_msg.height);
    }
    return _content_h;
}

+ (NSArray *)getMomentRowHeightsWithModels:(NSArray *)models {
    NSArray *rowHeights = [[models.rac_sequence map:^id(MomentEssayModel *model) {
        return [[NSNumber alloc]initWithFloat:[EssayListCell cellHeightWithObj:model]];
    }] array];
    return rowHeights;
}


@end
