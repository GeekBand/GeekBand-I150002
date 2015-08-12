//
//  PopupView.m
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import "PopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSpring.h"
#import "FZPickerController.h"

#define PI 3.14159265358979323846
@interface PopupView()
@property (nonatomic , strong)UIViewController *view;
@property (nonatomic ,copy) NSArray *array1;
@property (nonatomic ,copy) NSArray *array2;
@property(nonatomic ,strong)CameraStore *cameraStore;
@property (nonatomic, assign) NSInteger choiceindex;
@end


@implementation PopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithCameraStore:(CameraStore*)cameraStore WithIndex:(NSInteger)index WithController:(UIViewController*)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cameraStore = cameraStore;
        self.Controller = controller;
        self.choiceindex = index;
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",cameraStore.ItemImageURL]];
        _imageView.image = image;
        self.array1 = [self UseArray];
        self.array2 = [self UseArray2];
        _label2.text = cameraStore.ItemInformation;
        _label3.text = cameraStore.ItemName;
        [self addSubview:_innerView];
        
    }
    return self;
}

-(NSArray *)UseArray{
    if([self.cameraStore.ItemTitle isEqualToString:@"自拍系列"]){
        NSArray *array = [NSArray arrayWithObjects:@"嘻嘻",@"腿玩年",@"遮遮",@"眼睛疼", nil];
        return array;
    }else if([self.cameraStore.ItemTitle isEqualToString:@"静物美食"]){
        NSArray *array = [NSArray arrayWithObjects:@"寻味",@"切片",@"撞色",@"食色诱惑", nil];
        return array;
    }else if([self.cameraStore.ItemTitle isEqualToString:@"建筑风景"]){
        NSArray *array = [NSArray arrayWithObjects:@"洱海",@"夜未央",@"轻吻海风",@"柠檬日光", nil];
        return array;
    }if([self.cameraStore.ItemTitle isEqualToString:@"趣味视觉"]){
        NSArray *array = [NSArray arrayWithObjects:@"廊镜头",@"墙你好",@"台阶态度",@"走廊空空", nil];
        return array;
    }
    return nil;
}

- (IBAction)okAction:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        FZPickerController *picker = [[FZPickerController alloc] init];
           [self.parentVC presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"你的设备没有相机设备" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)GG{
    [self.view dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rightAction:(id)sender {
    if ( self.choiceindex < 3) {
        self.choiceindex ++;
           _label3.text = [self.array1 objectAtIndex:self.choiceindex];

        _label2.text = [self.array2 objectAtIndex:self.choiceindex];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg",self.cameraStore.ItemTitle,(long)self.choiceindex]];
        _imageView.image = image;
    }else if (self.choiceindex == 3){
        self.choiceindex = 0;
        _label2.text = [self.array2 objectAtIndex:self.choiceindex];
        _label3.text = [self.array1 objectAtIndex:self.choiceindex];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg",self.cameraStore.ItemTitle,(long)self.choiceindex]];
        _imageView.image = image;
        
    }
}
- (IBAction)leftAction:(id)sender {
    if ( self.choiceindex >0) {
        self.choiceindex --;
        NSLog(@"%ld",(long)self.choiceindex);
        _label2.text = [self.array2 objectAtIndex:self.choiceindex];
        _label3.text = [self.array1  objectAtIndex:self.choiceindex];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg",self.cameraStore.ItemTitle,(long)self.choiceindex]];
        _imageView.image = image;
    }else if (self.choiceindex == 0){
        self.choiceindex = 3;
        _label2.text = [self.array2 objectAtIndex:self.choiceindex];
        _label3.text = [self.array1 objectAtIndex:self.choiceindex];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.jpg",self.cameraStore.ItemTitle,(long)self.choiceindex]];
        _imageView.image = image;
        
    }
}

-(NSArray *)UseArray2{
    if([self.cameraStore.ItemTitle isEqualToString:@"自拍系列"]){
        NSArray *array = [NSArray arrayWithObjects:@"镜头镜头,我和美食谁比较诱人嘞~",@"给自己拍出细长腿,so easy",@"大脸妹(哥)的福利，拿起身边的小道具，自拍吧~",@"给你看我最自信的一面", nil];
        return array;
    }else if([self.cameraStore.ItemTitle isEqualToString:@"静物美食"]){
        NSArray *array = [NSArray arrayWithObjects:@"轻轻舀起一勺,香气扑来",@"叠加的美食,视觉的盛宴",@"将透明融入丰富的色彩中，文艺的feel~",@"诱惑啊！记录下享受美食的过程吧~", nil];
        return array;
    }else if([self.cameraStore.ItemTitle isEqualToString:@"趣味视觉"]){
        NSArray *array = [NSArray arrayWithObjects:@"洱海",@"夜未央",@"轻吻海风",@"柠檬日光", nil];
        return array;
    }if([self.cameraStore.ItemTitle isEqualToString:@"建筑风景"]){
        NSArray *array = [NSArray arrayWithObjects:@"廊镜头",@"墙你好",@"台阶态度",@"走廊空空", nil];
        return array;
    }
    return nil;
}


+ (instancetype)defaultPopupViewWith:(CameraStore *)cameraStore Index:(NSInteger)index WithController:(UIViewController *)controller{
    
    return [[PopupView alloc]initWithFrame:CGRectMake(0, 0, 210, 300)WithCameraStore:cameraStore WithIndex:index WithController:controller];
}



- (IBAction)dismissViewSpringAction:(id)sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationSpring new]];
}


@end
