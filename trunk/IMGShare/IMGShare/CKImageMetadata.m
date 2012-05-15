//
//  CKImageMetadata.m
//  CameraKit
//
//  Created by Kai on 11/16/11.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import "CKImageMetadata.h"
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@implementation CKImageMetadata

- (id)initWithMetadata:(NSDictionary *)theMetadata
{
	if ((self = [super init]))
	{
		metadata = [[NSMutableDictionary alloc] initWithDictionary:theMetadata];
	}
	
	return self;
}

- (void)dealloc
{
	[metadata release], metadata = nil;
	
	[super dealloc];
}

- (void)setLocation:(CLLocation *)location
{
    if (&kCGImagePropertyGPSDictionary == nil)
    {
        return;
    }
    
	if (location == nil || (location.coordinate.latitude == 0 && location.coordinate.longitude == 0))
	{
		[metadata removeObjectForKey:(NSString *)kCGImagePropertyGPSDictionary];
		return;
	}
	
	NSMutableDictionary *locationDict = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
	
	CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
	
	// Latitude.
	if (latitude < 0)
	{
		latitude = fabs(latitude);
        [locationDict setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
	}
	else
	{
		[locationDict setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
	}
	
	[locationDict setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
	
	// Longitude.
	if (longitude < 0)
	{
		longitude = fabs(longitude);
		[locationDict setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
	}
	else
	{
		[locationDict setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
	}
	
	[locationDict setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString*)kCGImagePropertyGPSLongitude];
	
	[metadata setObject:locationDict forKey:(NSString *)kCGImagePropertyGPSDictionary];
}

- (CKImageMetadata *)metadataByReplacingImageOrientation:(CKEXIFImageOrientation)orientation
{
	CKImageMetadata *newMetadata = [[CKImageMetadata alloc] initWithMetadata:metadata];
	[newMetadata setImageOrientation:orientation];
	return [newMetadata autorelease];
}

- (void)setImageOrientation:(CKEXIFImageOrientation)orientation
{
    if (&kCGImagePropertyOrientation != nil)
    {
        // Set the image orientation in EXIF.
        [metadata setObject:[NSNumber numberWithInt:orientation] forKey:(NSString *)kCGImagePropertyOrientation];
    }
}

- (NSDictionary *)EXIFRepresentation
{
	return metadata;
}

@end

CKEXIFImageOrientation CKEXIFImageOrientationFromUIImageOrientation(UIImageOrientation imageOrientation)
{
	int exifImageOrientation = 0;
	switch (imageOrientation)
	{
		case UIImageOrientationUp:				exifImageOrientation = CKEXIFImageOrientationUp;			break;	// EXIF: 1
		case UIImageOrientationUpMirrored:		exifImageOrientation = CKEXIFImageOrientationUpMirrored;	break;	// EXIF: 2
		case UIImageOrientationDown:			exifImageOrientation = CKEXIFImageOrientationDown;			break;	// EXIF: 3
		case UIImageOrientationDownMirrored:	exifImageOrientation = CKEXIFImageOrientationDownMirrored;	break;	// EXIF: 4
		case UIImageOrientationLeftMirrored:	exifImageOrientation = CKEXIFImageOrientationLeftMirrored;	break;	// EXIF: 5
		case UIImageOrientationLeft:			exifImageOrientation = CKEXIFImageOrientationLeft;			break;	// EXIF: 6
		case UIImageOrientationRightMirrored:	exifImageOrientation = CKEXIFImageOrientationRightMirrored; break;	// EXIF: 7
		case UIImageOrientationRight:			exifImageOrientation = CKEXIFImageOrientationRight;			break;	// EXIF: 8
		default:								exifImageOrientation = CKEXIFImageOrientationUp;			break;	// EXIF: 1
	}
	
	return exifImageOrientation;
}
