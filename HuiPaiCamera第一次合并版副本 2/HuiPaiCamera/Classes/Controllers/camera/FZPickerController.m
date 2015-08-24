//
//  FZPickerController.m
//  cameraImagePick
//
//  Created by Flame on 15/8/11.
//  Copyright © 2015年 Flame. All rights reserved.
//

#import "FZPickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "photoViewController.h"
#import "HPViewController.h"
#import <CoreMotion/CoreMotion.h>


#define MainScreenWidth 375
#define MainScreenHeigh self.view.frame.size.height   //667

@interface FZPickerController ()
{
    double jiaodu;
    NSInteger JIUindex;
    UIImageView *JiuView ;
}


@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UIImageView *middleView;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong)CMMotionManager *cmm;

@end

@implementation FZPickerController

#pragma mark - View's Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.allowsEditing = NO;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.showsCameraControls = NO;
    self.delegate = self;
    
    self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
    
    //Up Button backgroud
    UIImageView *upButtonsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 54)];
    upButtonsView.image = [UIImage imageNamed:@"up.png"];
    [_buttonsView addSubview:upButtonsView];
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(63, 16, 24, 24)];
    [cancelButton setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:cancelButton];
    
    //Auxiliary line button
    UIButton *auxiliaryLineButton = [[UIButton alloc] initWithFrame:CGRectMake(126, 15, 24, 24)];
    [auxiliaryLineButton setImage:[UIImage imageNamed:@"参考线.png"] forState:UIControlStateNormal];
    [auxiliaryLineButton addTarget:self action:@selector(auxiliaryLineShow:) forControlEvents:UIControlEventTouchUpInside];
    auxiliaryLineButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:auxiliaryLineButton];
    
    //camera switch
    UIButton *cameraSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake(201, 15, 28, 24)];
    [cameraSwitchButton setImage:[UIImage imageNamed:@"镜头翻转.png"] forState:UIControlStateNormal];
    [cameraSwitchButton addTarget:self action:@selector(cameraSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cameraSwitchButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:cameraSwitchButton];
    
    //flash
    UIButton *flashButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 15, 24, 24)];
    [flashButton setImage:[UIImage imageNamed:@"闪光灯.png"] forState:UIControlStateNormal];
    [flashButton addTarget:self action:@selector(flashSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    flashButton.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:flashButton];
    
    //bottom View
    UIImageView *bottomButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MainScreenHeigh - 168, self.view.bounds.size.width, 168)];
    bottomButtonView.image = [UIImage imageNamed:@"down.png"];
    [_buttonsView addSubview:bottomButtonView];
    
    //shoot photo
    UIButton *shootbutton = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth/2 - 42, MainScreenHeigh - 126, 85, 85)];
    [shootbutton setImage:[UIImage imageNamed:@"拍摄按钮"] forState:UIControlStateNormal];
    [shootbutton addTarget:self action:@selector(cameraStart:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:shootbutton];
    
    //photo library
    UIButton *photoLibraryButtom = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/4 - 51, MainScreenHeigh - 114, 60, 60)];
    [photoLibraryButtom setImage:[UIImage imageNamed:@"相册.png"] forState:UIControlStateNormal];
    [photoLibraryButtom addTarget:self action:@selector(photoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:photoLibraryButtom];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(MainScreenWidth/2 - 80, MainScreenHeigh - 183, 160, 30)];
    slider.maximumValue = 0.0;
    slider.maximumValue = 3.0;
    slider.value = 1.5;
    self.middleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, self.view.bounds.size.width, self.view.bounds.size.height - 54 - 168)];
    self.middleView.backgroundColor = [UIColor clearColor];
    self.middleView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-yd1.png",self.Store.ItemImageURL]];
    NSLog(@"%@-yd1.png",self.Store.ItemImageURL);

    [_buttonsView addSubview:self.middleView];
    
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [_buttonsView addSubview:slider];

    
    self.cameraOverlayView = _buttonsView;
}



#pragma mark - Camera Controls Methods
- (IBAction)sliderValueChanged:(UISlider *)sender {
    float currentValue = sender.value;

    if (currentValue >= 0.0 && currentValue < 1.0) {
        sender.value = 0.0;
        if (self.middleView) {
            [self.middleView removeFromSuperview];
        }
        if (self.rightView){
            [self.rightView removeFromSuperview];
        }
    } else if (currentValue >= 1.0 && currentValue <= 2.0){
        sender.value = 1.5;
        if (!self.middleView) {
            self.middleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            self.middleView.backgroundColor = [UIColor clearColor];
            self.middleView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-yd1.png",self.Store.ItemImageURL]];
            NSLog(@"%@-yd1.png",self.Store.ItemImageURL);
        }
        if (self.rightView) {
            [self.rightView removeFromSuperview];
        }
        [_buttonsView addSubview:self.middleView];
    } else {
        sender.value = 3.0;
        if (!self.rightView) {
            self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(87,219, 250, 250)];
            self.rightView.backgroundColor = [UIColor clearColor];
            self.rightView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-yd2.png",self.Store.ItemImageURL]];
        }
        if (self.middleView) {
            [self.middleView removeFromSuperview];
        }
        [self.buttonsView addSubview:self.rightView];
    }
}

- (void)cancelAction:(id)sender{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)photoLibrary:(UIButton *)sender{
    photoViewController *photoView = [[photoViewController alloc]init];
    UINavigationController *navgationController = [[UINavigationController alloc]initWithRootViewController:photoView];
    [self presentViewController:navgationController animated:YES completion:nil];
}

-(void)cameraStart:(id)sender{
    [self takePicture];
    NSLog(@"jiaodu is %f",jiaodu);
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];

}

-(void)viewDidAppear:(BOOL)animated{
    _cmm = [[CMMotionManager alloc]init];
    _cmm.gyroUpdateInterval = 0.2;
    if (_cmm.gyroAvailable) {
        [_cmm startDeviceMotionUpdates];
        [_cmm startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData * __nullable gyroData, NSError * __nullable error) {
            double gravityX = _cmm.deviceMotion.gravity.x;
            double gravityY = _cmm.deviceMotion.gravity.y;
            //            double gravityZ = _cmm.deviceMotion.gravity.z;
            //            double zTheta = atan2(gravityZ,sqrtf(gravityX*gravityX+gravityY*gravityY))/M_PI*180.0;
            double xyTheta = atan2(gravityX,gravityY)/M_PI*180.0;
            NSString *gravityY2 = [NSString stringWithFormat:@"Pad与自身旋转角度为%f",xyTheta];
            jiaodu = xyTheta;
            NSString *gravityZ2 = [NSString stringWithFormat:@"Pad与水平面夹角为%f",jiaodu];
            NSLog(@"%@",gravityY2);
            NSLog(@"%@",gravityZ2);
        }];
    }else{
        NSLog(@"陀螺仪传感器无法使用");
    }
    
}





- (IBAction)cameraSwitchAction:(UIButton *)sender{
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ) {
        if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
            self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else {
            self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    } else {
        NSLog(@"设备不支持");
    }
    
}

- (IBAction)flashSwitchAction:(id)sender{
    NSLog(@"flashSwitchAction");
    if ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear]) {
        if (self.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        } else {
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        }
    } else {
        NSLog(@"设备不支持");
    }

}

- (IBAction)auxiliaryLineShow:(id)sender{
    NSLog(@"auxiliaryLineShow");
    
        if (JIUindex == 0) {
        JiuView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, self.view.bounds.size.width, self.view.bounds.size.height - 54 - 168)];
            [_buttonsView addSubview:JiuView];
        JiuView.image = [UIImage imageNamed:@"JIU.png"];
        JIUindex = 1;
        return;
    }else if(JIUindex == 1){
        [JiuView removeFromSuperview];
        JIUindex= 0;
        return;
    }
}

#pragma mark - UIImagePickController Delegate

-(void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    
    HPViewController *hpController = [[HPViewController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:hpController];
    hpController.tag = 1;
    hpController.MyImage = photo;
    hpController.jiaodu = jiaodu;
    hpController.fasterFilter = self.fastFilter;
    [self presentViewController:navigationController animated:YES completion:nil];

}


#pragma mark - Memory Warning Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark --------- 支持方向


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
