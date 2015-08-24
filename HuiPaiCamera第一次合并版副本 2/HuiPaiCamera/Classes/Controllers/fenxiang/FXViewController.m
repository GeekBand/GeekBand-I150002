//
//  ViewController.m
//  EASY
//
//  Created by ZHY on 15/8/5.
//  Copyright (c) 2015年 ZHY. All rights reserved.
//
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#import "FXViewController.h"
#import "CCLocationManager.h"
#import "ShareSDK/ShareSDK.h"
#import "ViewController.h"
#import "WXApi.h"
@interface FXViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationmanager;
}
@end

@implementation FXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    
    self.title=@"分享";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    图片
    CGRect rectImg=CGRectMake(90, 100, 180, 150);
    self.imgText=[[UIImageView alloc]initWithImage:self.img];
    self.imgText.frame=rectImg;
    self.imgText.clipsToBounds = YES;
    self.imgText.contentMode = UIViewContentModeScaleAspectFill;
    [ self.imgText setUserInteractionEnabled:YES];
    [self.view addSubview: self.imgText];
    
    UITapGestureRecognizer *imgTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgExtend)];
    [ self.imgText addGestureRecognizer:imgTap];
    
    //    文本框
    CGRect rectText=CGRectMake(60, 260, 240, 90);
    _textView=[[UITextView alloc]initWithFrame:rectText];
    _textView.delegate=self;
    _textView.font = [UIFont systemFontOfSize:16];
    //_textView.contentInset = UIEdgeInsetsMake(-11, -6, 0, 0);
    _textView.scrollEnabled = NO;
    _textView.textColor=[UIColor whiteColor ];
    UIColor *setColor=[[UIColor alloc]initWithRed:185.0f/255.0f green:232.0f/255.0f blue:139.0f/255.0f alpha:1];
    _textView.backgroundColor=setColor;
    //获得焦点
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    //定位
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 360, 280, 30)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor redColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"定位";
    _textLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getAllInfo)];
    
    [_textLabel addGestureRecognizer:labelTapGestureRecognizer];
    [self.view addSubview:_textLabel];
    
    CGRect rectDW= CGRectMake(60,360, 30, 30);
    UIButton *allBtn = [[UIButton alloc]initWithFrame:rectDW];
    UIImage *imgDW=[UIImage imageNamed:@"oval.png"];
    [allBtn setImage:imgDW forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    
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
    
    //  取消
    UIBarButtonItem *CancelBarButtom
    =[[UIBarButtonItem alloc] initWithTitle:@"取消"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(CancelClick:)];
    self.navigationItem.leftBarButtonItem=CancelBarButtom;
    
    //保存
    UIBarButtonItem *SaveBarButtom
    =[[UIBarButtonItem alloc] initWithTitle:@"保存"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(ReturnClick:)];
    
    self.navigationItem.rightBarButtonItem=SaveBarButtom;
}
-(void)imgExtend{
    [SJAvatarBrowser showImage: self.imgText];
}

-(void)ReturnClick:(id)buttom{
//    [self dismissViewControllerAnimated:YES completion:nil];
    ViewController *view = [[ViewController alloc]init];
    [self presentViewController:view animated:view completion:nil];

}


-(void)CancelClick:(id)buttom{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)WeiboShareClick:(id)button
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *content;
    if ([_textView.text isEqual:@""]) {
        content= [[NSMutableString alloc] initWithString:@"分享"];
    }
    content =_textView.text;
    
    
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:content
                                               title:@"分享"
                                               image:_img
                                                 url:nil
                                            latitude:_latitude
                                           longitude:_longitude
                                            objectID:nil
                                                type:SSDKContentTypeImage];
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
    NSString *content;
    if ([_textView.text isEqual:@""]) {
        content= [[NSMutableString alloc] initWithString:@"分享"];
    }
    content =_textView.text;
    CGSize size = CGSizeMake(100.0f, 100.0f);
    UIImage *WeChatthumbImage=[FXViewController thumbnailWithImageWithoutScale:_img size:size];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupWeChatParamsByText:content
                                       title:@"分享"
                                         url:nil
                                  thumbImage:WeChatthumbImage
                                       image:_img
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
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
    NSString *content;
    content =_textView.text;
    if ([_textView.text isEqual:@""]) {
        content= [[NSMutableString alloc] initWithString:@"分享"];
    }
    
    CGSize size = CGSizeMake(100.0f, 100.0f);
    UIImage *QQthumbImage=[FXViewController thumbnailWithImageWithoutScale:_img size:size];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:content
                                   title:@"分享"
                                     url:nil
                              thumbImage:QQthumbImage
                                   image:_img
                                    type:SSDKContentTypeImage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    
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

-(void)getAllInfo
{
    __block NSString *string;
    __block __weak FXViewController *wself = self;
    if([_textLabel.text isEqual:@"定位"])
    {
        if (IS_IOS8) {
            
            [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
                
                _latitude=locationCorrrdinate.latitude;
                _longitude=locationCorrrdinate.longitude;
                ;
            } withAddress:^(NSString *addressString) {
                NSLog(@"%@",addressString);
                string = [NSString stringWithFormat:@"%@",addressString];
                [wself setLabelText:string];
                
            }];
        }
    }
    else _textLabel.text =@"定位";
    
    
}

-(void)setLabelText:(NSString *)text
{
    
    _textLabel.text = text;
}


//缩略图生成
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
