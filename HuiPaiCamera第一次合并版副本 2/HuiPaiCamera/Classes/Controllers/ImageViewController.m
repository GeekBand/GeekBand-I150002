//
//  ImageViewController.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/6.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import "ImageViewController.h"


@interface ImageViewController()

{
    ALAsset * MyAsset;
}

@end


@implementation ImageViewController


-(void)viewDidLoad{

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,60,self.view.frame.size.width, self.view.frame.size.width)];
    imageView.image = [UIImage imageWithCGImage: MyAsset.defaultRepresentation.fullScreenImage];
    [self.view addSubview:imageView];
}

-(instancetype)initWithALAsset:(ALAsset *)ImageAsset
{
    self = [self init];
    if (self) {
        MyAsset = ImageAsset;
    }
    return self;
}


@end
