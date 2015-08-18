//
//  ViewController.m
//  HuiPaiPS1
//
//  Created by huzhigang on 15/8/11.
//  Copyright © 2015年 huzhigang. All rights reserved.
//

#import "HPViewController.h"
#import "GPUImage.h"
#import "FXViewController.h"
#import "UIImage+Zoom.h"
#import "UIImage+SvImageEdit.h"
enum {
    enSvCropClip,               // the image size will be equal to orignal image, some part of image may be cliped
    enSvCropExpand,             // the image size will expand to contain the whole image, remain area will be transparent
};
typedef NSInteger SvCropMode;

#define ALIGN_BUTTON_TAG 100
#define CLIP_TABITEM_TAG 101
#define FILTER_TABITEM_TAG 102
#define ADJUST_TABITEM_TAG 103
#define CLIP_SQUARE_BUTTON_TAG 104
#define CLIP_RECTANGLE_BUTTON_TAG 105
#define CLIP_TALL_RECTANGLE_BUTTON_TAG 106
#define CLIP_ROTATE_BUTTON_TAG 107

#define ORIGINAL_FILTER_TAG         0
#define GRAYSCALE_FILTER_TAG        1
#define VIGNETTE_FILTER_TAG         2
#define EMBOSS_FILTER_TAG           3
#define SKETCH_FILTER_TAG           4
#define TOON_FILTER_TAG             5
#define SMOOTH_TOON_FILTER_TAG      6
#define ExposureFilter_TAG          7
#define ContrastFilter_TAG          8
#define SaturationFilter_TAG        9
#define BrightnessFilter_TAG        10
#define GammaFilter_TAG             11
#define HighlightShadowFilter_TAG   12
#define GaussianBlurFilter_TAG      13
#define OPZI_BUTTON_TAG             14



@interface HPViewController ()
{
    UIView *upBarView;
    UITabBar *tabBarView;
    UIView *clipView;
    UIScrollView *filterView;
    UIView *adjustView;
    UIImageView *photoView;
    
    UIImage *originalPhoto;
    UIImage *changedPhoto;
    UIImage *backupPhoto;
    
    BOOL isClippedLastTime;
    BOOL isFilterLastTime;
    NSInteger num;
    
}

-(void) savePicturetoAlbum;
-(void) sharePicture;
-(void) compareButtonDown;
-(void) compareButtonUp;
-(void) imageButtonClicked:(UIButton *)sender;

@end

@implementation HPViewController

#pragma mark - custom method

-(void) savePicturetoAlbum
{
    UIImageWriteToSavedPhotosAlbum(changedPhoto, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void) sharePicture
{
    FXViewController *fxViewController = [[FXViewController alloc]init];
    fxViewController.img = changedPhoto;
    [self.navigationController pushViewController:fxViewController animated:YES];
    
}

-(void) compareButtonDown
{
    photoView.image = originalPhoto;
    
}

-(void) compareButtonUp
{
    photoView.image = changedPhoto;
}



-(void)clipRatioWidth:(NSInteger)widthRatio Height:(NSInteger)heightRatio
{
    if (isClippedLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    CGSize clipSize;
    clipSize.width = backupPhoto.size.width;
    clipSize.height = clipSize.width/widthRatio*heightRatio;
    if (clipSize.height>backupPhoto.size.height) {
        clipSize.height = backupPhoto.size.height;
        clipSize.width = clipSize.height/heightRatio*widthRatio;
    }
    CGRect drawRect = CGRectMake((clipSize.width - backupPhoto.size.width)/2, (clipSize.height-backupPhoto.size.height)/2, backupPhoto.size.width, backupPhoto.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(clipSize.width, clipSize.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, clipSize.width, clipSize.height));
    [backupPhoto drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    changedPhoto = image;
    photoView.image = changedPhoto;

}


-(void)rotate90CounterClockwise
{
    UIImage *image = nil;
    switch (changedPhoto.imageOrientation) {
        case UIImageOrientationUp:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationLeft];
            break;
        }
        case UIImageOrientationDown:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationRight];
            break;
        }
        case UIImageOrientationLeft:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationDown];
            break;
        }
        case UIImageOrientationRight:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationUp];
            break;
        }
        case UIImageOrientationUpMirrored:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationRightMirrored];
            break;
        }
        case UIImageOrientationDownMirrored:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationLeftMirrored];
            break;
        }
        case UIImageOrientationLeftMirrored:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationUpMirrored];
            break;
        }
        case UIImageOrientationRightMirrored:
        {
            image = [UIImage imageWithCGImage:changedPhoto.CGImage scale:1 orientation:UIImageOrientationDownMirrored];
            break;
        }
        default:
            break;
    }
    
    changedPhoto = image;
    photoView.image = changedPhoto;
}



- (void)imageButtonClicked:(UIButton *)sender
{
    //CGFloat squareDimension;
    switch (sender.tag) {
        case OPZI_BUTTON_TAG:
            [self FastFilter];
            break;
        case ALIGN_BUTTON_TAG:
            [self FastAlign];
            break;
        case CLIP_SQUARE_BUTTON_TAG:
            [self clipRatioWidth:1 Height:1];
            break;
        case CLIP_RECTANGLE_BUTTON_TAG:
            [self clipRatioWidth:4 Height:3];
            break;
        case CLIP_TALL_RECTANGLE_BUTTON_TAG:
            [self clipRatioWidth:3 Height:4];
            break;
        case CLIP_ROTATE_BUTTON_TAG:
            [self rotate90CounterClockwise];
            break;
        case ORIGINAL_FILTER_TAG:
            [self originalFilter];
            break;
        case GRAYSCALE_FILTER_TAG:
            [self grayscaleFilter];
            break;
        case VIGNETTE_FILTER_TAG:
            [self vignetteFilter];
            break;
        case EMBOSS_FILTER_TAG:
            [self embossFilter];
            break;
        case SKETCH_FILTER_TAG:
            [self sketchFilter];
            break;
        case TOON_FILTER_TAG:
            [self toonFilter];
            break;
        case SMOOTH_TOON_FILTER_TAG:
            [self smoothtoonFilter];
            break;
        case ExposureFilter_TAG:
            [self ExposureFilter];
            break;
        case ContrastFilter_TAG:
            [self ContrastFilter];
            break;
        case SaturationFilter_TAG:
            [self SaturationFilter];
            break;
        case BrightnessFilter_TAG:
            [self BrightnessFilter];
            break;
        case GammaFilter_TAG:
            [self GammaFilter];
            break;
        case HighlightShadowFilter_TAG:
            [self HighlightShadowFilter];
            break;
        case GaussianBlurFilter_TAG:
            [self GaussianBlurFilter];
            break;
        default:
            break;
    }
    
    switch (sender.tag) {
        case CLIP_SQUARE_BUTTON_TAG:
        case CLIP_RECTANGLE_BUTTON_TAG:
        case CLIP_TALL_RECTANGLE_BUTTON_TAG:
            isClippedLastTime = YES;
            break;
            
        default:
            isClippedLastTime = NO;
            break;
    }
    
    switch(sender.tag)
    {
        case ALIGN_BUTTON_TAG:
        case OPZI_BUTTON_TAG:
        case GRAYSCALE_FILTER_TAG:
        case VIGNETTE_FILTER_TAG:
        case EMBOSS_FILTER_TAG:
        case SKETCH_FILTER_TAG:
        case TOON_FILTER_TAG:
        case SMOOTH_TOON_FILTER_TAG:
        case ExposureFilter_TAG:
        case ContrastFilter_TAG:
        case SaturationFilter_TAG:
        case BrightnessFilter_TAG:
        case GammaFilter_TAG:
        case HighlightShadowFilter_TAG:
        case GaussianBlurFilter_TAG:
            isFilterLastTime = YES;
            break;
        default:
            isFilterLastTime = NO;
            break;
    }
}

#pragma mark - GPUImage Filter method
-(void)originalFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    changedPhoto = [UIImage imageWithCGImage:backupPhoto.CGImage];
    photoView.image = changedPhoto;

}
-(void)grayscaleFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    GPUImageGrayscaleFilter* grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    [inputGPUImage addTarget:grayscaleFilter];
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)vignetteFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    GPUImageVignetteFilter* grayscaleFilter = [[GPUImageVignetteFilter alloc] init];
    [grayscaleFilter setVignetteCenter:CGPointMake(0.5, 0.5)];
    [grayscaleFilter setVignetteStart:0.5];
    [grayscaleFilter setVignetteEnd:0.5];
    
    
    [inputGPUImage addTarget:grayscaleFilter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    
    changedPhoto = output;
    photoView.image = changedPhoto;


}
-(void)embossFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    GPUImageEmbossFilter* grayscaleFilter = [[GPUImageEmbossFilter alloc] init];
    
    [inputGPUImage addTarget:grayscaleFilter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)sketchFilter
{
    if (isFilterLastTime == NO) {
    backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageSketchFilter* grayscaleFilter = [[GPUImageSketchFilter alloc] init];
    
    [inputGPUImage addTarget:grayscaleFilter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    changedPhoto = output;
    photoView.image = changedPhoto;


}
-(void)toonFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageToonFilter* grayscaleFilter = [[GPUImageToonFilter alloc] init];
    
    [inputGPUImage addTarget:grayscaleFilter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)smoothtoonFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];

    GPUImageSmoothToonFilter* grayscaleFilter = [[GPUImageSmoothToonFilter alloc] init];
    
    [inputGPUImage addTarget:grayscaleFilter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [grayscaleFilter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    changedPhoto = output;
    photoView.image = changedPhoto;
}

-(void)ExposureFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init];
    [filter setExposure:0.7];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];

    changedPhoto = output;
    photoView.image = changedPhoto;
}
-(void)ContrastFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
    [filter setContrast:2];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];

    changedPhoto = output;
    photoView.image = changedPhoto;
}
-(void)SaturationFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
    [filter setSaturation:2.0];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];
    
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)BrightnessFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    [filter setBrightness:0.5];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];

    
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)GammaFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init];
    [filter setGamma:3.0];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];

    
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)HighlightShadowFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
    [filter setHighlights:1.0];
    [filter setShadows:1.0];
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];
    
    changedPhoto = output;
    photoView.image = changedPhoto;

}
-(void)GaussianBlurFilter
{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    GPUImagePicture * inputGPUImage = [[GPUImagePicture alloc] initWithImage:backupPhoto];
    
    GPUImageGaussianBlurFilter*filter = [[GPUImageGaussianBlurFilter alloc] init];
    [filter setTexelSpacingMultiplier:8.0];
    [filter setBlurPasses:2.0];
    
    
    [inputGPUImage addTarget:filter];
    //    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [filter useNextFrameForImageCapture];
    [inputGPUImage processImage];
    //    [ghostGPUImage processImage];
    
    UIImage * output = [filter imageFromCurrentFramebuffer];

    
    changedPhoto = output;
    photoView.image = changedPhoto;

}

#pragma mark - Tabbar delegate methods

-(void)tabBar:(nonnull UITabBar *)tabBar didSelectItem:(nonnull UITabBarItem *)item
{
    switch (item.tag) {
        case CLIP_TABITEM_TAG:
            [self.view bringSubviewToFront:clipView];
            break;
        case FILTER_TABITEM_TAG:
            [self.view bringSubviewToFront:filterView];
            break;
        case ADJUST_TABITEM_TAG:
            [self.view bringSubviewToFront:adjustView];
            break;
        default:
            break;
    }
    
}


#pragma mark - custom view's liftcycle method

-(void) loadUpBar
{
    //设置上面深灰色的bar
    upBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,self.view.bounds.size.width, 89)];
    upBarView.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    [self.view addSubview:upBarView];
    
    //上面深灰色bar的按钮设置
    CGFloat upBarItemHeight = 60;
    UIButton *optimizeOneTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(10,(upBarView.bounds.size.height - upBarItemHeight)/2.0 , 63.5, upBarItemHeight)];
    [optimizeOneTimeButton setBackgroundImage:[UIImage imageNamed:@"一键优化图标"] forState:UIControlStateNormal];
    [optimizeOneTimeButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    optimizeOneTimeButton.tag = OPZI_BUTTON_TAG;
    [upBarView addSubview:optimizeOneTimeButton];
    
    UIButton *compareButton = [[UIButton alloc]initWithFrame:CGRectMake(upBarView.bounds.size.width/2.0 - 35,(upBarView.bounds.size.height - upBarItemHeight)/2.0 , 70, upBarItemHeight)];
    [compareButton setBackgroundImage:[UIImage imageNamed:@"对比图标"] forState:UIControlStateNormal];
    [compareButton addTarget:self action:@selector(compareButtonDown) forControlEvents:UIControlEventTouchDown];
    [compareButton addTarget:self
                      action:@selector(compareButtonUp)
            forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [upBarView addSubview:compareButton];
    
    UIButton *alignButton = [[UIButton alloc] initWithFrame:CGRectMake(upBarView.bounds.size.width - 10 - 76,(upBarView.bounds.size.height - upBarItemHeight)/2.0 , 76, upBarItemHeight)];
    alignButton.tag = ALIGN_BUTTON_TAG;
    [alignButton setBackgroundImage:[UIImage imageNamed:@"校准图标"] forState:UIControlStateNormal];
    [alignButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [upBarView addSubview:alignButton];
}

-(void)setNavigationBar
{
    //设置“保存” “分享”按钮
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePicturetoAlbum)];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharePicture)];
//    self.navigationItem.rightBarButtonItem = shareButton;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveButton,shareButton, nil]];
}

-(void)cancelAction:(id)sender{
    if (self.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.tag == 2 ){
        [self.navigationController popViewControllerAnimated:YES];
    }

}


-(void)loadTabView
{
    UITabBarItem *clipTabItem =
    [[UITabBarItem alloc]initWithTitle:nil
                                 image:[UIImage imageNamed:@"裁剪"]
                         selectedImage:[UIImage imageNamed:@"裁剪 cop"]];
    clipTabItem.tag = CLIP_TABITEM_TAG;
    
    UITabBarItem *filterTabItem =
    [[UITabBarItem alloc]initWithTitle:nil
                                 image:[UIImage imageNamed:@"滤镜"]
                         selectedImage:[UIImage imageNamed:@"滤镜 cop"]];
    filterTabItem.tag = FILTER_TABITEM_TAG;
    
    UITabBarItem *adjustTabItem =
    [[UITabBarItem alloc]initWithTitle:nil
                                 image:[UIImage imageNamed:@"贴纸"]
                         selectedImage:[UIImage imageNamed:@"贴纸 cop"]];
    adjustTabItem.tag = ADJUST_TABITEM_TAG;
    
    tabBarView = [[UITabBar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    tabBarView.translucent = NO;
    tabBarView.barTintColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    tabBarView.items = [NSArray arrayWithObjects:clipTabItem,filterTabItem,adjustTabItem, nil];
    tabBarView.delegate = self;
    tabBarView.selectedItem = [tabBarView.items objectAtIndex:0];
    [self.view addSubview:tabBarView];
    
}

-(void)loadTabUpViews
{
    CGFloat viewHeight = 90;
    clipView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49 - viewHeight, self.view.bounds.size.width, viewHeight)];
    clipView.backgroundColor = [UIColor colorWithRed:235/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    [self.view addSubview:clipView];
    
    CGFloat clipButtonDimension = 25;
    UIButton *clipSquareButton = [[UIButton alloc]initWithFrame:CGRectMake(clipView.bounds.size.width/5-clipButtonDimension/2, clipView.bounds.size.height/2 - clipButtonDimension/2+5, clipButtonDimension*0.75,clipButtonDimension*0.75)];
    clipSquareButton.tag = CLIP_SQUARE_BUTTON_TAG;
    clipSquareButton.backgroundColor = [UIColor clearColor];
    [clipSquareButton setBackgroundImage:[UIImage imageNamed:@"正方形"] forState:UIControlStateNormal];
    [clipSquareButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clipView addSubview:clipSquareButton];
    
    UIButton *clipRectangleButton = [[UIButton alloc]initWithFrame:CGRectMake(clipView.bounds.size.width/5*2-clipButtonDimension/2, clipView.bounds.size.height/2 - clipButtonDimension/2 + 5, clipButtonDimension,clipButtonDimension*0.75)];
    clipRectangleButton.tag = CLIP_RECTANGLE_BUTTON_TAG;
    clipRectangleButton.backgroundColor = [UIColor clearColor];
    [clipRectangleButton setBackgroundImage:[UIImage imageNamed:@"正方形"] forState:UIControlStateNormal];
    [clipRectangleButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clipView addSubview:clipRectangleButton];
    
    UIButton *clipTallRectangleButton = [[UIButton alloc]initWithFrame:CGRectMake(clipView.bounds.size.width/5*3-clipButtonDimension/2, clipView.bounds.size.height/2 - clipButtonDimension/2, clipButtonDimension*0.75,clipButtonDimension)];
    clipTallRectangleButton.tag = CLIP_TALL_RECTANGLE_BUTTON_TAG;
    clipTallRectangleButton.backgroundColor = [UIColor clearColor];
    [clipTallRectangleButton setBackgroundImage:[UIImage imageNamed:@"正方形"] forState:UIControlStateNormal];
    [clipTallRectangleButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clipView addSubview:clipTallRectangleButton];

    
    UIButton *clipRotateButton = [[UIButton alloc]initWithFrame:CGRectMake(clipView.bounds.size.width/5*4-clipButtonDimension/2, clipView.bounds.size.height/2 - clipButtonDimension/2 + 5, clipButtonDimension*0.75,clipButtonDimension*0.75)];
    clipRotateButton.tag = CLIP_ROTATE_BUTTON_TAG;
    clipRotateButton.backgroundColor = [UIColor clearColor];
    [clipRotateButton setBackgroundImage:[UIImage imageNamed:@"旋转"] forState:UIControlStateNormal];
    [clipRotateButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clipView addSubview:clipRotateButton];
    
    
    //滤镜ScrollView视图
    filterView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49 - viewHeight, self.view.bounds.size.width, viewHeight)];
    filterView.backgroundColor = [UIColor colorWithRed:235/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    filterView.contentSize = CGSizeMake(self.view.frame.size.width*2.3, viewHeight);
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"原色",@"黑白",@"圆影",@"浮雕",@"素描",@"卡通",@"细卡", @"曝光",@"对比",@"饱和",@"亮度",@"白平衡",@"阴影",@"模糊", nil];
    NSInteger index = 0;
    for ( NSString *labelName in array)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+index*60, 10, 50, 50)];
        [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =index;
        [button setTitle:labelName forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1];
        [filterView addSubview:button];
        index++;
        
    }

    [self.view addSubview:filterView];

    
    //微调视图
    adjustView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49 - viewHeight, self.view.bounds.size.width, viewHeight)];
    adjustView.backgroundColor = [UIColor colorWithRed:235/255.0 green:233/255.0 blue:232/255.0 alpha:1];
    [self.view addSubview:adjustView];
    
    [self.view bringSubviewToFront:clipView];


                                    
}

-(void)loadPhotoView
{
    photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64+89, self.view.bounds.size.width, self.view.bounds.size.height-64-89-90-49)];
    photoView.backgroundColor=[UIColor colorWithRed:215/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    photoView.contentMode=UIViewContentModeScaleAspectFit;
    photoView.image= changedPhoto;
    [self.view addSubview:photoView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationItem setHidesBackButton:NO];
    
    originalPhoto = [UIImage imageNamed:@"bg1"];
    originalPhoto = self.MyImage;
    changedPhoto = [UIImage imageNamed:@"bg1"];
    changedPhoto = self.MyImage;
    backupPhoto = [UIImage imageNamed:@"bg1"];
    backupPhoto = self.MyImage;
    isClippedLastTime = NO;
    isFilterLastTime = NO;
    
    //设置viewcontrol的背景颜色
    self.view.backgroundColor=[UIColor colorWithRed:215/255.0 green:214/255.0 blue:214/255.0 alpha:1];
    
    [self setNavigationBar];

    [self loadUpBar];
    
    [self loadTabView];
    
    [self loadTabUpViews];
    
    [self loadPhotoView];
    
    

    
}

#pragma mark - memory management method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)FastFilter{
    if (self.fasterFilter.exposure == 0.0&self.fasterFilter.contrast == 0.0) {
        return;
    }
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    

    
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc]init];
    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init];
            [filter setGamma:self.fasterFilter.gama];
    
    GPUImageBrightnessFilter *filter2 = [[GPUImageBrightnessFilter alloc] init];
           [filter2 setBrightness:self.fasterFilter.brightness];
    
    GPUImageSaturationFilter *filter3 = [[GPUImageSaturationFilter alloc] init];
    [filter3 setSaturation:self.fasterFilter.saturation];
    
    GPUImageContrastFilter *filter4 = [[GPUImageContrastFilter alloc] init];
    [filter4 setContrast:self.fasterFilter.contrast];
    
    GPUImageExposureFilter *filter5 = [[GPUImageExposureFilter alloc] init];
    [filter5 setExposure:self.fasterFilter.exposure];

    
    [filter addTarget:filter2];
    [filter2 addTarget:filter3];
    [filter3 addTarget:filter4];
    [filter4 addTarget:filter5];
    [filterGroup addFilter:filter2];
    [filterGroup addFilter:filter];
    [filterGroup addFilter:filter3];
    [filterGroup addFilter:filter4];
    [filterGroup addFilter:filter5];
    [(GPUImageFilterGroup *) filterGroup setInitialFilters:[NSArray arrayWithObject: filter]];
    [(GPUImageFilterGroup *) filterGroup setTerminalFilter:filter5];
    UIImage *quickFilteredImage = [filterGroup imageByFilteringImage:backupPhoto];
   
    photoView.image = quickFilteredImage;
    
}

-(void)FastAlign{
    if (isFilterLastTime == NO) {
        backupPhoto = [UIImage imageWithCGImage:changedPhoto.CGImage];
    }
    if (!num) {
        num = 1;
    }
    
    if (num == 2) {
        return;
    }
    num++;
    CGFloat jiaodu = 0;
    if (self.jiaodu >0) {
         jiaodu = 180 - self.jiaodu;
    }else if(self.jiaodu <0){
         jiaodu = -180 - self.jiaodu;
    }else {
        return;
    }
    
    CGFloat xNumber = (fabs((fabs(jiaodu)-45)/3.7)) + 4;
    if (fabs(jiaodu)<50) {
        if (fabs(jiaodu)>0) {
            xNumber = 18;
            if (fabs(jiaodu)>10) {
                xNumber = 7.5;   //原值8.5
                if (fabs(jiaodu)>20) {
                    xNumber = 6.14;
                    if (fabs(jiaodu)>30) {
                        xNumber = 5.35;
                    }
                }
            }
        }
    }
    
    
    if (fabs(jiaodu)>=50) {
        xNumber = 5;
        if (fabs(jiaodu)>70) {
            xNumber = 5.5;
            if (fabs(jiaodu)>80) {
                xNumber = 5.7;
                if (fabs(jiaodu)>85) {
                    xNumber = 6;
                }
            }
        }
    }
    
    NSLog(@"%f",xNumber);
    backupPhoto = [backupPhoto resizeImageToSize:CGSizeMake(1500, 1500) resizeMode:enSvResizeScale];
    backupPhoto = [self rotateImageWithRadian:M_PI/(180/jiaodu) cropMode:enSvCropClip];
    backupPhoto = [backupPhoto cropImageWithRect:CGRectMake((backupPhoto.size.width)/xNumber, (backupPhoto.size.height)/xNumber, backupPhoto.size.width - ((backupPhoto.size.width)/(xNumber/2)), backupPhoto.size.height - ((backupPhoto.size.height)/(xNumber/2)))];
    changedPhoto = backupPhoto;
    photoView.image = backupPhoto;

  

}


- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(SvCropMode)cropMode
{
    CGSize imgSize = CGSizeMake( photoView.image.size.width *  photoView.image.scale,  photoView.image.size.height * photoView.image.scale);
    CGSize outputSize = imgSize;
    if (cropMode == enSvCropExpand) {
        CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radian));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [ photoView.image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
     photoView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  photoView.image;
}


@end
