//
//  UIImage+EXIF.h
//  CameraKit
//
//  Created by Kai on 10/11/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class CKImageMetadata;

@interface UIImage (EXIF)

/** Converts `UIImage` to a JPEG compressed `NSData` with metadata.
 * 	
 * 	@param compressionQuality The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0.
 * 	@param metadata The metadata of the original image.
 *  
 * 	@returns The resulting image data.
 */
- (NSData *)imageDataWithCompressionQuality:(CGFloat)compressionQuality metadata:(CKImageMetadata *)metadata;

/** Converts `UIImage` to a PNG uncompressed `NSData` with metadata.
 *  
 *  @param metadata The metadata of the original image.
 *  
 *  @returns The resulting image data.
 */
- (NSData *)imageDataWithMetadata:(CKImageMetadata *)metadata;

/** Embeds metadata (EXIF) in image data.
 * 	
 * 	@param imageData The original image data.
 * 	@param properties The metadata of the original image.
 *  
 * 	@returns The resulting image data.
 */
+ (NSData *)taggedImageDataWithImageData:(NSData *)imageData properties:(NSDictionary *)properties;

@end

/** Adds a photo to the saved photos album.
 * 	
 * 	@param image The image being saved to the camera roll.
 * 	@param metadata The metadata of the image.
 */
extern void CKImageWriteToSavedPhotosAlbum(UIImage *image, CKImageMetadata *metadata);
