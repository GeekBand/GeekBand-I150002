//
//  FastFilter.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/17.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FastFilter : NSObject

@property(nonatomic,assign)CGFloat exposure;          //曝光度，正常值为
@property(nonatomic,assign)CGFloat contrast;          //对比度 ，正常值为1 范围0~4
@property(nonatomic,assign)CGFloat saturation;        //饱和度 ，正常值为1 ，范围0~2;
@property(nonatomic,assign)CGFloat brightness;        //亮度 ，正常值为0 ，范围-1~1;
@property(nonatomic,assign)CGFloat gama;              //伽马 ，正常值为1.0  范围0~3

-(instancetype)initWithshareE:(CGFloat)exposure C:(CGFloat)contrast S:(CGFloat)saturation B:(CGFloat)brightness G:(CGFloat)gama;

@end
