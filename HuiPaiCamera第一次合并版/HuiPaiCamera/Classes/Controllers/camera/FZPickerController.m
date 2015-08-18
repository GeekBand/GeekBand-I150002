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

@interface FZPickerController ()
{
double jiaodu;
}

@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *rightView;
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
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(95, 484, 150, 20)];
    slider.maximumValue = 0.0;
    slider.maximumValue = 3.0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [_buttonsView addSubview:slider];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(cameraStart:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:button];
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(100,self.view.frame.size.height-100, 100, 100)];
    backButton.backgroundColor = [UIColor yellowColor];
    [backButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:backButton];
    
    
//    
//    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(238, 497, 40, 40)];
//    cancelButton.backgroundColor = [UIColor redColor];
//    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_buttonsView addSubview:cancelButton];
    
    
    
    
    UIButton *photoLibraryButtom = [[UIButton alloc] initWithFrame:CGRectMake(278, 577, 40, 40)];
    photoLibraryButtom.backgroundColor = [UIColor purpleColor];
    [photoLibraryButtom setTitle:@"Photo Library" forState:UIControlStateNormal];
    [photoLibraryButtom addTarget:self action:@selector(photoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:photoLibraryButtom];
    
    self.cameraOverlayView = _buttonsView;
    
    

    


    
    
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


-(void)cameraStart:(id)sender{
    [self takePicture];

    NSLog(@"jiaodu is %f",jiaodu);
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];


}


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
            self.middleView = [[UIView alloc] initWithFrame:CGRectMake(137,269, 70, 70)];
            self.middleView.backgroundColor = [UIColor greenColor];
        }
        if (self.rightView) {
            [self.rightView removeFromSuperview];
        }
        [_buttonsView addSubview:self.middleView];
    } else {
        sender.value = 3.0;
        if (!self.rightView) {
            self.rightView = [[UIView alloc] initWithFrame:CGRectMake(137,269, 70, 70)];
            self.rightView.backgroundColor = [UIColor redColor];
        }
        if (self.middleView) {
            [self.middleView removeFromSuperview];
        }
        [self.buttonsView addSubview:self.rightView];
    }
}

- (void)cancelAction:(id)sender{
    NSLog(@"cancel");
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)photoLibrary:(UIButton *)sender{
    photoViewController *photoView = [[photoViewController alloc]init];
    [self presentViewController:photoView animated:YES completion:nil];
}


#pragma mark - UIImagePickController Delegate


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
