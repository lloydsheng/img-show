//
//  UtilsModel.m
//  SingleShare
//
//  Created by zhiyuan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UtilsModel.h"

@implementation UtilsModel

+ (NSString*) GetFullBlogUrlStr:(NSString*) blogPicID withImgType:(TImageType) imgType
{
    NSString* retUrl = nil;
    if (blogPicID) {
        
        switch (imgType) {
            case EImageLage:
                retUrl = [NSString stringWithFormat:@"%@%@%@", KBlogImgServerUrl, @"large/", blogPicID]; 
                break;
            case EImageMiddle:
                retUrl = [NSString stringWithFormat:@"%@%@%@", KBlogImgServerUrl, @"bmiddle/", blogPicID]; 
                break;
            case EImageThumb:
                retUrl = [NSString stringWithFormat:@"%@%@%@", KBlogImgServerUrl, @"thumbnail/", blogPicID]; 
                break;
                
            default:
                break;
        }
    }
    return retUrl;
}

@end
