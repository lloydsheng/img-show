//
//  HomePageViewController.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfGridItem.h"
//GridItemDelegate
@interface HomePageViewController : UIViewController<UIScrollViewDelegate>
{
    UIPageControl*      topPageView;
    UIScrollView*       topScrollView;
    
    NSMutableArray*     pageDataList;
    
    UIView*             gridView;
}

@end
