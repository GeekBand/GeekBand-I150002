
//
//  CameraFactory.m
//  新主页
//
//  Created by 陈铭嘉 on 15/8/20.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#define Mywidth self.view.frame.size.width
#define Myheight self.view.frame.size.height
#define MEISHI_TAG 2
#define MAINSCROLL_TAG 1
#define FENGJ_TAG 3
#define WEIJ_TAG 4
#define JIANZHU_TAG 5
#import "CameraFactory.h"
#import "FastFilter.h"

@implementation CameraFactory

-(NSArray *)MakeCameraFactory:(NSInteger)senderTag
{
    NSArray *ItemImageArray = [self UseArray:senderTag];
    NSArray *InformationArray = [self UseArray2:senderTag];
    NSArray *FastFilter = [self FastFilter:senderTag];
    NSMutableArray *CameraArray = [NSMutableArray array];
    NSInteger index=0;
    for (NSString *ItemImage in ItemImageArray) {
        
        CameraStore *cameraStore = [[CameraStore alloc]initWithItemInformation1:nil ItemInformation2:nil ItemInformation3:nil ItemMoreImage1:nil ItemMoreImage2:nil ItemMoreImage3:nil ItemImageURL:ItemImage WangGeImage:nil WangZhengImage:nil FastFilter:[FastFilter objectAtIndex:index]];
        index++;
        [CameraArray addObject:cameraStore];
        
    }
    return  CameraArray;

}


-(NSArray *)UseArray:(NSInteger)senderTag{
    
    if(senderTag == MEISHI_TAG){
        NSArray *array = [NSArray arrayWithObjects:@"meishi1",@"meishi2",@"meishi3",@"meishi4",@"meishi5",@"meishi6", nil];
        return array;
    }else if(senderTag == FENGJ_TAG){
        
        NSArray *array = [NSArray arrayWithObjects:@"meinv0",@"meinv1",@"meinv2",@"meinv3", nil];
        return array;
    }else if(senderTag == WEIJ_TAG){
        NSArray *array = [NSArray arrayWithObjects:@"fengjing0",@"fengjing1",@"fengjing2",@"fengjing3", nil];
        return array;
    }if(senderTag == JIANZHU_TAG){
        
        NSArray *array = [NSArray arrayWithObjects:@"jianzhu1",@"jianzhu2",@"jianzhu3",@"jianzhu4", nil];
        return array;
    }
    return nil;
}

-(NSArray *)UseArray2:(NSInteger)senderTag{
    if(senderTag == MEISHI_TAG){
        NSArray *array = [NSArray arrayWithObjects:@"meishi1-1",@"meishi1-2",@"meishi1-3",nil];
        return array;
    }else if(senderTag == FENGJ_TAG){
        NSArray *array = [NSArray array];
        return array;
    }else if(senderTag == WEIJ_TAG){
        NSArray *array = [NSArray array];
        return array;
    }else if(senderTag == JIANZHU_TAG){
        NSArray *array = [NSArray array];
        return array;
    }
    return nil;
}










-(NSArray*)FastFilter:(NSInteger)senderTag{
    if(senderTag == MEISHI_TAG){
        
        FastFilter *fastFilter  = [[FastFilter alloc]initWithshareE:3.0 C:4.0 S:1.0 B:0.0 G:1.0];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter5 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter6 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];

        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4,fastFilter5,fastFilter6, nil];
        return array;
    }else if(senderTag == FENGJ_TAG){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }else if(senderTag == WEIJ_TAG){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }if(senderTag == JIANZHU_TAG){
        FastFilter *fastFilter = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter2 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter3 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        FastFilter *fastFilter4 = [[FastFilter alloc]initWithshareE:0.3731 C:1.2238 S:1.2015 B:0.1068 G:1.0477];
        NSArray *array = [NSArray arrayWithObjects:fastFilter,fastFilter2,fastFilter3,fastFilter4, nil];
        return array;
    }
    return nil;
}



@end
