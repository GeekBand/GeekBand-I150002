//
//  ViewController.h
//  EASY
//
//  Created by ZHY on 15/8/5.
//  Copyright (c) 2015年 ZHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAvatarBrowser.h"
@interface FXViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic , strong)UIImageView *imgText;
@property (nonatomic , strong)UIImage *img;
@property (nonatomic , strong)UITextField *textFiled;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)NSString     *location;
@end

