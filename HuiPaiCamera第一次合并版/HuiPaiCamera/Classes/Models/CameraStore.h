//
//  CameraStore.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastFilter.h"

@interface CameraStore : NSObject


@property (nonatomic , copy) NSString* ItemName;    //照片名字(如“嘻嘻”)
@property (nonatomic , copy) NSString* ItemInformation; //照片信息(如“镜头，镜头，我和~~”)
@property (nonatomic , copy) NSString* ItemTitle;    //所属主题(如“自拍系列”)
@property (nonatomic , copy) NSString* ItemImageURL;  //照片
@property (nonatomic , copy) NSString* WangGeImageURL; //接口网格
@property (nonatomic , copy) NSString* WanZhengImageURL; //接口实际图片
@property (nonatomic , copy) FastFilter* fastFilter;


-(instancetype)initWithItemName:(NSString *)itemName ItemInformation:(NSString*)ItemInformation ItemTitle:(NSString*)ItemTitle ItemImage:(NSString*)ItemImageURL WangGeImage:(NSString*)WangGeImageURL WangZhengImage:(NSString*)WanZhengImageURL FastFilter:(FastFilter*)fasterFilter;

-(instancetype)initWithItemName:(NSString *)itemName ItemInformation:(NSString*)ItemInformation ItemTitle:(NSString*)ItemTitle ItemImage:(NSString*)ItemImageURL;


@end
