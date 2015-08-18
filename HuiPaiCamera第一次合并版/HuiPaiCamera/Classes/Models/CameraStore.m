
//
//  CameraStore.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "CameraStore.h"

@implementation CameraStore


-(instancetype)initWithItemName:(NSString *)itemName ItemInformation:(NSString*)ItemInformation ItemTitle:(NSString*)ItemTitle ItemImage:(NSString*)ItemImageURL WangGeImage:(NSString*)WangGeImageURL WangZhengImage:(NSString*)WanZhengImageURL FastFilter:(FastFilter *)fasterFilter;
{
    self = [super init];
    if (self) {
        _ItemName = itemName;
        _ItemInformation = ItemInformation;
        _ItemTitle = ItemTitle;
        _ItemImageURL = ItemImageURL;
        _WangGeImageURL = WangGeImageURL;
        _WanZhengImageURL = WanZhengImageURL;
        _fastFilter = fasterFilter;
    }
    return self;
}

-(instancetype)init{
    self = [self initWithItemName:@"无" ItemInformation:@"无" ItemTitle:@"无" ItemImage:@"无" WangGeImage:@"无" WangZhengImage:@"无"FastFilter:nil];
    return self;
}



-(instancetype)initWithItemName:(NSString *)itemName ItemInformation:(NSString*)ItemInformation ItemTitle:(NSString*)ItemTitle ItemImage:(NSString*)ItemImageURL
{
    self = [super init];
    if (self) {
        _ItemName = itemName;
        _ItemInformation = ItemInformation;
        _ItemTitle = ItemTitle;
        _ItemImageURL = ItemImageURL;
    }
    return self;
}



@end
