//
//  SelfGridItem.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelfGridItem.h"
#import "UIImageView+WebCache.h"
#import "constDef.h"

@implementation SelfGridItem
@synthesize btDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        //CGRect btRect = CGRectMake(1, 1, frame.size.width - 2, frame.size.height -2);
        itemButton = [[UIButton alloc] initWithFrame:self.bounds];
        [itemButton addTarget:self action:@selector(btPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KGridItemWidth, KGridItemHeight)];
        itemImageView.image = [UIImage imageNamed:@"default_info.png"];
        //itemImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:itemImageView];
        //frame.size.width
        itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, KGridItemHeight, KGridItemWidth, frame.size.height - KGridItemHeight + 2)];
        itemTitle.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        itemTitle.textColor = [UIColor greenColor];
        [itemTitle setTextAlignment:UITextAlignmentCenter];
        [self addSubview:itemTitle];
    }
    return self;
}

- (void) updateInfo: (NSString*) imgUrl withTitle:(NSString*) title
{
    itemImageView.image = [UIImage imageNamed:@"default_info.png"];
    if (imgUrl) {
        [itemImageView setImageWithURL:[NSURL URLWithString:imgUrl]];        
    }
    itemTitle.text = title;
}

- (void) btPressed
{
    if ([btDelegate respondsToSelector:@selector(onProcessBtPressed:)]) {
        [btDelegate onProcessBtPressed:itemTitle.text];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
