//
//  FastFilter.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/17.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "FastFilter.h"

@implementation FastFilter

-(instancetype)initWithshareE:(CGFloat)exposure C:(CGFloat)contrast S:(CGFloat)saturation B:(CGFloat)brightness G:(CGFloat)gama{
    self = [super init];
    if (self) {
        _exposure = exposure;
        _contrast = contrast;
        _brightness = brightness;
        _saturation = saturation;
        _gama = gama;
    }
    return self;
}

@end
