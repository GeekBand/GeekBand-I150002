//
//  UIImage+SvImageEdit.m
//  GeeKBand Test
//
//  Created by 陈铭嘉 on 15/8/11.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "UIImage+SvImageEdit.h"

@implementation UIImage (SvImageEdit)

- (UIImage*)cropImageWithRect:(CGRect)cropRect
{
    CGRect drawRect = CGRectMake(-cropRect.origin.x , -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    
    [self drawInRect:drawRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
