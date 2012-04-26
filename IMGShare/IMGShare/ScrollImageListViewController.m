//
//  ScrollImageListViewController.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageListViewController.h"
#import "BlogDataItem.h"
#import "UtilsModel.h"
#import "HotBlogDataModel.h"
#import "constDef.h"

@implementation ScrollImageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
//    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 60);//应可以用属性设置
//    imageListView = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
//    imageListView.imageDelegate = self;
//    imageListView.showsHorizontalScrollIndicator = NO;
//    imageListView.showsVerticalScrollIndicator = NO;
//    imageListView.scrollsToTop = YES;
//    imageListView.delegate = self;
//    [imageListView config];
//    [self.view addSubview:imageListView];
//    lastOffsetY = 0;
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 60);//应可以用属性设置
    list = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
    //list = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
    list.imageDelegate = self;
    [list config];
    [self.view addSubview:list];
    lastOffsetY = 0;
    
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma ScrollImageListViewDelegate
- (id) GetImageItem: (int) itemIndex;
{
    NSMutableArray* imageDataList = [HotBlogDataModel shareInstance].hotBlogArray;
    if (itemIndex < imageDataList.count) {
        return [imageDataList objectAtIndex:itemIndex];
    }
    else
        return nil;
}

- (int) GetItemsCount
{
    NSMutableArray* imageDataList = [HotBlogDataModel shareInstance].hotBlogArray;
    return imageDataList.count;
}

- (CGSize) GetItemSize:(int) itemIndex
{
    NSMutableArray* imageDataList = [HotBlogDataModel shareInstance].hotBlogArray;
    if (itemIndex >= imageDataList.count) {
        return CGSizeZero;
    }
    BlogDataItem* item = [imageDataList objectAtIndex:itemIndex];
    return CGSizeMake([item.pic_pwidth floatValue], [item.pic_pheight floatValue]);
}

- (NSString*) GetItemUrlStr:(int) itemIndex
{
    NSMutableArray* imageDataList = [HotBlogDataModel shareInstance].hotBlogArray;
    if (itemIndex >= imageDataList.count) {
        return nil;
    }
    BlogDataItem* item = [imageDataList objectAtIndex:itemIndex];    
    return [UtilsModel GetFullBlogUrlStr:item.pic_pid withImgType:EImageThumb];
}

#pragma mark
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > lastOffsetY)
    {
        [list updateVisibleListWhenScroll2Down];

    }
    else if(scrollView.contentOffset.y < lastOffsetY)
    {
        [list updateVisibleListWhenScroll2Up];

    }
    lastOffsetY = scrollView.contentOffset.y;
    //NSLog(@"current offset %d", lastOffsetY);
}


@end
