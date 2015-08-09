//
//  ZZHTravelNoteViewController.h
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseViewController.h"
@class AppDelegate;
@interface ZZHTravelNoteViewController : ZZHBaseViewController
{
    AppDelegate * _appDelegate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *str;
@end
