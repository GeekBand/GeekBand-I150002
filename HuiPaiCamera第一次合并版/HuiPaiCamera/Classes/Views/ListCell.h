//
//  ListCell.h
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/7.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (strong ,nonatomic)ALAssetsGroup *group;
@end
