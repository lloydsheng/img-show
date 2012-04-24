//
//  ScrollImageListExView.h
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollImageListView.h"

@interface ScrollImageListExView : UIScrollView
{
    //列数
    int itemCountEachRow;
    //所有列的数组
    NSMutableArray* allItemsColumn;
    //上一页暂存位置
    NSMutableArray* preCachePosArr;
    //下一页暂存位置
    NSMutableArray* nextCachePosArr;
    
    NSMutableArray* reuseList;
    
    int hightPreCache;
    int hightNextCache;
    
    int itemWidth;
    
    int eachItemWidGrap;
    
    id<ScrollImageListViewDelegate>                      imageDelegate;
    
}

- (void) config;

@end
