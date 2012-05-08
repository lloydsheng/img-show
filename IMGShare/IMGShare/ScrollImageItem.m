//
//  ScrollImageItem.m
//  IMGShare
//
//  Created by zhiyuan on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollImageItem.h"
#import "UIImageView+WebCache.h"
#import "constDef.h"

const int kImageWaitTag = 100;

@implementation UIImageView (WebCache)

- (void)startImgAnimating
{
    UIActivityIndicatorView* wait = nil;
    NSArray* arr = [self subviews];
    for (int index = 0; index < arr.count; index++)
    {
        UIView* item = [arr objectAtIndex: index];
        if (item.tag == kImageWaitTag && [item isKindOfClass:[UIActivityIndicatorView class]])
        {
            wait = (UIActivityIndicatorView*)item;
            break;
        }
    }
    if (wait == nil) {
        wait = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        wait.tag = kImageWaitTag;
        wait.center = self.center;
        [self addSubview:wait];
    }
    [wait startAnimating];
    
}
- (void)stopImgAnimating
{
    NSArray* arr = [self subviews];
    for (int index = 0; index < arr.count; index++)
    {
        UIView* item = [arr objectAtIndex: index];
        if (item.tag == kImageWaitTag && [item isKindOfClass:[UIActivityIndicatorView class]])
        {
            [(UIActivityIndicatorView*)item stopAnimating];
            break;
        }
    }
}
- (bool) isImgWaiting
{
    NSArray* arr = [self subviews];
    for (int index = 0; index < arr.count; index++)
    {
        UIView* item = [arr objectAtIndex: index];
        if (item.tag == kImageWaitTag && [item isKindOfClass:[UIActivityIndicatorView class]])
        {
           UIActivityIndicatorView* wait = (UIActivityIndicatorView*)item;

            return [wait isAnimating];
        }
    }
    return NO;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self stopImgAnimating];
    self.image = image;
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{
    [self stopImgAnimating];
    self.image = image;
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    [self stopImgAnimating];
}
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
    [self stopImgAnimating];
}
@end


@implementation ScrollImageItem
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame delegate:(id) delegate
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame: self.bounds];
        imageView.backgroundColor = [UIColor darkGrayColor];
        
        [self addSubview:imageView];
        imageBt = [[UIButton alloc] initWithFrame: self.bounds];
        [imageBt addTarget:delegate action:@selector(btPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    [imageView startImgAnimating];
    [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
     self.tag = itemIndex;
    self.hidden = NO;
}

- (void) releaseInfo
{
    self.frame = CGRectZero;
    imageView.image = nil;
    self.tag = 0;
    self.hidden = YES;
}

- (void) dealloc
{
    [imageView release], imageView = nil;
    [imageBt release], imageBt = nil;
    [imageTitle release], imageTitle = nil;
    [super dealloc];
}

@end
