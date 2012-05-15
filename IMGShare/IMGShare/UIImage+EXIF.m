//
//  UIImage+EXIF.m
//  CameraKit
//
//  Created by Kai on 10/11/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import "UIImage+EXIF.h"
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CKImageMetadata.h"

@implementation UIImage (EXIF)

- (NSData *)imageDataWithCompressionQuality:(CGFloat)compressionQuality metadata:(CKImageMetadata *)metadata
{
	// Convert UIImage to JPEG with a specific compression quality.
	NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
	
	// If image has no CGImageRef or invalid bitmap format, return nil.
	if (imageData == nil)
	{
		return nil;
	}
	
	// If ImageIO framework is not available, just return the image data without any change.
	if (CGImageSourceCreateWithData == NULL)
	{
		return imageData;
	}
		
	return [[self class] taggedImageDataWithImageData:imageData properties:[metadata EXIFRepresentation]];
}

- (NSData *)imageDataWithMetadata:(CKImageMetadata *)metadata
{
	NSData *imageData = UIImagePNGRepresentation(self);
	
	// If image has no CGImageRef or invalid bitmap format, return nil.
	if (imageData == nil)
	{
		return nil;
	}
	
	// If ImageIO framework is not available, just return the image data without any change.
	if (CGImageSourceCreateWithData == NULL)
	{
		return imageData;
	}
    
	return [[self class] taggedImageDataWithImageData:imageData properties:[metadata EXIFRepresentation]];
}

+ (NSData *)taggedImageDataWithImageData:(NSData *)imageData properties:(NSDictionary *)properties
{
	NSMutableData *mutableImageData = [[NSMutableData alloc] init];
	
	CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
	
	CGImageDestinationRef imageDestinationRef = CGImageDestinationCreateWithData((CFMutableDataRef)mutableImageData, CGImageSourceGetType(imageSourceRef), 1, NULL);
	CGImageDestinationAddImageFromSource(imageDestinationRef, imageSourceRef, 0, (CFDictionaryRef)properties);
	CGImageDestinationFinalize(imageDestinationRef);
	CFRelease(imageDestinationRef);
	
	CFRelease(imageSourceRef);
	
	return [mutableImageData autorelease];
}

@end

void CKImageWriteToSavedPhotosAlbum(UIImage *image, CKImageMetadata *metadata)
{
	// Use ALAssetsLibrary if possible. (iOS 4.0 and above)
	Class ALAssetsLibraryClass = NSClassFromString(@"ALAssetsLibrary");
	if (ALAssetsLibraryClass)
	{
		ALAssetsLibrary *assetsLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
		
		if (&UIImagePickerControllerMediaMetadata != nil && [assetsLibrary respondsToSelector:@selector(writeImageToSavedPhotosAlbum:metadata:completionBlock:)])
		{
			// Save the image with metadata if supported. (iOS 4.1 and above)
			[assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] 
											   metadata:[metadata EXIFRepresentation] 
										completionBlock:^(NSURL *assetURL, NSError *error) {
											
										}];
		}
		else if ([assetsLibrary respondsToSelector:@selector(writeImageToSavedPhotosAlbum:orientation:completionBlock:)])
		{
            // Save the image without metadata if the OS doesn't support it. iOS [4.0, 4,1)
			[assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] 
											orientation:(ALAssetOrientation)[image imageOrientation] 
										completionBlock:^(NSURL *assetURL, NSError *error) {
											
										}];
		}
	}
	else
	{
        // iOS [3.0, 4.0)
		UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
	}
}
