//
//  CKImageMetadata.h
//  CameraKit
//
//  Created by Kai on 11/16/11.
//  Copyright (c) 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

enum
{
	CKEXIFImageOrientationUp					= 1,
	CKEXIFImageOrientationUpMirrored			= 2,
	CKEXIFImageOrientationDown					= 3,
	CKEXIFImageOrientationDownMirrored			= 4,
	CKEXIFImageOrientationLeftMirrored			= 5,
	CKEXIFImageOrientationLeft					= 6,
	CKEXIFImageOrientationRightMirrored			= 7,
	CKEXIFImageOrientationRight					= 8,
};
typedef NSUInteger CKEXIFImageOrientation;

/** `CKImageMetadata` is an image metadata wrapper. It supports some basic metadata operations, such as setting the location and changing the image orientation.
 */
@interface CKImageMetadata : NSObject
{
	NSMutableDictionary *metadata;
}

/** The initializer of the metadata.
 *  
 *  @param metadata The metadata dictionary to be wrapped up in.
 *  
 *  @returns An initialized image metadata object.
 */
- (id)initWithMetadata:(NSDictionary *)metadata;

/** Sets the location of the metadata.
 *  
 *  @param location The location to be wrapped up in the metadata.
 */
- (void)setLocation:(CLLocation *)location;

/** Sets the image orientation of the metadata.
 *  
 *  @param orientation The image orientation to be wrapped up in the metadata.
 */
- (void)setImageOrientation:(CKEXIFImageOrientation)orientation;

/** Creates a new metadata wrapper and change the image orientation to a specific orientation.
 *  
 *  @param orientation The new orientation of the metadata.
 *  
 *  @returns A newly created metadata wrapper with the new image orientation.
 */
- (CKImageMetadata *)metadataByReplacingImageOrientation:(CKEXIFImageOrientation)orientation;

/** The metadata dictionary.
 *  
 *  @returns The metadata dictionary.
 */
- (NSDictionary *)EXIFRepresentation;

@end

/** Converts a `UIImage` orientation to the corresponding orientation in EXIF.
 * 	
 * 	@param imageOrientation The orientation of a `UIImage`.
 *  
 * 	@returns The corresponding orientation in EXIF.
 */
extern CKEXIFImageOrientation CKEXIFImageOrientationFromUIImageOrientation(UIImageOrientation imageOrientation);
