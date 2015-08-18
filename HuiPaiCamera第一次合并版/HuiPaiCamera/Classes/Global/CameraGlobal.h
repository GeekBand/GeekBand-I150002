//
//  CameraGlobal.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/17.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#import "CameraStore.h"
#import <Foundation/Foundation.h>

@interface CameraGlobal : NSObject

@property(nonatomic,strong)CameraGlobal *camraType;

+(CameraGlobal*)shareGlobal;

@end
