//
//  ViewController.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HotBlogViewController.h"
#import "UserCtrl.h"
#import "HotBlogDataModel.h"
#import "constDef.h"
#import "BlogItemView.h"

@implementation HotBlogViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) loadView
{
    [super loadView];
    
    if(refreshView == nil)
    {
        refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -65, self.tableView.frame.size.width, 65)];
        [self.view addSubview:refreshView];
        refreshView.delegate = self;
        [refreshView refreshLastUpdatedDate];
        self.view.clearsContextBeforeDrawing = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotBlogUpdateNotify:) name:KHotBlogUpdateNotify object:nil];
    
    if(curPopUser == nil)
    {
        
        curPopUser = [[UserCtrl alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, KUserItemHeight)];
        popUserStatus = EPopTitleNotMove;
        //currentItemIndex = -1;
        [curPopUser setBgAlpha];
        offsetStatus = ETableNotInit;
    }
    
    if (oldPopUser == nil ) {
        oldPopUser = [[UserCtrl alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, KUserItemHeight)];
        [oldPopUser setBgAlpha];
        [oldPopUser setHidden:YES];
        
        [self.view addSubview:oldPopUser];
        
    }
    
    self.tableView.scrollsToTop = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[refreshView release]; refreshView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (curPopUser.superview == nil && offsetStatus != ETableNotInit)
    {
        [self.view.superview addSubview:curPopUser];

    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    curPopUser.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, KUserItemHeight);
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma tableview datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"userCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        
        BlogDataItem* data = [[HotBlogDataModel shareInstance].hotBlogArray objectAtIndex:[indexPath row]];
        BlogItemView* blog = [[BlogItemView alloc] initWithData:data frame:cell.bounds];
        blog.tag = KBlogItemTag;
        [cell addSubview:blog];
        [blog release];
    }
    else
    {
        BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
        if ([indexPath row] < [HotBlogDataModel shareInstance].hotBlogArray.count) {
            [blog updateWithData:[[HotBlogDataModel shareInstance].hotBlogArray objectAtIndex:[indexPath row]]];
            [blog.userView setHidden:NO];
        }
    }


    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [HotBlogDataModel shareInstance].hotBlogArray.count;
    return count;
}

#pragma tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    BlogItemView* blog = (BlogItemView*)[cell viewWithTag:10];
    if (blog) {
        return blog.height;
    }
    else
        return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[ self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //[ super tableView:tableView didDeselectRowAtIndexPath:indexPath];
    return nil;
}

#pragma datasource
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	reloading = YES;
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	reloading = NO;
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark scroll callback

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"curPopUser isHidden %@", NSStringFromCGRect(self.view.bounds));
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
    int offsetY = scrollView.contentOffset.y;
    int offsetHight = scrollView.contentSize.height;
    
    if ([HotBlogDataModel shareInstance].isActive == NO
        && offsetHight - offsetY < self.view.frame.size.height * 3) {
        [[HotBlogDataModel shareInstance] requestDataWithType:KRequestNextPage];
    }
    
    if (offsetY < 0 && offsetStatus != ETableNotInit) {
        [curPopUser setHidden:YES];
        if(self.tableView.numberOfSections > 0)
        {
            NSIndexPath* viewItemPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:viewItemPath];
            BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
            [blog.userView setHidden:NO];
        }
        
        offsetStatus = ETableRefresh;
        return;
    }
    
    CGPoint pos = self.tableView.bounds.origin;
    //pos.y += 1;
    bool moveDown = NO;
    if(lastOffsetY < scrollView.contentOffset.y)
    {
        pos.y += curPopUser.frame.size.height;
        moveDown = YES;

    }
    
    NSIndexPath* index  = [self.tableView indexPathForRowAtPoint: pos];
    
    if (ETableNotInit == offsetStatus)
    { 
        [self.view.superview addSubview:curPopUser];
        UIView* view = curPopUser.superview;

        [self.view.superview bringSubviewToFront:curPopUser]; 

        currentItemIndex = [index row];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:index];
        BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
        if (moveDown) 
        {
            [blog.userView setHidden: YES];

        }
        else
        {
            [blog.userView setHidden: NO];
        }
        [curPopUser setHidden:NO];

        [curPopUser updateWithOther: blog.userView];
        [oldPopUser updateWithOther:curPopUser];
        offsetStatus = ETableNormal;
    }
    else if(ETableRefresh == offsetStatus)
    {
        [curPopUser setHidden:NO];
        offsetStatus = ETableNormal;
        
        int offsetY = scrollView.contentOffset.y;
        if (offsetY == 0 && self.tableView.numberOfSections > 0) {
            NSIndexPath* viewItemPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:viewItemPath];
            BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
            [blog.userView setHidden:YES];
        }

    }
    else if([index row ] != currentItemIndex)
    {
        
        if([index row] > currentItemIndex)
        {
            currentItemIndex = [index row];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:index];

            [curPopUser setHidden:YES];
            [oldPopUser updateWithOther:curPopUser];
            [oldPopUser setFrame:CGRectMake(curPopUser.frame.origin.x, cell.frame.origin.y - oldPopUser.frame.size.height, curPopUser.bounds.size.width, curPopUser.bounds.size.height )];
            [oldPopUser setHidden:NO];
        }
        else
        {
            currentItemIndex = [index row];
            
            //[curPopUser removeFromSuperview];
            [curPopUser setHidden:YES];
            NSIndexPath* viewItemPath = [NSIndexPath indexPathForRow:index.row + 1 inSection:0];

           // NSIndexPath* viewItemPath = [[[NSIndexPath  in: currentItemIndex + 1 length: index.length];
            UITableViewCell* oldCell = [self.tableView cellForRowAtIndexPath:index];
            BlogItemView* oldBlog = (BlogItemView*)[oldCell viewWithTag:KBlogItemTag];

            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:viewItemPath];
            BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
            [blog.userView setHidden:NO];
            
            [oldPopUser updateWithOther:oldBlog.userView];
            [oldPopUser setFrame:CGRectMake(oldPopUser.frame.origin.x, cell.frame.origin.y - oldPopUser.frame.size.height, curPopUser.bounds.size.width, curPopUser.bounds.size.height )];
            [oldPopUser setHidden:NO]; 
        }
    
    }
    else if([oldPopUser isHidden] == NO )
    {
        if (moveDown && offsetY - oldPopUser.frame.origin.y > oldPopUser.frame.size.height)
        {
            currentItemIndex = [index row];
            [oldPopUser setHidden:YES];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:index];
            BlogItemView* blog = (BlogItemView*)[cell viewWithTag:KBlogItemTag];
            [blog.userView setHidden:YES];
            
            [curPopUser updateWithOther: blog.userView];    
            [curPopUser setHidden:NO];
        }
        else if(moveDown == NO && offsetY - oldPopUser.frame.origin.y < 0)
        {
            [curPopUser updateWithOther:oldPopUser];
            [curPopUser setHidden:NO];
            
            [oldPopUser setHidden:YES];
        }

    }
    
    lastOffsetY = scrollView.contentOffset.y;
    
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void) hotBlogUpdateNotify:(NSNotification*) notify
{
    [self.tableView reloadData];
}

- (void) dealloc
{
    [curPopUser release], curPopUser = nil;
    [oldPopUser release], oldPopUser = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KHotBlogUpdateNotify object:nil];
    [super dealloc];
}

@end
