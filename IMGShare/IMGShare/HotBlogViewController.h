//
//  ViewController.h
//  SingleShare
//
//  Created by zhiyuan on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "UserCtrl.h"
#import "constDef.h"

@interface HotBlogViewController : UITableViewController<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource >
{
    EGORefreshTableHeaderView*  refreshView;
    
    bool                        reloading;
    
    UserCtrl*                   curPopUser;
    
    UserCtrl*                   oldPopUser;

    TPopTitleStatus             popUserStatus;
    
    int                         currentItemIndex;
    
    int                         lastOffsetY;
    
    TTableOffsetStatus          offsetStatus;
}

@end
