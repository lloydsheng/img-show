//
//  ScrollImageListViewController.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageListExView.h"
#import "ScrollImageListView.h"

@interface ScrollImageListViewController : UIViewController<ScrollImageListViewDelegate, UIScrollViewDelegate>
{
    //NSMutableArray*     imageDataList;
    //ScrollImageListExView*    imageListView;
    
    //上一次scrollview y偏移量
    int                 lastOffsetY;
    
    ScrollImageListExView*   imageListView;
    UIImageView* imgDisplay;
    UIButton*    imgBt;
}

@end
