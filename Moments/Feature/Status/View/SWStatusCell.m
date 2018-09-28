//
//  SWStatusCell.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface SWStatusCell ()<LWAsyncDisplayViewDelegate>

@property (nonatomic,strong) UIButton *menuButton;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,copy) NSString *preCopyText;
@property (nonatomic,strong) UIImageView *videoIconView;

@end

@implementation SWStatusCell

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.asyncDisplayView];
        [self.contentView addSubview:self.menuButton];
        [self.contentView addSubview:self.menu];
        [self.contentView addSubview:self.line];
    }
    return self;
}

#pragma mark - LWAsyncDisplayViewDelegate

//额外的绘制
- (void)extraAsyncDisplayIncontext:(CGContextRef)context
                              size:(CGSize)size
                       isCancelled:(LWAsyncDisplayIsCanclledBlock)isCancelled {
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context,UIColorSeparator.CGColor);
    CGContextStrokePath(context);
    if (self.cellLayout.statusModel.type == 2) {
        CGContextAddRect(context, self.cellLayout.websitePosition);
        CGContextSetFillColorWithColor(context, RGBA(240, 240, 240, 1).CGColor);
        CGContextFillPath(context);
    }
}
//点击LWImageStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
   didCilickedImageStorage:(LWImageStorage *)imageStorage
                     touch:(UITouch *)touch{
    [self.menu menuHide];
    if ([imageStorage.identifier isEqualToString:MESSAGE_TYPE_VIDEO]) {
//        NSDictionary *imageDict = [self.cellLayout.statusModel.images firstObject];
//        //1、创建AVPlayer
//        AVPlayer *player1 = [AVPlayer playerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img2.ultimavip.cn/%@",imageDict[@"videoUrl"]]]];
//        //2、创建视频播放视图的控制器
//        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
//        //3、将创建的AVPlayer赋值给控制器自带的player
//        playerVC.player = player1;
//        //4、跳转到控制器播放
//        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//        [window.rootViewController presentViewController:playerVC animated:YES completion:NULL];
//        [playerVC.player play];
        
    } else {
        NSInteger tag = imageStorage.tag;
        //tag 0~8 是图片，9是头像， 233点击评论头像
        switch (tag) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:{
                if (self.clickedImageCallback) {
                    self.clickedImageCallback(self,tag);
                }
            }break;
            case 9: {
                if (self.clickedAvatarCallback) {
                    self.clickedAvatarCallback(self);
                }
            }break;
        }
    }
}

//点击LWTextStorage
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView
    didCilickedTextStorage:(LWTextStorage *)textStorage
                  linkdata:(id)data {
    [self.menu menuHide];
    if ([data isKindOfClass:[NSString class]]) {
        //折叠Cell
        if ([data isEqualToString:kLinkClose]) {
            if (self.clickedCloseCellCallback) {
                self.clickedCloseCellCallback(self);
            }
        }
        //展开Cell
        else if ([data isEqualToString:kLinkOpen]) {
            if (self.clickedOpenCellCallback) {
                self.clickedOpenCellCallback(self);
            }
        }
        
        //删除Cell
        else if ([data isEqualToString:kLinkDelete]) {
            if (self.clickedDeleteCellCallback) {
                self.clickedDeleteCellCallback(self);
            }
        }
        //其他
        else {
        }
    } else if ([data isKindOfClass:[NSDictionary class]]) {

    }
}


//长按内容文字
- (void)lwAsyncDisplayView:(LWAsyncDisplayView *)asyncDisplayView didLongpressedTextStorage:(LWTextStorage *)textStorage linkdata:(id)data {
    [self.menu menuHide];
    [self becomeFirstResponder];
    UIMenuItem* copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                      action:@selector(copyText)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    CGRect rect = CGRectMake(textStorage.center.x - 50.0f, textStorage.top, 100.0f, 50.0f);
    [UIMenuController sharedMenuController].arrowDirection = UIMenuControllerArrowDown;
    [[UIMenuController sharedMenuController] setTargetRect:rect inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    self.preCopyText = data;
}

//复制
- (void)copyText {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.preCopyText;
    [self resignFirstResponder];
    [self.asyncDisplayView removeHighlightIfNeed];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(copyText)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Actions
//点击菜单按钮
- (void)didClickedMenuButton {
    [self.menu clickedMenu];
    if (self.clickedMenuCallback) {
        self.clickedMenuCallback(self);
    }
}

//点击评论
- (void)didClickedCommentButton {
    if (self.clickedCommentButtonCallback) {
        [self.menu menuHide];
        self.clickedCommentButtonCallback(self);
    }
}

//点赞
- (void)didclickedLikeButton {
    if (self.clickedLikeButtonCallback) {
        [self.menu menuHide];
        self.clickedLikeButtonCallback(self);
    }
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    self.asyncDisplayView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.cellLayout.cellHeight);
    
    self.menuButton.frame = self.cellLayout.menuPosition;
    self.menu.frame = CGRectMake(self.cellLayout.menuPosition.origin.x + 10.0f,
                                 self.cellLayout.menuPosition.origin.y - 9.0f + 14.5f,0.0f,34.0f);
    self.line.frame = self.cellLayout.lineRect;
    CGRect videoImageRect = CGRectFromString([self.cellLayout.imagePostions firstObject]);
    self.videoIconView.frame = CGRectMake(videoImageRect.origin.x + videoImageRect.size.width/2-25, videoImageRect.origin.y + videoImageRect.size.height/2-25, 50, 50);
}

- (void)setCellLayout:(SWStatusCellLayout *)cellLayout {
    [self.menu menuHide];
    if (_cellLayout != cellLayout) {
        _cellLayout = cellLayout;
        self.asyncDisplayView.layout = _cellLayout;
        if (cellLayout.statusModel.type == 1) {
            [self.contentView addSubview:self.videoIconView];
        } else {
            [self.videoIconView removeFromSuperview];
        }
        self.menu.statusModel = self.cellLayout.statusModel;
    }
}

#pragma mark - Getter
- (LWAsyncDisplayView *)asyncDisplayView {
    if (_asyncDisplayView) {
        return _asyncDisplayView;
    }
    _asyncDisplayView = [[LWAsyncDisplayView alloc] init];
    _asyncDisplayView.delegate = self;
    _asyncDisplayView.displaysAsynchronously = NO;
    return _asyncDisplayView;
}

- (UIButton *)menuButton {
    if (_menuButton) {
        return _menuButton;
    }
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    _menuButton.imageEdgeInsets = UIEdgeInsetsMake(14.5f, 12.0f, 14.5f, 12.0f);
    [_menuButton addTarget:self action:@selector(didClickedMenuButton)
          forControlEvents:UIControlEventTouchUpInside];
    return _menuButton;
}

- (SWMenu *)menu {
    if (_menu) {
        return _menu;
    }
    _menu = [[SWMenu alloc] init];
    _menu.opaque = YES;
    [_menu.commentButton addTarget:self action:@selector(didClickedCommentButton)
                  forControlEvents:UIControlEventTouchUpInside];
    [_menu.likeButton addTarget:self action:@selector(didclickedLikeButton)
               forControlEvents:UIControlEventTouchUpInside];
    return _menu;
}

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [[UIView alloc] init];
    _line.backgroundColor = UIColorSeparator;
    return _line;
}

- (UIImageView *)videoIconView {
    if (!_videoIconView) {
        _videoIconView = [[UIImageView alloc] init];
        _videoIconView.backgroundColor = UIColorClear;
        _videoIconView.image = kGetImage(@"moment_video");
    }
    return _videoIconView;
}

@end
