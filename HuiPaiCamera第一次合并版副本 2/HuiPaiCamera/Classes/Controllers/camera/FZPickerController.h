//
//  FZPickerController.h
//  cameraImagePick
//
//  Created by Flame on 15/8/11.
//  Copyright © 2015年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastFilter.h"
#import "CameraStore.h"
@interface FZPickerController : UIImagePickerController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property(nonatomic,strong)UIImage *photo;
@property(nonatomic,strong)FastFilter* fastFilter;
@property(nonatomic,strong)CameraStore* Store;

@end
