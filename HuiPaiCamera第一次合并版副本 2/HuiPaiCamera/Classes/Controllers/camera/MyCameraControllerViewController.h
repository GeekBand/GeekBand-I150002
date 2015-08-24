//
//  MyCameraControllerViewController.h
//  NewCamera
//
//  Created by 陈铭嘉 on 15/8/18.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastFilter.h"
@interface MyCameraControllerViewController : UIViewController

@property(nonatomic,strong)UIImage *photo;
@property(nonatomic,strong)FastFilter *fastFilter;

@end
