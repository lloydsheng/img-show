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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotBlogUpdateNotify:) name:KHotBlogUpdateNotify object:nil];
    
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 60);//应可以用属性设置
    imageListView = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
    imageListView.imageDelegate = self;
    imageListView.showsHorizontalScrollIndicator = NO;
    imageListView.showsVerticalScrollIndicator = NO;
    imageListView.scrollsToTop = YES;
    imageListView.delegate = self;
    [imageListView config];
    [self.view addSubview:imageListView];
    lastOffsetY = 0;
    
//    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 60);//应可以用属性设置
//    list = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
//    //list = [[ScrollImageListExView alloc] initWithFrame:rect withColumn:kGridItemCountEachRow];
//    list.imageDelegate = self;
//    [list config];
//    [self.view addSubview:list];
//    lastOffsetY = 0;
    
    
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
    if(scrollView.contentOffset.y - lastOffsetY > 10 && scrollView.contentOffset.y > 0)
    {
        [imageListView updateVisibleListWhenScroll2Down];
        
        if ([HotBlogDataModel shareInstance].isActive == NO
            && scrollView.contentSize.height - scrollView.contentOffset.y - self.view.frame.size.height < 200) 
        {
            [[HotBlogDataModel shareInstance] requestDataWithType:KRequestNextPage];
        }

    }
    else if(10 < lastOffsetY - scrollView.contentOffset.y && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height)
    {
        [imageListView updateVisibleListWhenScroll2Up];

    }
    else if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height)
    {
        

    }
    lastOffsetY = scrollView.contentOffset.y;
    //NSLog(@"current offset %d", lastOffsetY);
}

- (void) hotBlogUpdateNotify:(NSNotification*) notify
{
    NSDictionary* dic = notify.userInfo;
    NSNumber* number = [dic objectForKey:@"requestType"];
    if (number)
    {
        int requestType = [number intValue];
        if (requestType == kWBRequestTypeRefresh)
        {
            [imageListView config];
        }
        else if(requestType == kWBRequestTypeNextPage)
        {
            [imageListView configNextPage];
        }
    }
}

- (void) dealloc
{
    [imageListView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHotBlogUpdateNotify object:nil];
    [super dealloc];
}

- (void) onImgBtPressed:(id) sender
{
    UIView* view = (UIView*)sender;
    int index = view.tag;
    
    if (index < [self GetItemsCount])
    {
        BlogDataItem* itemData = (BlogDataItem*)[self GetImageItem:index];
        if (imgDisplay == nil) 
        {
            imgDisplay = [[UIImageView alloc] init];
            [self.view addSubview:imgDisplay];
            
            imgBt = [UIButton buttonWithType:UIButtonTypeCustom];
            [imgBt addTarget:self action:@selector(imgBtPressed:) forControlEvents:UIControlEventTouchUpInside];
            imgBt.tag = 10;
            [self.view addSubview:imgBt];
        }
        imgDisplay.hidden = NO;
        NSString* imgUrl = [UtilsModel GetFullBlogUrlStr:itemData.pic_pid withImgType:EImageMiddle];
        [imgDisplay setImageWithURL:[NSURL URLWithString:imgUrl]];
        //imgDisplay.frame = view.frame;
        imgDisplay.frame = [view convertRect:view.bounds toView:self.view];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        int width = [itemData.pic_pwidth intValue];
        int height = [itemData.pic_pheight intValue];
        float rateW = width * 1.0 / self.view.frame.size.width;
        float rateH = height * 1.0 / self.view.frame.size.height;
        
        if (rateH > 1 || rateW > 1)
        {
            width = width / MAX(rateH, rateW);
            height = height / MAX(rateH, rateW);
        }
        imgDisplay.frame = CGRectMake(0, 0, width, height);
        imgDisplay.center = self.view.center;
        
        [UIView commitAnimations];
        imgBt.frame = imgDisplay.frame;
        //[self.view bringSubviewToFront:imgBt];
        
    }

}

- (void) imgBtPressed:(id) sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    imgDisplay.frame = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
    
    imgBt.frame = imgDisplay.frame;
    imgDisplay.image = nil;
    imgDisplay.hidden = YES;
    
}

@end
