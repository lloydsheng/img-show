//
//  CKImagePickerController.m
//  CameraKit
//
//  Created by Kai on 10/12/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import "CKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+EXIF.h"
#import "CKImageMetadata.h"

@interface CKImagePickerController ()

- (void)notifyDelegateWithInfo:(NSDictionary *)info metadata:(CKImageMetadata *)metadata;

@end


@implementation CKImagePickerController

@synthesize allowsGeoLocating;
@synthesize currentLocation;
@synthesize pickerDelegate;

#pragma mark - Initialization & Deallocation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        // Custom initialization
		
		self.delegate = self;
    }
	
    return self;
}

- (void)dealloc
{
	pickerDelegate = nil;
	self.delegate = nil;
	
	[locationManager setDelegate:nil];
	[locationManager stopUpdatingLocation];
	[locationManager release], locationManager = nil;
	
	[currentLocation release], currentLocation = nil;
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (allowsGeoLocating && self.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		if (locationManager == nil)
		{
			locationManager = [[CLLocationManager alloc] init];
			[locationManager setDelegate:self];
			[locationManager setDistanceFilter:1];
			[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
			
			[locationManager startUpdatingLocation];
		}
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocation Manager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	// Test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0)
	{
		return;
	}
    
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0)
	{
		return;
	}
	
	self.currentLocation = newLocation;
    
    // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
    [manager stopUpdatingLocation];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || 
		picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
	{
		// Photo library.
		
		Class ALAssetsLibraryClass = NSClassFromString(@"ALAssetsLibrary");
		if (ALAssetsLibraryClass && 
			[ALAssetsLibraryClass instancesRespondToSelector:@selector(assetForURL:resultBlock:failureBlock:)] && 
			&UIImagePickerControllerReferenceURL != nil)
		{
			NSURL *referenceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
			if (referenceURL)
			{
				ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset)
                {
					CKImageMetadata *metadata = [[[CKImageMetadata alloc] initWithMetadata:[[asset defaultRepresentation] metadata]] autorelease];
					[self notifyDelegateWithInfo:info metadata:metadata];
				};
				
				ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
                {
					[self notifyDelegateWithInfo:info metadata:nil];
				};
				
				ALAssetsLibrary *assetsLibrary = [[[ALAssetsLibrary alloc] init] autorelease];
				[assetsLibrary assetForURL:referenceURL resultBlock:resultBlock failureBlock:failureBlock];
			}
			else
			{
				[self notifyDelegateWithInfo:info metadata:nil];
			}
		}
		else
		{
			[self notifyDelegateWithInfo:info metadata:nil];
		}
	}
	else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		// Camera.
		
		CKImageMetadata *metadata = nil;
		if (&UIImagePickerControllerMediaMetadata != nil)
		{
			metadata = [[CKImageMetadata alloc] initWithMetadata:[info objectForKey:UIImagePickerControllerMediaMetadata]];
			[metadata setLocation:currentLocation];
		}
		
		[self notifyDelegateWithInfo:info metadata:[metadata autorelease]];
	}
	else
	{
		[self notifyDelegateWithInfo:info metadata:nil];
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	if (pickerDelegate && [pickerDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
	{
		[pickerDelegate imagePickerControllerDidCancel:self];
	}
}

- (void)notifyDelegateWithInfo:(NSDictionary *)info metadata:(CKImageMetadata *)metadata
{
	if (pickerDelegate && [pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:metadata:)])
	{
		[pickerDelegate imagePickerController:self didFinishPickingMediaWithInfo:info metadata:metadata];
	}
}

@end
