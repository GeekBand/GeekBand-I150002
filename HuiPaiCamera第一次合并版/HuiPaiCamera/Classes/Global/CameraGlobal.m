//
//  CameraGlobal.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/17.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "CameraGlobal.h"

static CameraGlobal* global = nil;

@implementation CameraGlobal

+(CameraGlobal*)shareGlobal
{
    if (global == nil) {
        global = [[CameraGlobal alloc]init];
    }
    return global;
}

@end
