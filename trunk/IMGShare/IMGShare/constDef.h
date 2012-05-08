//
//  constDef.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

static NSString* KAppKey = @"4034493657";
static NSString* KAppSecret = @"ab29770cb6645c7be52da24c66e69379";
static NSString* KHotBlogUpdateNotify = @"hotBlogUpdateNotify";

static const int KUserItemHeight=40;
static const int KBlogContentDefaultHeight = 40;
//205*307
static const int KBlogImgDefaultHeight = 307;
static const int KBlogImgDefaultWidth = 205;
static const int KBlogTextWidth = 300;

static const int KBlogItemTag = 10;

static const int KPageViewHeight = 120;

static const int KGridItemWidth = 60;
static const int KGridItemHeight = 60;

static const int kGridItemCountEachRow = 4;

static const int kImageItemGrapHeight = 10;

static NSString* KBlogImgServerUrl = @"http://ww1.sinaimg.cn/";
typedef enum  
{
    EImageThumb,
    EImageMiddle,
    EImageLage
}TImageType;

typedef enum 
{
    kRequestRefresh,
    KRequestNextPage,
    KRequestLast
}TRequestType;

typedef enum
{
    EPopTitleNotMove,
    EPopTitleMove
}TPopTitleStatus;

typedef enum
{
    ETableNotInit,
    ETableNormal,
    ETableRefresh
}TTableOffsetStatus;

typedef enum
{
    EBtCmdComment,
    EBtCmdRt,
    EBtCmdUser
}TBtCmd;