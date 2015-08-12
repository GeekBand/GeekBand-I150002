//
//  ViewController.m
//  EASY
//
//  Created by ZHY on 15/8/5.
//  Copyright (c) 2015年 ZHY. All rights reserved.
//

#import "FXViewController.h"
#import "ShareSDK/ShareSDK.h"
#import "WXApi.h"
@interface FXViewController ()

@end

@implementation FXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"分享";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    图片
    CGRect rectImg=CGRectMake(60, 140, 100, 100);
//    self.img=[UIImage imageNamed:@"test.png"];
    self.imgText=[[UIImageView alloc]initWithImage:self.img];
    self.imgText.frame=rectImg;
    [ self.imgText setUserInteractionEnabled:YES];
    [self.view addSubview: self.imgText];
    
    UITapGestureRecognizer *imgTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgExtend)];
    [ self.imgText addGestureRecognizer:imgTap];
    
    //    文本框
    CGRect rectText=CGRectMake(60, 300, 240, 30);
    self.textFiled=[[UITextField alloc]initWithFrame:rectText] ;
    [self.textFiled setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFiled.placeholder=@"写点什么吧~";
    self.textFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textFiled.autocorrectionType=UITextAutocorrectionTypeNo;
    self.textFiled.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.textFiled.returnKeyType=UIReturnKeyDone;
    self.textFiled.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.textFiled.delegate=self;
    self.textFiled.contentVerticalAlignment=UIViewContentModeCenter;
    [self.view addSubview:self.textFiled];
    
    
    //   微博分享按钮
    CGRect rectWeiboShare=CGRectMake(60, 400, 54, 54);
    UIButton *btWeiboShare=[[UIButton alloc]initWithFrame:rectWeiboShare];
    UIImage *imgWeiboShare=[UIImage imageNamed:@"weibo.png"];
    [btWeiboShare setImage:imgWeiboShare forState:UIControlStateNormal];
    [btWeiboShare addTarget:self action:@selector(WeiboShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btWeiboShare];
    //   微信分享按钮
    CGRect rectWeChatShare=CGRectMake(144, 400, 54, 54);
    UIButton *btWeChatShare=[[UIButton alloc]initWithFrame:rectWeChatShare];
    UIImage *imgWeChatShare=[UIImage imageNamed:@"wechat.png"];
    [btWeChatShare setImage:imgWeChatShare forState:UIControlStateNormal];
    [btWeChatShare addTarget:self action:@selector(WeChatShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btWeChatShare];
    //   QQ分享按钮
    CGRect rectQQShare=CGRectMake(228, 395, 54, 60);
    UIButton *btQQShare=[[UIButton alloc]initWithFrame:rectQQShare];
    UIImage *imgQQShare=[UIImage imageNamed:@"QQ.jpg"];
    [btQQShare setImage:imgQQShare forState:UIControlStateNormal];
    [btQQShare addTarget:self action:@selector(QQShareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btQQShare];
    //  相机
    CGRect rectCamera=CGRectMake(self.view.bounds.size.width/2-58,self.view.bounds.size.height-58, 114, 58);
    UIButton *btCamera=[[UIButton alloc]initWithFrame:rectCamera];
    UIImage *imgCamera=[UIImage imageNamed:@"camera.png"];
    [btCamera setImage:imgCamera forState:UIControlStateNormal];
    [btCamera addTarget:self
                 action:@selector(CameraClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btCamera];
    
    //  BarButtom
    UIBarButtonItem *CancelBarButtom
    =[[UIBarButtonItem alloc] initWithTitle:@"取消"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(CancelClick:)];
    self.navigationItem.leftBarButtonItem=CancelBarButtom;
    
}
-(void)imgExtend{
    [SJAvatarBrowser showImage: self.imgText];
}
-(void)CameraClick:(id)buttom{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"相机" message:@"这是一个相机~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]    ;
    [alertview show];
}
-(void)CancelClick:(id)buttom{
    self.textFiled.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)WeiboShareClick:(id)button
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *text=_textFiled.text;
    if ([_textFiled.text isEqual:@""]) {
        text= @"分享";
    }
    
    [shareParams SSDKSetupShareParamsByText:text
                                     images:@[_img]
                                        url:nil
                                      title:@""
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}
-(void)WeChatShareClick:(id)button
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.textFiled.text
                                     images:@[self.img]
                                        url:nil
                                      title:@""
                                       type:SSDKContentTypeAuto];
    
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}
-(void)QQShareClick:(id)button
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.textFiled.text
                                     images:@[self.img]
                                        url:nil
                                      title:@""
                                       type:SSDKContentTypeAuto];
    
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeQQ
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
