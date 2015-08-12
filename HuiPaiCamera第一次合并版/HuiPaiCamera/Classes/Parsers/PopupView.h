//
//  PopupView.h
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraStore.h"
@interface PopupView : UIView
@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak)UIViewController *parentVC;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (nonatomic,strong)UIViewController *Controller;
@property (weak, nonatomic) IBOutlet UILabel *label2;

+ (instancetype)defaultPopupViewWith:(CameraStore *)cameraStore Index:(NSInteger)index WithController:(UIViewController*)controller;
@end
