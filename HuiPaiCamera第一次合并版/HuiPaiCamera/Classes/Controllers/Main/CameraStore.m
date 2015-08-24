
//
//  CameraStore.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "CameraStore.h"

@implementation CameraStore


-(instancetype)initWithItemInformation1:(NSString *)itemInformation1
                       ItemInformation2:(NSString *)ItemInformation2
                       ItemInformation3:(NSString *)ItemInformation3
                         ItemMoreImage1:(NSString *)ItemMoreImage1
                         ItemMoreImage2:(NSString *)ItemMoreImage2
                         ItemMoreImage3:(NSString *)ItemMoreImage3
                           ItemImageURL:(NSString *)ItemImageURL
                            WangGeImage:(NSString *)WangGeImageURL
                         WangZhengImage:(NSString *)WanZhengImageURL
                             FastFilter:(FastFilter *)fasterFilter{

    self = [super init];
    if (self) {
        _ItemInformation1 = itemInformation1;
        _ItemInformation2 = ItemInformation2;
        _ItemInformation3 = ItemInformation3;
        _ItemMoreImage1 = ItemMoreImage1;
        _ItemMoreImage2 = ItemMoreImage2;
        _ItemMoreImage3 = ItemMoreImage3;
        _ItemImageURL = ItemImageURL;
        _WangGeImageURL = WangGeImageURL;
        _WanZhengImageURL = WanZhengImageURL;
        _fastFilter = fasterFilter;
    }

    return self;
}

-(instancetype)init{
    self = [self initWithItemInformation1:nil
                         ItemInformation2:nil
                         ItemInformation3:nil
                           ItemMoreImage1:nil
                           ItemMoreImage2:nil
                           ItemMoreImage3:nil
                             ItemImageURL:nil
                              WangGeImage:nil
                           WangZhengImage:nil
                               FastFilter:nil];
    return self;
}






@end
