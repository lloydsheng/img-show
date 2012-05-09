//
//  ImageScrollView.h
//  WeiboHD
//
//  Created by sina_lhp on 10-12-31.
//  Copyright 2010 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ImageLoader.h"

@class ImageLoader;
@class PhotoViewerViewController;

@interface ImageScrollViewDelegate  

- (void) onCancelImageView;

@end

@interface ImageScrollView : UIScrollView
{
	UIImageView *photoImageView;
	//ImageLoader *myImageLoader;
	
	NSString *photoUrl;
	bool touchedImageView,isZoom;
	//PhotoViewerViewController *myPhotoViewer;
    id      photoDelegate;
}

@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) NSString *photoUrl;
@property (nonatomic) bool isZoom;
@property (nonatomic,assign) UIActivityIndicatorView *loadActivity;
@property (nonatomic,assign) id photoDelegate;

- (void)loadImage:(NSString*) imgUrl withThumb:(UIImage*) thumbImg;
-(void)changeImageViewFrame;

@end
