//
//  ScrollImageListViewController.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageListView.h"

@interface ScrollImageListViewController : UIViewController<ScrollImageListViewDelegate, UIScrollViewDelegate>
{
    //NSMutableArray*     imageDataList;
    ScrollImageListView*    imageListView;
    //上一次scrollview y偏移量
    int                 lastOffsetY;
}

@end
