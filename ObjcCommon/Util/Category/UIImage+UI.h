//
//  UIImage+UI.h
//  MpmMerchant
//
//  Created by Done.L on 2017/10/14.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/ALAsset.h>

@interface UIImage (UI)

/**
 将view转换为image
 
 @param view 视图
 @return UIImage对象
 */
+ (UIImage *)convertViewToImage:(UIView *)view;

/**
 *  通过色值创建图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 通过色值创建图片
 
 @param color 颜色
 @param size 尺寸
 @return 图片对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 生成带有边框的图片
 
 @param size 大小
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param dotLine 是否显示虚线
 @return 图片
 */
+ (UIImage *)imageWithSize:(CGSize)size
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
                 isDotLine:(BOOL)dotLine;

/**
 生成高斯模糊图片
 
 @param image 原始图片
 @return 高斯模糊图片
 */
+ (UIImage *)getGaussianBlurImageWithImage:(UIImage *)image;

/**
 调整图片大小
 
 @param image 需要调整的图片
 @param size 图片大小
 @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;

/**
 把图片压缩到800以内
 
 @param image 需要调整的图片
 @return 调整后的图片
 */
+ (UIImage *)resizeImage:(UIImage *)image;

/**
 image旋转到正常
 
 @param image 待旋转的图片
 @return 正常图片
 */
+ (UIImage *)imageFixOrientation:(UIImage *)image;

/**
 获取全分辨率图片（高清图）
 
 @param asset 相片对象
 @return 高清图
 */
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

/**
 *  压缩图片并限制最大分辨率
 *
 *  @param asset 图片对象
 *  @param size  最大分辨率
 */
+ (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;


/**
 图片转成NSData
 
 @param image 你需要转的图片
 @param maxLength   图片的最大边长
 @return NSData数据
 */
+ (NSData *)getImageDataForSendToFriend:(UIImage *)image withMaxLength:(float)maxLength;

/**
 图片转成NSData（默认最大边长800）
 
 @param image 你需要转的图片
 @return NSData数据
 */
+ (NSData *)getImageDataForSendToFriend:(UIImage *)image;

/**
 ALAsset转成NSData
 
 @param asset
 @return data
 */
+ (NSData *)getImageDataWithAsset:(ALAsset *)asset;

/**
 *  压图片质量
 *
 *  @param originImage image
 *
 *  @return data
 */
+ (NSData *)compressImageQualityWithImage:(UIImage *)originImage toByte:(NSInteger)maxBytes;

/**
 *  压图片大小
 *
 *  @param image image
 *  @param newWidth newWidth
 *
 *  @return image
 */
+ (UIImage *)compressImageSizeWithImage:(UIImage *)originImage maxLength:(CGFloat)maxLength;

/**
 *  压图片大小和质量
 *
 *  @param originImage 图片源
 *  @param maxLength 最大宽高限制
 *  @param maxBytes 最大质量限制
 *
 *  @return data
 */
+ (NSData *)compressImageSizeAndQualityWithImage:(UIImage *)originImage maxLength:(NSInteger)maxLength maxBytes:(NSInteger)maxBytes;

/**
 *  图片数组转换成Gif
 *
 *  @param images 合成gif的图片数组
 *  @param delays 每一帧的延时（float类型）
 *  @param loopCount 循环次数 (0 表示无线循环)
 *  @param savePath gif生成的地址
 *
 *  @return BOOL gif声称是否成功
 */
+ (BOOL)convertImagesToGifWithImages:(NSArray *)images delays:(NSArray *)delays loopCount:(NSUInteger)loopCount savePath:(NSString *)savePath;

/**
 根据URL获取首帧图

 @param videoURL 视频地址
 @param time 时间戳
 @return 图片
 */
+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 获取启动图图片
 
 @return 图片
 */
+ (instancetype) getLaunchImage;

@end
