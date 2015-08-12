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

@interface FZPickerController ()

@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *rightView;

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
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.frame.size.width-100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(cameraStart:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsView addSubview:button];
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(100,self.view.frame.size.width-100, 100, 100)];
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


-(void)cameraStart:(id)sender{
    [self takePicture];


}


-(void)imagePickerController:(nonnull UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    
    HPViewController *hpController = [[HPViewController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:hpController];
    hpController.tag = 1;
    hpController.MyImage = photo;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
