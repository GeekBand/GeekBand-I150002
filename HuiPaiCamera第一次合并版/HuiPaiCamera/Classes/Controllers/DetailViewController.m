//
//  DetailViewController.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/5.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#define imageWidth (self.view.frame.size.width-20)/3-20
#import "DetailViewController.h"
#import "CameraStore.h"
#import "PopupView.h"
#import "LewPopupViewAnimationSpring.h"
#import "UIButton1.h"
#import "ViewController.h"
#import "FastFilter.h"
@interface DetailViewController ()
{
    ViewController *parentViewController;
}

@property(nonatomic , copy)NSString *viewtitle;
@property(nonatomic , strong)NSMutableArray *CameraArray;
@property (nonatomic, assign) NSInteger choiceindex;


@end

@implementation DetailViewController

-(void)setParentView:(ViewController *)parentView{

    parentViewController = parentView;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self CombCameraStore];
    self.view.backgroundColor = [UIColor clearColor];
    NSInteger index2 = 0;
    NSInteger index3 = 0;
    self.choiceindex = 0;
    

    for ( CameraStore *ct in self.CameraArray) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20+index2*(20+imageWidth),20+index3*(50+imageWidth),imageWidth,imageWidth)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",ct.ItemImageURL]];
        [self.view addSubview:imageV];
        
        
        UIButton1 *button = [[UIButton1 alloc]initWithFrame:CGRectMake(20+index2*(20+imageWidth),20+index3*(50+imageWidth),imageWidth,imageWidth)];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:ct.ItemTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
       
       
        
        button.tag = self.choiceindex;
        [button addTarget:self.parentViewController action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        button.Store = ct;
        [self.view addSubview:button];
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20+index2*(20+imageWidth),30+imageWidth+index3*(50+imageWidth), imageWidth, 10)];
        label.text = ct.ItemName;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        
    
        self.choiceindex ++;
        index2++;
        if (index2==3) {
            index2 = 0;
            index3++;
        }
    }
}





-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super init];
    if (self) {
          self.viewtitle = title;
        [self.view setFrame:frame];
      
       
    }
    return self;
}

-(NSArray *)UseArray{
    if([self.viewtitle isEqualToString:@"静物美食"]){
         NSArray *array = [NSArray arrayWithObjects:@"寻味",@"切片",@"撞色",@"食色诱惑", nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"自拍系列"]){
       
        NSArray *array = [NSArray arrayWithObjects:@"嘻嘻",@"腿玩年",@"遮遮",@"眼睛疼", nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"建筑风景"]){
        NSArray *array = [NSArray arrayWithObjects:@"廊镜头",@"墙你好",@"台阶态度",@"走廊空空", nil];
        return array;
    }if([self.viewtitle isEqualToString:@"趣味视觉"]){
        
        NSArray *array = [NSArray arrayWithObjects:@"洱海",@"夜未央",@"轻吻海风",@"柠檬日光", nil];
        return array;
    }
    return nil;
}

-(NSArray *)UseArray2{
    if([self.viewtitle isEqualToString:@"自拍系列"]){
        NSArray *array = [NSArray arrayWithObjects:@"镜头镜头,我和美食谁比较诱人嘞~",@"给自己拍出细长腿,so easy",@"大脸妹(哥)的福利，拿起身边的小道具，自拍吧~",@"给你看我最自信的一面", nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"静物美食"]){
        NSArray *array = [NSArray arrayWithObjects:@"轻轻舀起一勺,香气扑来",@"叠加的美食,视觉的盛宴",@"将透明融入丰富的色彩中，文艺的feel~",@"诱惑啊！记录下享受美食的过程吧~", nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"趣味视觉"]){
        NSArray *array = [NSArray arrayWithObjects:@"洱海",@"夜未央",@"轻吻海风",@"柠檬日光", nil];
        return array;
    }if([self.viewtitle isEqualToString:@"建筑风景"]){
        NSArray *array = [NSArray arrayWithObjects:@"廊镜头",@"墙你好",@"台阶态度",@"走廊空空", nil];
        return array;
    }
    return nil;
}

-(NSArray*)FastFilter{
    if([self.viewtitle isEqualToString:@"自拍系列"]){
       
        FastFilter *fastFilter  = [[FastFilter alloc]initWithshareE:3.0 C:4.0 S:1.0 B:0.0 G:1.0];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
         NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"静物美食"]){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }else if([self.viewtitle isEqualToString:@"趣味视觉"]){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }if([self.viewtitle isEqualToString:@"建筑风景"]){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }
    return nil;
}

-(void)CombCameraStore{
    NSArray *NameArray = [self UseArray];
    NSArray *InformationArray = [self UseArray2];
    NSArray *FastFilter = [self FastFilter];
    _CameraArray = [NSMutableArray array];
    NSInteger index=0;
    for (NSString *Name in NameArray) {
        
        CameraStore *cameraStore = [[CameraStore alloc]initWithItemName:Name ItemInformation:[InformationArray objectAtIndex:index] ItemTitle:_viewtitle ItemImage:[NSString stringWithFormat:@"%@%ld",self.viewtitle,(long)index] WangGeImage:nil WangZhengImage:nil FastFilter:[FastFilter objectAtIndex:index]];
          index++;
        [_CameraArray addObject:cameraStore];

    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
