//
//  ScrollImageListExView.h
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollImageListView.h"
#import "ColumnItemsList.h"
@interface ScrollImageListExView : UIScrollView<ColumnListDelegate>
{
    //列数
    int itemCountEachRow;
    //所有列的数组
    NSMutableArray* allItemsColumn;
    
    NSMutableArray* reuseList;
    
    int hightPreCache;
    int hightNextCache;
    
    int itemWidth;
    
    int eachItemWidGrap;
    
    id<ScrollImageListViewDelegate>                      imageDelegate;

    UIImageView* imgDisplay;
    
}

@property (nonatomic, assign) id imageDelegate;

- (ScrollImageListExView*) initWithFrame:(CGRect)frame withColumn:(int) column;

- (void) updateVisibleListWhenScroll2Down;

- (void) updateVisibleListWhenScroll2Up;

- (void) config;

@end
