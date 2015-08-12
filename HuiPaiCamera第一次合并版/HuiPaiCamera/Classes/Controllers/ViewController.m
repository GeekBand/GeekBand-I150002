//
//  ViewController.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#import "CameraStore.h"
#import "ViewController.h"
#import "DetailViewController.h"
#import "PopupView.h"
#import "LewPopupViewAnimationSpring.h"
#import "UIButton1.h"
#import "photoViewController.h"
#import "FZPickerController.h"
#import "HPViewController.h"

#define viewwidth self.view.frame.size.width
#define viewheight self.view.frame.size.height
@interface ViewController ()

@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)photoViewController *photoViewController;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetButton];
    [self SetFontScrollView];
    [self SetMiddleScrollView];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
        // Do any additional setup after loading the view, typically from a nib.
}





-(void)SetMiddleScrollView{
    NSArray *array = [NSArray arrayWithObjects:@"静物美食",@"自拍系列",@"建筑风景",@"趣味视觉", nil];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,120,viewwidth,500)];

    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(viewwidth*4,500);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:_scrollView];
    NSInteger index = 0;
    for ( NSString *i in array) {
        DetailViewController *detailView = [[DetailViewController alloc]initWithFrame:CGRectMake(index*viewwidth,0,viewwidth-20,500 ) title:i];
        [detailView setParentView:self];
        [_scrollView addSubview:detailView.view];
        index++;
    }
}



-(void)actionButton:(UIButton1*)sender{

    PopupView *view = [PopupView defaultPopupViewWith:sender.Store Index:[sender tag]WithController:self];
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationSpring new] dismissed:^{
        NSLog(@"动画结束");
    }];

}

-(void)SetFontScrollView{
    NSArray *array = [NSArray arrayWithObjects:@"静物美食",@"自拍系列",@"建筑风景",@"趣味视觉", nil];
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,60,viewwidth,50)];
    
    scrollView.contentSize = CGSizeMake(viewwidth*1.5,-100);
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor colorWithRed:119.0/255 green:184.0/255 blue:255.0/255 alpha:1.0];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:scrollView];
     NSInteger index = 0;
    for (NSString *i in array) {
       
        UIButton *meishi = [[UIButton alloc]initWithFrame:CGRectMake(10+(index*90),-65, 80, 60)];
//        meishi.backgroundColor = [UIColor redColor];
        meishi.tag = index;
        [meishi addTarget:self action:@selector(FontButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [meishi setTitle:i forState:UIControlStateNormal];
        index++;
        [scrollView addSubview:meishi];
    }
}

-(void)FontButtonClicked:(id)sender{
    NSInteger haha = [sender tag];
    [_scrollView setContentOffset:CGPointMake(haha*viewwidth, 0) animated:YES];
    
}


#pragma mark -------组装底部按钮
-(void)SetButton{

    UIButton *playButton = [[UIButton alloc]initWithFrame:CGRectMake(viewwidth/2-65, viewheight-110, 140, 120)];
    [playButton setImage:[UIImage imageNamed:@"playButton-normal"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"playButton-highlight"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBarController.view addSubview:playButton];
    
    UIButton *poseButton = [[UIButton alloc]initWithFrame:CGRectMake(viewwidth/2-45+125, viewheight-85, 80, 80)];
    [poseButton setImage:[UIImage imageNamed:@"pose"] forState:UIControlStateNormal];
    [self.tabBarController.view addSubview:poseButton];
    
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(viewwidth/2-145, viewheight-95, 90, 90)];
    [photoButton setImage:[UIImage imageNamed:@"photoStore"] forState:UIControlStateNormal];
    [photoButton addTarget:self
                    action:@selector(photoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view addSubview:photoButton];


}


#pragma mark ---------相册按钮

-(void)photoButtonAction:(id)sender{
    
    self.photoViewController = [[photoViewController alloc]init];
    UINavigationController *navgationController = [[UINavigationController alloc]initWithRootViewController:self.photoViewController];
    [self.navigationController presentViewController:navgationController animated:YES completion:nil];
}

#pragma mark ---------相机按钮

-(void)playButtonAction:(id)sender{
  
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        FZPickerController *picker = [[FZPickerController alloc] init];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你的设备没有相机设备" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alertView show];
    }


}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
