//
//  HomePageViewController.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"
#import "SelfGridView.h"
#import "HotBlogDataModel.h"
#import "SelfGridItem.h"
#import "constDef.h"

@interface HomePageViewController (Private)

- (void) getSubPage;

@end

@implementation HomePageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    pageDataList = [[NSMutableArray alloc] initWithObjects:@"house",@"beauty", @"tree", nil];
    
    //[self getSubPage];
    
    CGRect topScrollFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, KPageViewHeight);
    if (topScrollView == nil) {
        topScrollView = [[UIScrollView alloc] initWithFrame:topScrollFrame];
        topScrollView.pagingEnabled = YES;
        topScrollView.showsVerticalScrollIndicator = NO;
        topScrollView.showsHorizontalScrollIndicator = NO;
        topScrollView.delegate = self;
        
        [self.view addSubview:topScrollView];
    }
    
    CGRect topPageFrame = CGRectMake(20, topScrollFrame.origin.y + topScrollFrame.size.height - 20, topScrollFrame.size.width - 20 * 2, 20);
    if (topPageView == nil) {
        topPageView = [[UIPageControl alloc] initWithFrame:topPageFrame];

        [topPageView addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:topPageView];
    }
    
    [self getSubPage];
    
    int pageCount = pageDataList.count;
    topScrollView.contentSize = CGSizeMake(topScrollFrame.size.width * pageCount, topScrollFrame.size.height);
    topPageView.numberOfPages = pageCount;
    topPageView.currentPage = 0;
    
    //add grid view
    gridView = [[SelfGridView alloc] initWithFrame:CGRectMake(0, KPageViewHeight, self.view.bounds.size.width, self.view.bounds.size.height - KPageViewHeight)];
    
    NSDictionary* typeList = [HotBlogDataModel shareInstance].typeList;
    int leftOffsetX = 10;
    int grapWidth = 20;
    int grapHeight = 20;
    NSArray* titles = [typeList allKeys];
    for (int index = 0; index < typeList.count; index++) {
        int posX = leftOffsetX + (KGridItemWidth + grapWidth) * (index % 4);
        int posY = 20 + (KGridItemHeight + grapHeight) * (index / 4);
        SelfGridItem* item = [[SelfGridItem alloc] initWithFrame:CGRectMake(posX, posY, KGridItemWidth, KGridItemHeight + 14)];
        if (index % 2 == 0) {
            [item setBackgroundColor:[UIColor grayColor]];
        }
        else
        {
            [item setBackgroundColor:[UIColor whiteColor]];
        }
        [item updateInfo: nil withTitle: [titles objectAtIndex:index]];
        item.btDelegate = self;
        [gridView addSubview:item];
        [item release];
    }
    [self.view addSubview:gridView];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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

- (void) pageChange:(id) sender
{
    int width = topScrollView.frame.size.width;
    CGRect frame = CGRectMake(width * topPageView.currentPage, self.view.bounds.origin.y, width, KPageViewHeight);

    [topScrollView scrollRectToVisible:frame animated:YES];
}

- (void) getSubPage
{
    int index = 0;
    int width = topScrollView.frame.size.width;
    for (NSString* path in pageDataList) {
        CGRect frame = CGRectMake(self.view.bounds.origin.x + width * index, self.view.bounds.origin.y, width, KPageViewHeight);
        UIImageView* view = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        UIImage* img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"jpg"]];
        view.image = img;
        [topScrollView addSubview:view];
        index++;
    }
}

#pragma mark
#pragma GridItemDelegate methods
-(void) onProcessBtPressed:(NSString*) btTitle;
{
    if (btTitle == nil) {
        return;
    }
    
    NSDictionary* typeList = [HotBlogDataModel shareInstance].typeList;
    NSArray* typeArray = [typeList allKeys];
    for (int index = 0; index < typeArray.count; index++) {
        if ([btTitle isEqualToString:[typeArray objectAtIndex:index]])
        {
            NSString* code = [typeList objectForKey:btTitle];
            //
            [[HotBlogDataModel shareInstance] requestData:code withRequestType:kRequestRefresh];
            break;
        }
    }

}

#pragma mark
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int viewWidth = scrollView.frame.size.width;
    int pageIndex = floor(scrollView.contentOffset.x / viewWidth);
    if (pageIndex < pageDataList.count) {
        topPageView.currentPage = pageIndex;
    }
}

- (void) dealloc
{
    [topPageView release];
    [topScrollView release];
    [pageDataList release];
}

@end
