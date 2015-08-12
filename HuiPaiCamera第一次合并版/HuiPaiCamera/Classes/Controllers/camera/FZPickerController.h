//
//  FZPickerController.h
//  cameraImagePick
//
//  Created by Flame on 15/8/11.
//  Copyright © 2015年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZPickerController : UIImagePickerController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property(nonatomic,strong)UIImage *photo;

@end
