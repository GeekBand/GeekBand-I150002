//
//  MyCameraControllerViewController.m
//  NewCamera
//
//  Created by 陈铭嘉 on 15/8/18.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#define IMAGE_TAG 1
#define Mywidth self.view.frame.size.width
#define Myheight self.view.frame.size.height
#import "MyCameraControllerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import "photoViewController.h"
#import "HPViewController.h"
#import "UIImage+SvImageEdit.h"
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface MyCameraControllerViewController ()

{
    double jiaodu;
}
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (strong, nonatomic)  UIView *viewContainer;
@property (strong, nonatomic)  UIButton *takeButton;//拍照按钮
@property (strong, nonatomic)  UIButton *cancelButton;//关闭按钮
@property (strong, nonatomic)  UIButton *flashAutoButton;//自动闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOnButton;//打开闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOffButton;//关闭闪光灯按钮
@property (strong, nonatomic)  UIImageView *focusCursor; //聚焦光标
@property (strong, nonatomic)  UIButton *toggleButton;//前后镜头按钮
@property (strong, nonatomic)  UIButton *PictureButton;//网格图按钮
@property (strong, nonatomic)  UIButton *PhotoButton;//相册按钮
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UIImage *image;
@property (nonatomic, strong)CMMotionManager *cmm;
@end

@implementation MyCameraControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self CombButton];
    
    
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
//    [_captureVideoPreviewLayer captureDevicePointOfInterestForPoint:CGPointMake(200, 200)];
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    NSLog(@"jiaodu is %f",jiaodu);
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];
}


-(void)CombButton{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,Mywidth, 60)];
    view.backgroundColor = [[UIColor alloc]initWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];
    [self.view addSubview:view];
    
    self.viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0,60,Mywidth,Mywidth)];
    [self.view addSubview:self.viewContainer];
    
    self.focusCursor = [[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 50, 50)];
    self.focusCursor.image = [UIImage imageNamed:@"camera_focus_red.png"];
    self.focusCursor.alpha = 0;
    [self.view addSubview:self.focusCursor];
    
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2-170, 5, 50, 50)];
    [self.cancelButton setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(CancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.cancelButton];
    
    self.PictureButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2-85, 5, 50, 50)];
    [self.PictureButton setImage:[UIImage imageNamed:@"参考线.png"] forState:UIControlStateNormal];
    [self.PictureButton addTarget:self action:@selector(PictureClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.PictureButton];
    
    
//    self.flashAutoButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
//    self.flashAutoButton.backgroundColor = [UIColor redColor];
//    [self.flashAutoButton addTarget:self action:@selector(flashAutoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.flashOnButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2+125, 5, 50, 50)];
    [self.flashOnButton setImage:[UIImage imageNamed:@"闪光灯.png"] forState:UIControlStateNormal];
    [self.flashOnButton addTarget:self action:@selector(flashOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.flashOffButton = [[UIButton alloc]initWithFrame:CGRectMake(155, 5, 50, 50)];
    self.flashOffButton.backgroundColor = [UIColor redColor];
    [self.flashOffButton addTarget:self action:@selector(flashOffClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toggleButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2+35, 5, 50, 50)];
    [self.toggleButton setImage:[UIImage imageNamed:@"镜头翻转.png"] forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,60+Mywidth , Mywidth, Myheight-Mywidth-60)];
    NSLog(@"%f",backImage.frame.size.height);
    backImage.backgroundColor = [[UIColor alloc]initWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];
    
    _takeButton = [[UIButton alloc]initWithFrame:CGRectMake(Mywidth/2-50, Myheight-140, 100, 100)];
    [_takeButton setImage:[UIImage imageNamed:@"拍摄按钮.png"] forState:UIControlStateNormal];
    [_takeButton setImage:[UIImage imageNamed:@"拍摄按钮2.png"] forState:UIControlStateHighlighted];
    [_takeButton addTarget:self action:@selector(takeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.PhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(120, Myheight-140, 80, 80)];
    [self.PhotoButton setImage:[UIImage imageNamed:@"相册.png"] forState:UIControlStateNormal];
    [self.PhotoButton addTarget:self action:@selector(photoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:backImage];
    [view addSubview:self.toggleButton];
    [view addSubview:self.flashOnButton];
    [view addSubview:self.flashOffButton];
    [view addSubview:self.flashAutoButton];
    [self.view addSubview:self.takeButton];
    [self.view addSubview:self.PhotoButton];
    
    
}

-(void)dealloc{
    [self removeNotification];
}
#pragma mark - UI方法

#pragma mark 线形图

-(void)PictureClick:(id)sender {
    
    if ([self.view viewWithTag:IMAGE_TAG]) {
        [_imageView removeFromSuperview];
        return;
    }
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,60,Mywidth,Mywidth)];
    self.photo = [UIImage imageNamed:@"线性图.png"];
    _imageView.image = self.photo;
    _imageView.tag = IMAGE_TAG;
    [self.view addSubview:_imageView];
    

}

- (void)photoLibrary:(UIButton *)sender{
   
    photoViewController *photoView = [[photoViewController alloc]init];
     UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:photoView];
    [self presentViewController:navigationController animated:YES completion:nil];
}


-(void)CancelClick:(id)sender{
    NSLog(@"cancel");
    [_cmm stopGyroUpdates];
    [_cmm stopDeviceMotionUpdates];
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark 拍照
- (void)takeButtonClick:(id)sender {
    
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            _image=[UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
//           _image = [_image cropImageWithRect:CGRectMake(0,(60*_image.size.height)-Myheight ,_image.size.width, _image.size.width)];
            NSLog(@"jiaodu is %f",jiaodu);
            [_cmm stopGyroUpdates];
            [_cmm stopDeviceMotionUpdates];
            [self GG];
            //            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
            //            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        }
        
    }];
    
  
    

}
-(void)GG{
    UIImage *photo = _image;
    photo = [_image cropImageWithRect:CGRectMake(0,278,_image.size.width, _image.size.width)];
    HPViewController *hpController = [[HPViewController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:hpController];
    hpController.tag = 1;
    hpController.MyImage = photo;
    hpController.jiaodu = jiaodu;
    hpController.fasterFilter = self.fastFilter;
    [self presentViewController:navigationController animated:YES completion:nil];
    
}
#pragma mark 切换前后摄像头
- (void)toggleButtonClick:(UIButton *)sender {
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
    
    [self setFlashModeButtonStatus];
}

#pragma mark 自动闪光灯开启
- (void)flashAutoClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}
#pragma mark 打开闪光灯
- (void)flashOnClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];
}
#pragma mark 关闭闪光灯
- (void)flashOffClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];
}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.viewContainer];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置闪光灯按钮状态
 */
-(void)setFlashModeButtonStatus{
    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
    AVCaptureFlashMode flashMode=captureDevice.flashMode;
    if([captureDevice isFlashAvailable]){
        self.flashAutoButton.hidden=NO;
        self.flashOnButton.hidden=NO;
        self.flashOffButton.hidden=NO;
        self.flashAutoButton.enabled=YES;
        self.flashOnButton.enabled=YES;
        self.flashOffButton.enabled=YES;
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled=NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled=NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled=NO;
                break;
            default:
                break;
        }
    }else{
        self.flashAutoButton.hidden=YES;
        self.flashOnButton.hidden=YES;
        self.flashOffButton.hidden=YES;
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}
@end