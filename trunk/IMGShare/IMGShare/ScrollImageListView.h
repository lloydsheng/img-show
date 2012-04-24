//
//  ScrollImageListView.h
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollImageListViewDelegate <NSObject>

- (id) GetImageItem: (int) itemIndex;
- (int) GetItemsCount;
- (CGSize) GetItemSize:(int) itemIndex;
- (NSString*) GetItemUrlStr:(int) itemIndex;
@end

@interface ScrollImageListView : UIScrollView
{
    NSMutableArray*        initPosInFirstRow;//记录第一行元素左下角位置
    NSMutableArray*        allItemsPosArr;//所有item的pos，即排板
    NSMutableArray*        visibleItemList;//y值递增排序可视队列
    NSMutableArray*        reuseItemList;//非可视待重用队列
    
    NSMutableArray*        nextPageItemPosArr;//下一页要载入新子项的位置,递增排序，数量固定为可显示的列数
    NSMutableArray*        prePageItemPosArr;//上一页要载入新子项的位置，递增排序，数量固定为可显示的列数
    
    int                    nextPageCachePosHeight;//下面暂存内存中的内容的高度
    int                    proPageCachePosHeight;//上面暂存内存中的内容的高度

    
    int                     eachItemWidGrap;
    int                     itemWidth;
    
    int                     countEachRow;
    
    id<ScrollImageListViewDelegate>                      imageDelegate;
}

@property (nonatomic, assign) id    imageDelegate;
- (id) initWithFrame: (CGRect) frame withRowCount: (int) rowCount;

//- (void) configLayout:(NSArray*) listPosArr;

- (void) config;

- (void) updateVisibleListWhenScroll2Up;

- (void) updateVisibleListWhenScroll2Down;


@end
