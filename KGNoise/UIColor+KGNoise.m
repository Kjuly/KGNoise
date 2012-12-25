//
//  UIColor+KGNoise.m
//  KGNoiseExample
//
//  Created by Cory Imdieke on 9/14/12.
//  Copyright (c) 2012 BitSuites, LLC. All rights reserved.
//

#import "UIColor+KGNoise.h"
#import "KGNoise.h"

@implementation UIColor(KGNoise)

- (UIColor *)colorWithNoiseOpacity:(CGFloat)opacity{
	return [self colorWithNoiseOpacity:opacity andBlendMode:kCGBlendModeScreen];
}

- (UIColor *)colorWithNoiseOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
	// Figure out our screen scale, if it's a retina display we'll make the noise at twice the resolution
	CGFloat screenScale = [[UIScreen mainScreen] scale];
	
	// Create a context to draw in
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
                                               256.0 * screenScale,
                                               256.0 * screenScale,
                                               8, /* bits per channel */
                                               (256.0 * screenScale * 4), /* 4 channels per pixel * numPixels/row */
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
	
	UIGraphicsPushContext(context);
	
	// Fill with the color
	CGContextSetFillColorWithColor(context, [self CGColor]);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 256.0 * screenScale, 256.0 * screenScale));
	
	// Noise on top
	[KGNoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
	
	// Create a CGImage from the context
  CGImageRef rawImage = CGBitmapContextCreateImage(context);
	UIGraphicsPopContext();
  CGContextRelease(context);
  
  // Create a UIImage from the CGImage
  UIImage * finishedImage = [UIImage imageWithCGImage:rawImage];
  CGImageRelease(rawImage);
	
	UIColor * patternColor = [UIColor colorWithPatternImage:finishedImage];
  
  return patternColor;
}

#pragma mark - Exquisite (Original Instance Method)

static NSUInteger const kImageSize = 128;

- (UIColor *)colorWithExquisiteNoiseOpacity:(CGFloat)opacity {
  return [self colorWithExquisiteNoiseOpacity:opacity
                                 andBlendMode:kCGBlendModeScreen];
}

- (UIColor *)colorWithExquisiteNoiseOpacity:(CGFloat)opacity
                               andBlendMode:(CGBlendMode)blendMode{
  CGRect rect = {CGPointZero, kImageSize, kImageSize};
  UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self setFill]; CGContextFillRect(context, rect);
  [KGNoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
  UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return [UIColor colorWithPatternImage:image];
}

@end
