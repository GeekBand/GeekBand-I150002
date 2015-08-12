//
//  UIButton1.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CameraStore.h"
@interface UIButton1 : UIButton

@property (nonatomic,strong)CameraStore* Store;
@property (nonatomic, strong)ALAsset *Asset;
@property (nonatomic,strong)NSString *Information;

@end
