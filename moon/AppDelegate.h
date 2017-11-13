//
//  AppDelegate.h
//  moon
//
//  Created by chen jack on 2017/10/30.
//  Copyright © 2017年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *_naviRoot;
}

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)shareAppDelegate;

@end

