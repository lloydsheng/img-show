//
//  CKImagePickerController.h
//  CameraKit
//
//  Created by Kai on 10/12/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class CKImagePickerController;
@class CKImageMetadata;

/** `CKImagePickerControllerDelegate` is basically the same as `UIImagePickerControllerDelegate`, except that it adds support for image metadata.
 */
@protocol CKImagePickerControllerDelegate <NSObject>

@optional

/** After a photo is picked, CKImagePickerController tries to retrieve the metadata (including GPS information) and return it if available.
 *  
 *  The picker should be dismissed in the delegate method.
 *  
 * 	@param picker The controller object managing the image picker interface.
 * 	@param info A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. It is exactly the dictionary `UIImagePickerController` provides.
 * 	@param metadata The metadata of the picked image.
 */
- (void)imagePickerController:(CKImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info metadata:(CKImageMetadata *)metadata;

/** User cancels the picker.
 *  
 *  The picker should be dismissed in the delegate method.
 *  
 * 	@param picker The controller object managing the image picker interface.
 */
- (void)imagePickerControllerDidCancel:(CKImagePickerController *)picker;

@end


/** `CKImagePickerController` is basically the same as `UIImagePickerController`, except that it adds support for image metadata and geolocation.
 *  
 *  @warning In order to use `CameraKit`, add the following frameworks in your project: `AssetsLibrary` (weak), `ImageIO` (weak), `MobileCoreServices`, `CoreLocation`.
 */
@interface CKImagePickerController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
	id <CKImagePickerControllerDelegate> pickerDelegate;
	
    BOOL geoLocationEnabled;
	CLLocation *currentLocation;
	CLLocationManager *locationManager;
}

/** This property is the delegate for the `CKImagePickerControllerDelegate` method callbacks.
 *  
 *  @warning You should never set the actual delegate of `CKImagePickerController`, since the actual delegate is set to self to receive callbacks of `UIImagePickerController`.
 */
@property (nonatomic, assign) id <CKImagePickerControllerDelegate> pickerDelegate;

/** Allows locating when takes photo. The result will be embeded in the metadata.
 */
@property (nonatomic, assign) BOOL allowsGeoLocating;

/** The result of locating.
 */
@property (nonatomic, retain) CLLocation *currentLocation;

@end
