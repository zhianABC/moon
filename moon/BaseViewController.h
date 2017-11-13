//
//  BaseViewController.h
//  hkeeping
//
//  Created by jack on 2/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebClient.h"

@interface BaseViewController : UIViewController {
    
    UIImageView     *_backgroundImageView;
    UIView          *_contentView;
    
    WebClient       *_http;
    
    UIImageView     *_topBar;
    UIImageView     *_bottomBar;
}
@property (nonatomic, readonly) UIView *_contentView;
@property (nonatomic, readonly) UIImageView *_bottomBar;
@property (nonatomic, readonly) UIImageView *_topBar;
- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font; //根据字符串、字体计算长度

@end
