//
//  ViewController.h
//  HuiPaiPS1
//
//  Created by huzhigang on 15/8/11.
//  Copyright © 2015年 huzhigang. All rights reserved.
//
#import "FastFilter.h"
#import <UIKit/UIKit.h>

@interface HPViewController : UIViewController <UITabBarDelegate>

@property(nonatomic, strong)UIImage *MyImage;
@property(nonatomic, assign)NSInteger tag;
@property(nonatomic, assign)double jiaodu;
@property(nonatomic, strong)FastFilter *fasterFilter;

@end

