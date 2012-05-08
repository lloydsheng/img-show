//
//  BlogItemView.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlogItemView.h"
#import "UIImageView+WebCache.h"
#import "constDef.h"
#import "UtilsModel.h"

@implementation BlogItemView

@synthesize userView;
@synthesize blogData;
@synthesize height;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithData:(BlogDataItem*) data frame:(CGRect) rect
{
    self = [self initWithFrame:rect];
    if (self) 
    {
        //self.blogData = data;
        userView = [[UserCtrl alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, KUserItemHeight)];
        [self addSubview:userView];
        
        int imgXOffset = (CGRectGetWidth(self.bounds) - KBlogImgDefaultWidth) / 2;
        blogPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + imgXOffset, self.bounds.origin.y + KUserItemHeight, KBlogImgDefaultWidth, KBlogImgDefaultHeight)];
        [self addSubview:blogPhoto];
        
        int textXOffset = (CGRectGetWidth(self.bounds) - KBlogTextWidth) / 2;
        blogContent = [[UITextView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + textXOffset, self.bounds.origin.y + KBlogImgDefaultHeight + KUserItemHeight, CGRectGetWidth(self.bounds) - textXOffset * 2, KBlogContentDefaultHeight)];
        blogContent.font = [UIFont fontWithName:@"Helvetica" size:12.0];

        blogContent.editable = NO;
        [self addSubview:blogContent];
        
        btList = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIButton* commentBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //[commentBt setBackgroundImage: [UIImage imageNamed:@"btn.png"] forState: UIControlStateNormal];
        //[commentBt setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
        //[commentBt setImage:[UIImage imageNamed:@"commentSel.png"] forState:UIControlStateHighlighted];
        
        [commentBt setTitle:@"评论" forState:UIControlStateNormal];
        commentBt.tag = EBtCmdComment; 
        [btList addObject:commentBt];
        [self addSubview:commentBt];
        
        [self updateWithData:data];
        
    }
    
    return self;
}
- (void) updateWithData:(BlogDataItem*) data
{
    if (data != nil && data != self.blogData)
    {
        self.blogData = data;

        NSString* fullImgUrl = [UtilsModel GetFullBlogUrlStr:data.pic_pid withImgType:EImageMiddle];//EImageMiddle
        [userView update:data.user.profile_image_url nick:data.user.name time:data.created_at];
        
        int imgHeight =  KBlogImgDefaultHeight;
        if (data.pic_pwidth && data.pic_pheight) {
            int tempWid = [data.pic_pwidth intValue];
            int tempHeight = [data.pic_pheight intValue];
            if(tempHeight != 0 && tempWid !=0)
            {
                imgHeight =  tempHeight * KBlogImgDefaultWidth / tempWid;
            }
        }
        [blogPhoto setFrame:CGRectMake(blogPhoto.frame.origin.x, blogPhoto.frame.origin.y, blogPhoto.bounds.size.width, imgHeight)];
        
        [blogPhoto setImageWithURL:[NSURL URLWithString:fullImgUrl] placeholderImage:[UIImage imageNamed:@"blogDefault.png"]];
        
        blogContent.text = data.text;
        //[blogContent sizeToFit]
        [blogContent setFrame:CGRectMake(blogContent.frame.origin.x, blogPhoto.frame.origin.y + blogPhoto.frame.size.height, blogContent.frame.size.width, blogContent.contentSize.height)];
        //[blogContent sizeToFit];
        
        height = KUserItemHeight + CGRectGetHeight(blogPhoto.frame) + CGRectGetHeight(blogContent.frame);
        UIButton* bt = nil;
        for ( UIButton* item in btList) {
            if (item.tag == EBtCmdComment) {
                bt = item;
            }
        }
        if (bt) {
            bt.frame = CGRectMake(10, self.bounds.origin.y + height, 40, 16);
            height += 20;    
        }
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
    }
    
}

- (void) onBtPressed:(UIButton*) sender
{
    switch (sender.tag) {
        case EBtCmdComment:
            //publish comment
            break;
        case EBtCmdRt:
            break;
            
        default:
            break;
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

- (void) dealloc
{
    [userView release], userView = nil;
    [blogPhoto release], blogPhoto = nil;
    [blogData release],blogData = nil;
    [btList release], btList = nil;
}

@end
