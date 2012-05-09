    //
//  ImageScrollView.m
//  WeiboHD
//
//  Created by sina_lhp on 10-12-31.
//  Copyright 2010 Sina. All rights reserved.
//

#import "ImageScrollView.h"
//#import "PhotoViewerViewController.h"
#import "UIImageView+WebCache.h"

#define PHOTO_PADDING_TOP	74.0/2
#define PHOTO_PADDING_LEFT	98.0/2

@implementation ImageScrollView

@synthesize photoImageView,photoUrl,photoDelegate,loadActivity,isZoom;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


-(id)initWithFrame:(CGRect)frame
{
	if (self == [super initWithFrame:frame]) 
	{	
		isZoom = NO;
		
		UIImageView *photo_ImageView = [[UIImageView alloc] init];
		photo_ImageView.contentMode = UIViewContentModeScaleToFill;
		photo_ImageView.backgroundColor = [UIColor clearColor];
		photo_ImageView.alpha = 0.0;
		photo_ImageView.frame = CGRectMake(80, 80,self.frame.size.width-160, self.frame.size.height-160);
		self.photoImageView = photo_ImageView;
		[self addSubview:photoImageView];
		[photo_ImageView release];
		
		loadActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loadActivity.frame = CGRectMake(0, 0, 30, 30);
		loadActivity.center = self.center;
		[self addSubview:loadActivity];
		
	}
	
	return self;
	
}

- (void)loadImage: (NSString*) imgUrl withThumb:(UIImage*) thumbImg
{
    [loadActivity startAnimating];
    photoUrl = imgUrl;
    [photoUrl retain];
    
	//[myImageLoader setImageWithURL:photoUrl toView:photoImageView];
    [photoImageView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:thumbImg options: 0
                            success:^(UIImage *image) {
                                [self onImageLoadComplete];
                            } failure:^(NSError *error) {
                                [self onImageLoadComplete];
                            }];
}

- (void)dealloc {
	
 	[loadActivity release];
	[photoImageView release];
	//myImageLoader.delegate = nil;
	//[myImageLoader release];
	[photoUrl release];
	[super dealloc];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	UITouch *myTouch = [touches anyObject];
	CGPoint myPoint = [myTouch locationInView:self];
	
	int touchCount = [[touches allObjects] count];
	
	if (touchCount == 1) 
	{
		if (CGRectContainsPoint(photoImageView.frame, myPoint))
		{
			touchedImageView = NO;
		}
		else {
			touchedImageView = NO;
		}

	}
	else {
		touchedImageView = YES;
	}

	
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	touchedImageView = YES;
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if (touchedImageView == NO) 
	{
		//[myPhotoViewer onCancelTouched:nil];
        [photoDelegate onCancelImageView];
	}
	
}

-(void)changeImageViewFrame
{
	CGRect  photoRect = photoImageView.frame;
	photoRect.size = photoImageView.image.size;
	
	if(photoImageView.image.size.height<self.frame.size.height && photoImageView.image.size.width< self.frame.size.width)
	{
		photoImageView.frame = photoRect;
		photoImageView.center = self.center;
	}
	else if(photoImageView.image.size.height>self.frame.size.height && photoImageView.image.size.width<self.frame.size.width)
	{
		int image_x = (self.frame.size.width -photoImageView.image.size.width) /2;
		photoRect.origin.x = 0 + image_x;
		photoRect.origin.y = 0;
		photoImageView.frame = photoRect;
		self.contentSize =photoImageView.image.size;
		self.contentOffset = CGPointMake(0, 0);
		
	}
	else if(photoImageView.image.size.height<self.frame.size.height && photoImageView.image.size.width>self.frame.size.width)
	{
		photoRect.size.width = self.frame.size.width;
		photoRect.size.height = photoRect.size.width * photoImageView.image.size.height / photoImageView.image.size.width;
		photoImageView.frame = photoRect;
		photoImageView.center = self.center;
	}
	else
	{
		
		photoRect.origin.x = 0;
		photoRect.origin.y = 0;
		photoRect.size.width = self.frame.size.width ;
		photoRect.size.height = photoRect.size.width * photoImageView.image.size.height / photoImageView.image.size.width;
		photoImageView.frame = photoRect;
		
		self.contentSize =photoImageView.frame.size;
		self.contentOffset = CGPointMake(0, 0);
		
		if (photoImageView.frame.size.height < self.frame.size.height) 
		{
			photoImageView.center = self.center;
		}
		
	}
}

#pragma mark -
#pragma mark ImageLoader Delegates

- (void) onImageLoadComplete
{
	isZoom = YES;
	[loadActivity stopAnimating];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	photoImageView.alpha = 1.0;
	[UIView commitAnimations];
	
	[self changeImageViewFrame];
	
}


@end
