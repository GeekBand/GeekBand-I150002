//
//  ViewController.h
//  EASY
//
//  Created by ZHY on 15/8/5.
//  Copyright (c) 2015年 ZHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAvatarBrowser.h"
@interface FXViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

@property (nonatomic , strong)UIImageView *imgText;
@property (nonatomic , strong)UIImage *img;
//@property (nonatomic , strong)UITextField *textFiled;
@property (nonatomic , strong)UITextView *textView;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)NSString     *location;
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
@end

