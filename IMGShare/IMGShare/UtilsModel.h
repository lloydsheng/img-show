//
//  UtilsModel.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constDef.h"
@interface UtilsModel : NSObject

//应该定义在BlogDataItem里
+ (NSString*) GetFullBlogUrlStr:(NSString*) blogPicID withImgType:(TImageType) imgType;
@end
