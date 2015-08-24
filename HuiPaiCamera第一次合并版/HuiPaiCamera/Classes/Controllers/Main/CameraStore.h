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



@property (nonatomic , copy) NSString* ItemInformation1;//引导信息1
@property (nonatomic , copy) NSString* ItemInformation2;//引导信息2
@property (nonatomic , copy) NSString* ItemInformation3;//照片信息(如“镜头，镜头，我和~~”)
@property (nonatomic , copy) NSString* ItemMoreImage1;//引导照片1
@property (nonatomic , copy) NSString* ItemMoreImage2;//引导照片2
@property (nonatomic , copy) NSString* ItemMoreImage3;//引导照片3
@property (nonatomic , copy) NSString* ItemImageURL;  //照片
@property (nonatomic , copy) NSString* WangGeImageURL; //接口网格
@property (nonatomic , copy) NSString* WanZhengImageURL; //接口实际图片
@property (nonatomic , copy) FastFilter* fastFilter;


-(instancetype)initWithItemInformation1:(NSString *)itemInformation1
                       ItemInformation2:(NSString*)ItemInformation2
                       ItemInformation3:(NSString*)ItemInformation3
                         ItemMoreImage1:(NSString*)ItemMoreImage1
                         ItemMoreImage2:(NSString*)ItemMoreImage2
                         ItemMoreImage3:(NSString*)ItemMoreImage3
                           ItemImageURL:(NSString*)ItemImageURL
                            WangGeImage:(NSString*)WangGeImageURL
                         WangZhengImage:(NSString*)WanZhengImageURL
                             FastFilter:(FastFilter*)fasterFilter;




@end
