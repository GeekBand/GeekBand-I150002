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


-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [groupArray count];
}

-(UITableViewCell*)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    ALAssetsGroup *group = [groupArray objectAtIndex:indexPath.row];
    cell.group = group;
    NSString* text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.text.text = text;
    return cell;
}
-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    return 50;
}
-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
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
            NSLog(@"%@",result);
            index++;

            [self MakeImageGroup];

            
        }
    }];

    if ([imageArray count] >= 1) {
          [self MakeImageGroup];
    }

        [UIView animateWithDuration:0.5 animations:^{
            [self.ListView setFrame:CGRectMake(20, 50,self.view.frame.size.width-40,0)];
        }];
        openOrNot = NO;



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


-(void)MakeScrollView:(NSInteger)index{

        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20,50,self.view.frame.size.width-40,self.view.frame.size.height)];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width-40,(60+90+(index/3)*(30+imageWidth))*1.5);
        scrollView.pagingEnabled = NO;
        scrollView.backgroundColor = [UIColor whiteColor];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [middleView addSubview:scrollView];
    
}


-(void)MakeImageGroup{
    NSInteger index2 = 0;
    NSInteger index3 = 0;
    
    blueOrNot = NO;
    

    
    
    for (ALAsset *result in imageArray) {
        iv = [[UIImageView alloc]initWithFrame:CGRectMake(index2*(5+imageWidth),index3*(5+imageWidth),imageWidth,imageWidth)];
        iv.image = [UIImage imageWithCGImage: result.thumbnail];
         [scrollView addSubview:iv];
        
        UIButton1 *button = [[UIButton1 alloc]initWithFrame:CGRectMake(index2*(5+imageWidth),index3*(5+imageWidth),imageWidth,imageWidth)];
        button.backgroundColor = [UIColor clearColor];
        button.Asset = result;
        [button addTarget:self action:@selector(selectImage2:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        
        index2++;
        if (index2==4) {
            index2 = 0;
            index3++;
        }
    }
}

-(void)selectImage2:(UIButton1*)sender{
    if (blueOrNot == YES) {
        UIView *view = [self.view viewWithTag:100];
        [view removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:sender.frame];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.tag = 100;
    [scrollView addSubview:imageView];
    blueOrNot = YES;
    mainImage.image = [UIImage imageWithCGImage:sender.Asset.defaultRepresentation.fullScreenImage];
    NextValue = [[ALAsset alloc]init];
    NextValue = sender.Asset;

}




-(void)selectImage:(UIButton1*)sender{
    ImageViewController *imageViewController = [[ImageViewController alloc]initWithALAsset:sender.Asset];
    [self.navigationController pushViewController:imageViewController animated:YES];


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
                    NSLog(@"%@",result);
                    index++;
                    
                    [self MakeScrollView:index];
                    [self MakeImageGroup];
                    
                    
                }
            }];
            NSLog(@"%@",group);
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Group not found");
    }];
    
    
}


@end
