//
//  DetailViewController.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ViewController;
@interface DetailViewController : UIViewController



-(instancetype)initWithFrame:(CGRect)frame  title:(NSString*)title;

-(void)setParentView:(ViewController *)parentView;

@end
