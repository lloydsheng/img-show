//
//  CKViewController.h
//  CameraKitExample
//
//  Created by Cao Kai on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCameraKit.h"

@interface CKViewController : UIViewController <CKImagePickerControllerDelegate>
{
    UITextView*         contentEditor;
    UIImageView*        imageView; 
    
    bool                isPickerShow;
}

- (void)photoAlbumButton;
- (void)cameraButton;

@end
