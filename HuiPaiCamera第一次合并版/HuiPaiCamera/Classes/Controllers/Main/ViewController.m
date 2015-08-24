//
//  ViewController.m
//  新主页
//
//  Created by 陈铭嘉 on 15/8/20.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#define Mywidth self.view.frame.size.width
#define Myheight self.view.frame.size.height
#define MEISHI_TAG 2
#define MAINSCROLL_TAG 1
#define FENGJ_TAG 3
#define WEIJ_TAG 4
#define JIANZHU_TAG 5
#define OTHERMAINSCROLL_TAG 6
#define BACKSCROLL_TAG 7
#define PHONEBUTTON_TAG 8
#define MODAL_TAG 9
#define MODAL_TAG2 10
#import "ViewController.h"
#import "FastFilter.h"
#import "CameraStore.h"
#import "CameraFactory.h"
#import "UIButton1.h"
#import "KYAnimatedPageControl.h"
#import "FZPickerController.h"



@interface ViewController ()
{
    UIScrollView *downScroll;
    UIScrollView *mainScroll;
    UIView *yellowXian;
    NSArray *cameraArray;
    UIButton *photoButton;
    NSInteger currentTag;
    UIViewController *BlurView;
    UIScrollView *scrollModalView;
    UIScrollView *wordScroll;
    UIImageView *potView;
}
@property (nonatomic,strong)UIView *DetailView;
@property (nonatomic,strong)UIButton *starButton;
@property(nonatomic,strong)KYAnimatedPageControl *pageControl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CombView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.DetailView = [[UIView alloc]initWithFrame:CGRectMake(0,135,Mywidth,Myheight-135)];
    [self.view addSubview:self.DetailView];
    [self CombMainView];
    
    yellowXian = [[UIView alloc]initWithFrame:CGRectMake(17,133, 50, 4)];
    [yellowXian setBackgroundColor:[[UIColor alloc] initWithRed:254.0/255.0 green:236.0/255.0 blue:48.0/255.0 alpha:1]];
    [self.view addSubview:yellowXian];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma maek -- 组装引导界面
-(void)CombMainView{


    currentTag = MAINSCROLL_TAG;
    [UIView animateWithDuration:0.5 animations:^{
        [yellowXian setFrame:CGRectMake(17, 133, 50, 4)];
    } completion:nil];
    
    for (UIView *view in downScroll.subviews) {
        [view removeFromSuperview];
        ;
    }
    for (UIView *view in mainScroll.subviews) {
        [view removeFromSuperview];
        ;
    }
    [downScroll removeFromSuperview];
    [mainScroll removeFromSuperview];
    downScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,Myheight-135,Mywidth, 135)];
    downScroll.contentSize = CGSizeMake(Mywidth*3, 135);
    downScroll.tag = BACKSCROLL_TAG;
    downScroll.delegate = self;
    downScroll.pagingEnabled = YES;
    [downScroll setShowsHorizontalScrollIndicator:NO];
    [self.DetailView addSubview:downScroll];
    
  
    
    UIView* backview1 = [[UIView alloc]initWithFrame:CGRectMake(-200,0,Mywidth+200, 135)];
    backview1.backgroundColor =[[UIColor alloc]initWithRed:170.0/255.0 green:231.0/255.0 blue:117.0/255.0 alpha:1];
    UIImageView *wordView1 = [[UIImageView alloc]initWithFrame:CGRectMake(240, 30, Mywidth-80-60, 70)];
    wordView1.image = [UIImage imageNamed:@"word1.png"];
    [backview1 addSubview:wordView1];
    [downScroll addSubview:backview1];
   
   
    
    UIView* backview2 = [[UIView alloc]initWithFrame:CGRectMake(Mywidth,0,Mywidth, 135)];
    backview2.backgroundColor =[[UIColor alloc]initWithRed:68.0/255.0 green:224.0/255.0 blue:181.0/255.0 alpha:1];
    UIImageView *wordView3 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 30, Mywidth-80-60, 70)];
    wordView3.image = [UIImage imageNamed:@"word2.png"];
    [backview2 addSubview:wordView3];
    [downScroll addSubview:backview2];
    
    
    UIView* backview3 = [[UIView alloc]initWithFrame:CGRectMake(Mywidth*2,0,Mywidth+200, 135)];
    backview3.backgroundColor =[[UIColor alloc]initWithRed:64.0/255.0 green:140.0/255.0 blue:254.0/255.0 alpha:1];
    UIImageView *wordView5 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 30, Mywidth-80-60, 70)];
    wordView5.image = [UIImage imageNamed:@"word3.png"];
    [backview3 addSubview:wordView5];
    [downScroll addSubview:backview3];
    
    
    photoButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth-30, Myheight, 80, 80)];
    photoButton.tag = PHONEBUTTON_TAG;
    [photoButton setImage:[UIImage imageNamed:@"相机.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [downScroll setFrame:CGRectMake(0,Myheight-135-135,Mywidth, 135)];
//    } completion:nil];
    
 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
     [downScroll setFrame:CGRectMake(0,Myheight-135-135,Mywidth, 135)];
 } completion:^(BOOL finished) {
     [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
         [photoButton setFrame:CGRectMake(Mywidth-30, Myheight-110, 80, 80)];
     } completion:nil];
 }];
    
    
   
    
    
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(-Mywidth,0,Mywidth, Myheight-135-135)];
    mainScroll.tag = MAINSCROLL_TAG;
    mainScroll.delegate = self;
    mainScroll.contentSize = CGSizeMake(Mywidth, (Myheight-135-135)*3);
    mainScroll.pagingEnabled = YES;
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [self.DetailView addSubview:mainScroll];
    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5,7, Mywidth-10,Myheight-135-135-10)];
    imageView1.image = [UIImage imageNamed:@"主页1.png"];
    [mainScroll addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(5,7+(5+Myheight-135-135), Mywidth-10,Myheight-135-135-10)];
    imageView2.image = [UIImage imageNamed:@"主页2.png"];
    [mainScroll addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(5,7+(5+Myheight-135-135)*2, Mywidth-10,Myheight-135-135-10)];
    imageView3.image = [UIImage imageNamed:@"主页3.png"];
    [mainScroll addSubview:imageView3];
    
     [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
         [mainScroll setFrame:CGRectMake(0,0,Mywidth, Myheight-135-135)];
     } completion:nil];

}


-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    if (scrollView.tag == MAINSCROLL_TAG) {
        CGFloat x = (scrollView.contentOffset.y)*Mywidth/(Myheight-135-135);
        downScroll.contentOffset = CGPointMake(x, 0);
        [UIView animateWithDuration:0.1 animations:^{
            [photoButton setFrame:CGRectMake(Mywidth-30-(x*25/Mywidth), Myheight-110, 80, 80)];
        }];
    }else if(scrollView.tag == BACKSCROLL_TAG){
        CGFloat x = (downScroll.contentOffset.x)*(Myheight-135-135)/Mywidth;
        mainScroll.contentOffset = CGPointMake(0, x);
    
    }else if(scrollView.tag == MODAL_TAG){
    
        [self.pageControl.indicator animateIndicatorWithScrollView:scrollView andIndicator:self.pageControl];
        
        if (scrollView.dragging || scrollView.isDecelerating || scrollView.tracking) {
            //背景线条动画
            [self.pageControl.pageControlLine animateSelectedLineWithScrollView:scrollView];
        }

        
        if (scrollView.contentOffset.x>-100&scrollView.contentOffset.x<80) {
            scrollView.contentOffset = CGPointMake(80, 0);
//            wordScroll.contentOffset = CGPointMake(0, 0) ;
        }else if(scrollView.contentOffset.x>(2*Mywidth-80)){
            scrollView.contentOffset = CGPointMake(2*Mywidth-80, 0) ;
//            wordScroll.contentOffset = CGPointMake(3*Mywidth, 0);
        }else if(scrollView.contentOffset.x == Mywidth){
            [UIView animateWithDuration:0.3 animations:^{
                   wordScroll.contentOffset = CGPointMake(Mywidth, 0) ;
            }];
//            [UIView animateWithDuration:1 animations:^{
//                [potView setFrame:CGRectMake(77, 7.8, 5, 5)];
//                
//            } completion:^(BOOL finished) {
//                [potView setFrame:CGRectMake(77, 7, 14, 14)];
//            }];
         
        }else if(scrollView.contentOffset.x == 80){
            [UIView animateWithDuration:0.3 animations:^{
                 wordScroll.contentOffset = CGPointMake(0, 0) ;
            }];
//            [UIView animateWithDuration:1  animations:^{
//                [potView setFrame:CGRectMake(5, 7.8, 5, 5)];
//                
//            } completion:^(BOOL finished) {
//                [potView setFrame:CGRectMake(5, 6.5, 14, 14)];
//            }];
          
            
           
        }else if(scrollView.contentOffset.x == 2*Mywidth-80){
            [UIView animateWithDuration:0.3 animations:^{
               wordScroll.contentOffset = CGPointMake(2*Mywidth, 0) ;
            }];
//            [UIView animateWithDuration:1 animations:^{
//                [potView setFrame:CGRectMake(153, 7.8, 5,5)];
//                
//            } completion:^(BOOL finished) {
//                [potView setFrame:CGRectMake(153, 6.5, 14,14)];
//            }];
//           
        }

     
    }else if(scrollView.tag == MODAL_TAG2){
  
        
        CGFloat x = (scrollView.contentOffset.x)*(Mywidth)/Mywidth;
        scrollModalView.contentOffset = CGPointMake(x, 0);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.tag == MODAL_TAG){
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.tag == MODAL_TAG){
    [self.pageControl.indicator restoreAnimation:@(1.0/self.pageControl.pageCount)];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView.tag == MODAL_TAG){
    self.pageControl.indicator.lastContentOffset = scrollView.contentOffset.x;
    }
}


#pragma mark ---组装控件和视图
-(void)CombView{
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,Mywidth, 135)];
    upView.backgroundColor = [[UIColor alloc]initWithRed:65.0/255.0 green:140.0/255.0 blue:255.0/255.0 alpha:1];
    [self.view addSubview:upView];
    
    UIButton *Mainbutton = [[UIButton alloc]initWithFrame:CGRectMake(20,76,35,45)];
    [Mainbutton setImage:[UIImage imageNamed:@"logo copy.png"] forState:UIControlStateNormal];
    [Mainbutton setImage:[UIImage imageNamed:@"logo copy 2.png"] forState:UIControlStateSelected];
    [Mainbutton addTarget:self action:@selector(CombMainView) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:Mainbutton];
    
    UIButton *Meishibutton = [[UIButton alloc]initWithFrame:CGRectMake(90,80,56,57)];
    [Meishibutton setImage:[UIImage imageNamed:@"美食 logo copy.png"] forState:UIControlStateNormal];
    [Meishibutton setImage:[UIImage imageNamed:@"美食 logo.png"] forState:UIControlStateSelected];
    [Meishibutton setTag:MEISHI_TAG];
    [Meishibutton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:Meishibutton];
    
    UIButton *FengJbutton = [[UIButton alloc]initWithFrame:CGRectMake(160,80,56,57)];
    [FengJbutton setImage:[UIImage imageNamed:@"风景 logo copy.png"] forState:UIControlStateNormal];
    [FengJbutton setImage:[UIImage imageNamed:@"风景 logo.png"] forState:UIControlStateSelected];
    [FengJbutton setTag:FENGJ_TAG];
        [FengJbutton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:FengJbutton];
    
    UIButton *WeiJbutton = [[UIButton alloc]initWithFrame:CGRectMake(230,80,56,57)];
    [WeiJbutton setImage:[UIImage imageNamed:@"微距 logo copy.png"] forState:UIControlStateNormal];
    [WeiJbutton setImage:[UIImage imageNamed:@"微距 logo.png"] forState:UIControlStateSelected];
    [WeiJbutton setTag:WEIJ_TAG];
        [WeiJbutton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:WeiJbutton];
    
    UIButton *JianZbutton = [[UIButton alloc]initWithFrame:CGRectMake(300,80,56,57)];
    [JianZbutton setImage:[UIImage imageNamed:@"建筑 logo copy.png"] forState:UIControlStateNormal];
    [JianZbutton setImage:[UIImage imageNamed:@"建筑 logo.png"] forState:UIControlStateSelected];
    [JianZbutton setTag:JIANZHU_TAG];
        [JianZbutton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:JianZbutton];

}


#pragma mark ---按钮反应
-(void)ButtonClick:(UIButton*)sender{
    if(sender!=self.starButton){
        self.starButton.selected=NO;
        self.starButton=sender;
    }
    for (UIView *view in downScroll.subviews) {
        [view removeFromSuperview];
        ;
    }
    for (UIView *view in mainScroll.subviews) {
        [view removeFromSuperview];
        ;
    }
    self.starButton.selected=YES;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         [yellowXian setFrame:CGRectMake(sender.frame.origin.x+5, 133, 50, 4)];
    } completion:nil];
    [mainScroll removeFromSuperview];
    [self CombDownScrollView];
    [self CombMainScrollView:sender.tag];
    currentTag = sender.tag;
    



}

#pragma mark ----统一中间视图
-(void)CombMainScrollView:(NSInteger)senderTag{
    if (senderTag > currentTag) {
         mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(Mywidth,0,Mywidth, Myheight-135-135)];
    }else
    {   mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(-Mywidth,0,Mywidth, Myheight-135-135)]; }
    
   
    mainScroll.tag = OTHERMAINSCROLL_TAG;
    mainScroll.delegate = self;
    mainScroll.contentSize = CGSizeMake(Mywidth,Myheight-135-135+50);
    mainScroll.pagingEnabled = YES;
    [mainScroll setShowsHorizontalScrollIndicator:NO];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [self.DetailView addSubview:mainScroll];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [mainScroll setFrame:CGRectMake(0,0,Mywidth, Myheight-135-135)];
    } completion:nil];

    
    
    if (senderTag == MEISHI_TAG ) {
        CameraFactory *cameraFactory = [[CameraFactory alloc]init];
        cameraArray = [cameraFactory MakeCameraFactory:MEISHI_TAG];
        NSInteger CountIndex = 0;
        NSInteger NumberIndex = 0;
        for (CameraStore *cameraStore in cameraArray) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+CountIndex*(Mywidth/2-10),10+NumberIndex*(120+10), (Mywidth-30)/2, 120)];
            
            UIButton1 *button = [[UIButton1 alloc]initWithFrame:CGRectMake(10+CountIndex*(Mywidth/2-10),10+NumberIndex*(120+10), (Mywidth-30)/2, 120)];
            button.Store = cameraStore;
            [button addTarget:self action:@selector(SelectImage:) forControlEvents:UIControlEventTouchUpInside];
            [mainScroll addSubview:button];

            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cameraStore.ItemImageURL]];
            NSLog(@"%@.png",cameraStore.ItemImageURL);
            [mainScroll addSubview:imageView];
            
            CountIndex++;
            
            if (CountIndex == 2) {
                CountIndex = 0 ;
                NumberIndex++;
            }
        }
    }else {
        CameraFactory *cameraFactory = [[CameraFactory alloc]init];
        cameraArray = [cameraFactory MakeCameraFactory:senderTag];
        NSInteger CountIndex = 0;
        NSInteger NumberIndex = 0;
        for (CameraStore *cameraStore in cameraArray) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+CountIndex*(Mywidth/2-10),10+NumberIndex*(120+10), (Mywidth-30)/2, 120)];
            
            UIButton1 *button = [[UIButton1 alloc]initWithFrame:CGRectMake(10+CountIndex*(Mywidth/2-10),10+NumberIndex*(120+10), (Mywidth-30)/2, 120)];
            button.Store = cameraStore;
            [button addTarget:self action:@selector(SelectImage:) forControlEvents:UIControlEventTouchUpInside];
            [mainScroll addSubview:button];

                              
            NSString *path = [[NSBundle mainBundle]pathForResource:cameraStore.ItemImageURL ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            NSLog(@"%@.jpg",cameraStore.ItemImageURL);
            [mainScroll addSubview:imageView];
            
            CountIndex++;
            
            if (CountIndex == 2) {
                CountIndex = 0 ;
                NumberIndex++;
            }
        }
    }
 
}


#pragma mark ----点击图片事件
-(void)SelectImage:(UIButton1*)sender{

    BlurView = [[UIViewController alloc]init];
    BlurView.view.alpha = 0.5;
    [self presentViewController:BlurView animated:NO completion:^{
        [UIView animateWithDuration:0.3 animations:^{
             BlurView.view.alpha = 1;
        }];
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"background" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    [BlurView.view addSubview:imageView];
    

    scrollModalView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 85, Mywidth, Myheight-135-50-85)];
    scrollModalView.contentSize = CGSizeMake(Mywidth*3-300+250, Myheight-135-50-105);
    scrollModalView.contentOffset = CGPointMake(80, 0);
    scrollModalView.delegate = self;
    scrollModalView.pagingEnabled = YES;
    scrollModalView.tag = MODAL_TAG;
    [scrollModalView setShowsHorizontalScrollIndicator:NO];
    [scrollModalView setShowsVerticalScrollIndicator:NO];
    [BlurView.view addSubview:scrollModalView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(120, 20, Mywidth-100, Myheight-135-50-125)];
    NSString *path1 = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@-1",sender.Store.ItemImageURL] ofType:@"png"];
    imageView1.image = [UIImage imageWithContentsOfFile:path1];
    [scrollModalView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(Mywidth+50, 20, Mywidth-100, Myheight-135-50-125)];
    imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-2.png",sender.Store.ItemImageURL]];
    [scrollModalView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(Mywidth+Mywidth-20, 20, Mywidth-100, Myheight-135-50-125)];
    imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-3.png",sender.Store.ItemImageURL]];
    [scrollModalView addSubview:imageView3];
  
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth*2-50-20, 0, 40, 40)];
    [cancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelModal:) forControlEvents:UIControlEventTouchUpInside];
    [scrollModalView addSubview:cancelButton];
    
    wordScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Myheight-135-60, Mywidth, 70)];
    wordScroll.contentSize = CGSizeMake(Mywidth*3, 50);
    wordScroll.delegate = self;
    wordScroll.pagingEnabled = YES;
    wordScroll.tag = MODAL_TAG2;
    [wordScroll setShowsHorizontalScrollIndicator:NO];
    [wordScroll setShowsVerticalScrollIndicator:NO];
    [BlurView.view addSubview:wordScroll];
    
    
    UIImageView *wordView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Mywidth, 70)];
    NSString *wordPath = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@-4",sender.Store.ItemImageURL] ofType:@"png"];
    wordView.image = [UIImage imageWithContentsOfFile:wordPath];
    [wordScroll addSubview:wordView];
    
    UIImageView *wordView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0+Mywidth, 0, Mywidth, 70)];
    NSString *wordPath2 = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@-5",sender.Store.ItemImageURL] ofType:@"png"];
    wordView2.image = [UIImage imageWithContentsOfFile:wordPath2];
    [wordScroll addSubview:wordView2];
    
    UIImageView *wordView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0+Mywidth*2, 0, Mywidth, 70)];
    NSString *wordPath3 = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@-6",sender.Store.ItemImageURL] ofType:@"png"];
    wordView3.image = [UIImage imageWithContentsOfFile:wordPath3];
    [wordScroll addSubview:wordView3];
    
  
    UIImageView *ButtonView = [[UIImageView alloc]initWithFrame:CGRectMake(45, Myheight-83, Mywidth-135, 25)];
    ButtonView.image = [UIImage imageNamed:@"滑动条.png"];
    [BlurView.view addSubview:ButtonView];

    self.pageControl = [[KYAnimatedPageControl alloc]initWithFrame:CGRectMake(45, Myheight-95,  185, 50)];
    self.pageControl.pageCount = 3;
    self.pageControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:0];
    self.pageControl.selectedColor = [UIColor yellowColor];
    self.pageControl.bindScrollView = wordScroll;
    self.pageControl.shouldShowProgressLine = YES;
    
    self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle;
    self.pageControl.indicatorSize = 15;
    self.pageControl.swipeEnable = YES;
    [BlurView.view addSubview:self.pageControl];
    [self.pageControl display];
    self.pageControl.didSelectIndexBlock = ^(NSInteger index){
        NSLog(@"Did Selected index : %ld",(long)index);
    };
    
   
    
    UIButton1 *PhotoButton = [[UIButton1 alloc]initWithFrame:CGRectMake(Mywidth-100, Myheight-80-12, 50, 50)];
    [PhotoButton setImage:[UIImage imageNamed:@"相机logo.png"] forState:UIControlStateNormal];
    PhotoButton.Store = sender.Store;
    [PhotoButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    [BlurView.view addSubview:PhotoButton];
    
//    potView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 6.5, 14, 14)];
//    potView.image = [UIImage imageNamed:@"点.png"];
//    [ButtonView addSubview:potView];
    
}

#pragma mark ----照相
-(void)takePhone:(UIButton1*)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        FZPickerController *picker = [[FZPickerController alloc] init];
        picker.fastFilter = sender.Store.fastFilter;
        picker.Store = sender.Store;
        [BlurView presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你的设备没有相机设备" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alertView show];
    }


}


#pragma mark ----关闭模态视图
-(void)cancelModal:(id)sender{

    [BlurView dismissViewControllerAnimated:YES completion:nil];


}

#pragma mark ----统一的底部视图
-(void)CombDownScrollView{
    [downScroll removeFromSuperview];
    UIView * temp = [self.view viewWithTag:PHONEBUTTON_TAG];
    [temp removeFromSuperview];
    downScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,Myheight-135,Mywidth, 135)];
    downScroll.backgroundColor = [[UIColor alloc]initWithRed:65.0/255.0 green:140.0/255.0 blue:255.0/255.0 alpha:1];
     downScroll.contentSize = CGSizeMake(Mywidth, 135);
    downScroll.userInteractionEnabled=YES;
    [downScroll setShowsHorizontalScrollIndicator:NO];

    [self.DetailView addSubview:downScroll];
    
    photoButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2-40, 100, 80, 80)];
    [photoButton setImage:[UIImage imageNamed:@"相机.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [downScroll addSubview:photoButton];
    
    [UIView animateWithDuration:0.5 animations:^{
        [downScroll setFrame:CGRectMake(0,Myheight-135-135,Mywidth, 135)];
    } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [photoButton setFrame:CGRectMake(Mywidth/2-40, 30, 80, 80)];
    } completion:nil];
    }];
    
}

-(void)photoButtonClick{
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
