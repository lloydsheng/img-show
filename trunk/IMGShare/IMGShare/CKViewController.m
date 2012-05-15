//
//  CKViewController.m
//  CameraKitExample
//
//  Created by Cao Kai on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CKViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+EXIF.h"

@interface CKViewController ()

@end

@implementation CKViewController

#pragma mark - View Life Cycle

- (id) init
{
    [super init];
    isPickerShow = NO;
    return self;
}

- (void)viewDidLoad
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (!isPickerShow ) 
    {
        [self cameraButton];
    }
}

- (void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    contentEditor = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
    contentEditor.editable = YES;
    [self.view addSubview:contentEditor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 300, 300)];
    [imageView setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:imageView];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (void)photoAlbumButton
{
    CKImagePickerController *imagePickerController = [[CKImagePickerController alloc] init];
    imagePickerController.pickerDelegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)cameraButton
{
    CKImagePickerController *imagePickerController = [[CKImagePickerController alloc] init];
    imagePickerController.pickerDelegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    imagePickerController.allowsGeoLocating = YES;
    [self presentModalViewController:imagePickerController animated:NO];
    
    isPickerShow = YES;
}

#pragma mark - CKImagePickerController Delegate Methods

- (void)imagePickerController:(CKImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info metadata:(CKImageMetadata *)metadata
{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        CKImageWriteToSavedPhotosAlbum(originalImage, metadata);
    }
    
    NSData *data = [originalImage imageDataWithCompressionQuality:0.5 metadata:metadata];
    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.jpg"];
    [data writeToFile:file atomically:YES];
    
    imageView.image = originalImage;
    
    NSLog(@"Photo stored in: %@", NSTemporaryDirectory());
    
    isPickerShow = NO;
}

- (void)imagePickerControllerDidCancel:(CKImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    isPickerShow = NO;
}

@end
