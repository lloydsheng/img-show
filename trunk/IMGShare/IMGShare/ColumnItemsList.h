//
//  ColumnItemsList.h
//  IMGShare
//
//  Created by sina on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogDataItem.h"
#import "ScrollImageItem.h"

@protocol ColumnListDelegate <NSObject>

- (int) getTopCacheOffset;
- (int) getBottomCacheOffset;
- (ScrollImageItem*) getSubImageItem;
- (id) getSubDataItem:(int) allListIndex;
- (void) releaseSubImageItem:(ScrollImageItem*) imageItem;

@end

@interface ColumnItemsList : NSObject
{
    int     startIndex;
    int     endIndex;
    NSMutableArray*     itemsList;
    id<ColumnListDelegate> delegate;
    
    int     columnWidth;
    int     columnXPos;
}

@property (nonatomic, assign) int startIndex;
@property (nonatomic, assign) int endIndex;

- (id) init:(id) delegate withWidth:(int) columnWid offset:(int) posX;
- (void) initSubItem:(BlogDataItem*) dataItem withIndex:(int) index;
- (void) configItem:(BlogDataItem*) dataItem withIndex:(int) index;
- (void) configNextItem:(BlogDataItem*) dataItem;
- (void) configPreItem:(BlogDataItem*) dataItem;
//- (void) configItemBefore:(BlogDataItem*) dataItem withIndex:(int) index;
- (void) releaseItem:(int) index;
- (void) releaseFirstItem;
- (void) releaseLastItem;
- (int) getItemsCount;

- (CGPoint) getStartPos;

- (CGPoint) getFirstVisibleTLPos;
- (CGPoint) getFirstVisibleBLPos;

- (CGPoint) getLastVisibleTLPos;
- (CGPoint) getLastVisibleBLPos;

- (CGPoint) getEndPos;

- (int) getBeforeFirstVisibleIndex;

- (int) getAfterLastVisibleIndex;

- (bool) isTopCanAddItemInScreen:(int) topOffset;

- (bool) isBottomCanAddItemInScreen:(int) bottomOffset;

- (void) scrollUptoPosY:(int) offsetY;

- (void) scrollDowntoPosY:(int) offsetY;

@end
