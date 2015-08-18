//
//  photoViewController.m
//  HuiPaiCamera
//
//  Created by 陈铭嘉 on 15/8/6.
//  Copyright © 2015年 陈铭嘉. All rights reserved.
//
#define imageWidth (self.view.frame.size.width-40-15)/4
#import "photoViewController.h"
#import "ImageViewController.h"
#import "UIButton1.h"
#import "ListCell.h"
#import "HPViewController.h"
#import "CollectionCell.h"
#import "PictureCell.h"



@interface photoViewController()

{
    ALAsset *NextValue;
    NSMutableArray *groupArray;
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *imageArray;
    UIScrollView *scrollView;
    UIImageView *iv;
    UIImageView *mainImage;
    UIView *middleView;
    BOOL blueOrNot;
    BOOL openOrNot;
}

@property(strong,nonatomic)UITableView *ListView;

@property(strong,nonatomic)UITableView *PictureView;

@end


@implementation photoViewController

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor grayColor]];
    [self MakeBackButton];
    [self getAllPictures];

    
    mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(30,80,self.view.frame.size.width-60,210)];
    mainImage.image = [UIImage imageNamed:@"中间图.png"];
    [self.view addSubview:mainImage];
    
    middleView = [[UIView alloc]initWithFrame:CGRectMake(0,300, self.view.frame.size.width, self.view.frame.size.height )];
    middleView.backgroundColor = [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:0.5];
    [self.view addSubview:middleView];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(25,10,50, 40)];
    [button setImage:[UIImage imageNamed:@"List.png" ] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPhotoGroup:) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 150, 40)];
    label.text = @"Camera roll";
    [middleView addSubview:label];
    
    
    

    
//    [self MakeImageGroup];

}


-(void)selectPhotoGroup:(UIButton*)sender{
    if (!self.ListView) {
        self.ListView = [[UITableView alloc]initWithFrame:CGRectMake(20,50,self.view.frame.size.width-40,0) style:UITableViewStylePlain];
        [self.ListView setDataSource:self];
        [self.ListView setDelegate:self];
        [self.ListView setBackgroundColor:[UIColor blackColor]];
        [self.ListView setSeparatorColor:[UIColor clearColor]];
        [self.ListView setShowsVerticalScrollIndicator:NO];
        [self.ListView setTag:2];
        [self.ListView registerNib:[UINib nibWithNibName:@"ListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        [middleView addSubview:self.ListView];
        openOrNot = NO;
    }

    

    
    if (openOrNot == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.ListView setFrame:CGRectMake(20, 50,self.view.frame.size.width-40,50*[groupArray count])];
        }];
        openOrNot = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.ListView setFrame:CGRectMake(20, 50,self.view.frame.size.width-40,0)];
        }];
        openOrNot = NO;
    }
    
}

#pragma mark ------创造图片视图

-(void)MakePictureView{
    if (!self.PictureView) {
        self.PictureView = [[UITableView alloc]initWithFrame:CGRectMake(20,50,self.view.frame.size.width-40,self.view.frame.size.height)];
        [self.PictureView setDataSource:self];
        [self.PictureView setBackgroundColor:[UIColor clearColor]];
        [self.PictureView setSeparatorColor:[UIColor clearColor]];
        [self.PictureView setShowsVerticalScrollIndicator:NO];
        self.PictureView.rowHeight = (self.view.frame.size.width-40-20*2)/3+20;
        
        [self.PictureView setTag:1];
//        [self.PictureView registerNib:[UINib nibWithNibName:@"PictureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell2"];
        [middleView addSubview:self.PictureView];
        
    }


}





#pragma mark ------UItableviewController
-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView.tag == 2) {
        return [groupArray count];
    }else{
        if ([imageArray count]%3==0) {
            return [imageArray count]/3;
        }
        return ([imageArray count]/3+1) ;
        
        
        
    }
    
}

-(UITableViewCell*)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        ALAssetsGroup *group = [groupArray objectAtIndex:indexPath.row];
        cell.group = group;
        NSString* text = [group valueForProperty:ALAssetsGroupPropertyName];
        cell.text.text = text;
        return cell;
    }else{
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat width = (self.view.frame.size.width-40-20*2)/3;
       
        if ((3*indexPath.row+1)<=[imageArray count]) {
             UIButton1 *button1 = [[UIButton1 alloc]initWithFrame:CGRectMake(0, 0,width,width )];
            [button1 addTarget:self action:@selector(selectImage2:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,width,width )];
        ALAsset *image1 =[imageArray objectAtIndex:3*indexPath.row+0];
            button1.Asset = image1;
            imageView.image = [UIImage imageWithCGImage:image1.thumbnail];
              [cell2 addSubview:imageView];
             [cell2 addSubview:button1];
        }
        if ((3*indexPath.row+2)<=[imageArray count]) {
            UIButton1 *button2 = [[UIButton1 alloc]initWithFrame:CGRectMake(width+20,0, width,width )];
            [button2 addTarget:self action:@selector(selectImage2:) forControlEvents:UIControlEventTouchUpInside];
             UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(width+20,0, width,width )];
            ALAsset *image2 =[imageArray objectAtIndex:3*indexPath.row+1];
            button2.Asset = image2;
            imageView2.image = [UIImage imageWithCGImage:image2.thumbnail];
              [cell2 addSubview:imageView2];
                  [cell2 addSubview:button2];
        }
        
        if ((3*indexPath.row+3)<=[imageArray count]) {
            UIButton1 *button3 = [[UIButton1 alloc]initWithFrame:CGRectMake((width+20)*2,0, width, width) ];
              [button3 addTarget:self action:@selector(selectImage2:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake((width+20)*2,0, width, width)];
            ALAsset *image3 =[imageArray objectAtIndex:3*indexPath.row+2];
            button3.Asset = image3;
            imageView3.image = [UIImage imageWithCGImage:image3.thumbnail];
             [cell2 addSubview:imageView3];
                 [cell2 addSubview:button3];
        }
       
        
       
  
   
        
       
        return cell2;
    }
}

-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 143.5;
    }else {
        return 50;
    }
}


-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        NSInteger count = indexPath.row;
        NSArray *subviews = [scrollView subviews];
        if (![subviews count]==0) {
            [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [imageArray removeAllObjects];
        ListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ALAssetsGroup* group = cell.group;
        
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [imageArray insertObject:result atIndex:index];
                index++;
            }
        }];
        
        if ([imageArray count] >= 1) {
            [self.PictureView reloadData];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.ListView setFrame:CGRectMake(20, 50,self.view.frame.size.width-40,0)];
        }];
        openOrNot = NO;
    }




}







-(void)MakeBackButton{
    
   

    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back.png"] landscapeImagePhone:[UIImage imageNamed:@"Back.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(GG)];
    self.navigationItem.leftBarButtonItem = barbutton;
    
    UIBarButtonItem *nextbarbutton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(NextStep:)];
    
    self.navigationItem.rightBarButtonItem = nextbarbutton;
}


-(void)NextStep:(id)sender{
    
    HPViewController *hpViewController = [[HPViewController alloc]init];
    hpViewController.MyImage = mainImage.image;
    hpViewController.tag = 2 ;
    [self.navigationController pushViewController:hpViewController animated:YES];
    
}


-(void)GG{
    [self dismissViewControllerAnimated:YES completion:nil];

}




-(void)selectImage2:(UIButton1*)sender{
    if (blueOrNot == YES) {
        UIView *view = [self.view viewWithTag:100];
        [view removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sender.frame.size.width,sender.frame.size.height)];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.tag = 100;
    [sender addSubview:imageView];
    blueOrNot = YES;
    mainImage.image = [UIImage imageWithCGImage:sender.Asset.defaultRepresentation.fullScreenImage];
    NextValue = [[ALAsset alloc]init];
    NextValue = sender.Asset;

}








-(void)getAllPictures{
    assetsLibrary = [[ALAssetsLibrary alloc]init];
    groupArray = [[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            [groupArray addObject:group];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [imageArray insertObject:result atIndex:index];
                    
                    index++;
                    
                    [self MakePictureView];
//                    [self MakeScrollView:index];
//                    [self MakeImageGroup];
                    
                    
                }
            }];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found");
    }];
    
    
}


@end
