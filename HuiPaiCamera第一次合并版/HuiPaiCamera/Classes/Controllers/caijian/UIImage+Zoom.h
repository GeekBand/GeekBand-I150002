//
//  UIImage+Zoom.h
//  GeeKBand Test
//
//  Created by 陈铭嘉 on 15/8/11.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    enSvResizeScale,            // image scaled to fill
    enSvResizeAspectFit,        // image scaled to fit with fixed aspect. remainder is transparent
    enSvResizeAspectFill,       // image scaled to fill with fixed aspect. some portion of content may be cliped
};
typedef NSInteger SvResizeMode;

@interface UIImage (Zoom)


- (UIImage*)resizeImageToSize:(CGSize)newSize resizeMode:(SvResizeMode)resizeMode;

@end
