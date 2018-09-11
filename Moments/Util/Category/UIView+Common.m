//
//  UIView+Common.m
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (CAGradientLayer *)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    if (cgColorArray && [cgColorArray count] > 0) {
        layer.colors = cgColorArray;
    }else{
        return nil;
    }
    if (floatNumArray && [floatNumArray count] == [cgColorArray count]) {
        layer.locations = floatNumArray;
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)addShakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.5;
    animation.additive = YES;
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void)addJitterAnimation {
    CAKeyframeAnimation *animationY = [CAKeyframeAnimation animation];
    animationY.keyPath = @"position.y";
    animationY.values = @[ @0, @5, @-5, @5, @0 ];
    animationY.keyTimes = @[ @0, @0.1, @0.3, @0.5, @1 ];
    animationY.duration = 0.5;
    animationY.additive = YES;
    [self.layer addAnimation:animationY forKey:@"shake"];
}

- (void)addScaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    self.layer.anchorPoint = CGPointMake(.5,.5);
    animation.fromValue = @0.9f;
    animation.toValue = @1.10f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [animation setAutoreverses:NO];
    animation.duration = 0.3;
    [self.layer addAnimation:animation forKey:@"scale"];
}

- (void)addBoomAnimationColor:(UIColor *)color {
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    [emitter setEmitterSize:CGSizeMake(20, 20)];
    emitter.emitterPosition = CGPointMake(self.frame.size.width /2.0 - 10, self.frame.size.height / 2.0);
    emitter.emitterShape = kCAEmitterLayerCircle;
    emitter.emitterMode = kCAEmitterLayerOutline;
    [self.layer addSublayer:emitter];
    
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    [cell setName:@"zanShape"];    
    cell.contents = (__bridge id _Nullable)([self createImageWithColor:color].CGImage);
    cell.birthRate = 0;
    cell.lifetime = 0.4;
    cell.alphaSpeed = -2;
    cell.velocity = 20;
    cell.velocityRange = 20;
    emitter.emitterCells = @[cell];
    
    CABasicAnimation *effectLayerAnimation=[CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
    [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:1500]];
    [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
    [effectLayerAnimation setDuration:0.0f];
    [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [emitter addAnimation:effectLayerAnimation forKey:@"ZanCount"];
}

- (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect1 = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect1.size);
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context1, [color CGColor]);
    CGContextFillRect(context1, rect1);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(theImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(0, 0, theImage.size.width , theImage.size.height );
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [theImage drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

- (void)setClickableafter:(NSTimeInterval)second {
    self.userInteractionEnabled = NO;
    NSTimeInterval delayInSeconds = second;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        kDISPATCH_MAIN_THREAD(^{
            self.userInteractionEnabled = YES;
        });
    });
}

- (void)setButtonBorderWidth:(CGFloat)width cornerRadius:(CGFloat)radius borderColor:(UIColor *)color{
    [self.layer setMasksToBounds:true];
    [self.layer setCornerRadius:radius];
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:width];
}

@end
