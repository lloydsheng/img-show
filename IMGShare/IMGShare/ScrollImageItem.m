//
//  ScrollImageItem.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageItem.h"
#import "UIImageView+WebCache.h"

@implementation ScrollImageItem
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame: self.bounds];
        imageView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:imageView];
        imageBt = [[UIButton alloc] initWithFrame: self.bounds];
        [imageBt addTarget:delegate action:@selector(btPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBt];
        
        imageTitle = [[ UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:imageTitle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) config: (NSString*) imgUrl withIndex:(int) itemIndex
{
    imageView.frame = self.bounds;
    imageBt.frame = self.bounds;
    [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
     self.tag = itemIndex;
}

- (void) dealloc
{
    [imageView release], imageView = nil;
    [imageBt release], imageBt = nil;
    [imageTitle release], imageTitle = nil;
}

@end
