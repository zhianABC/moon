//
//  BaseViewController.m
//  hkeeping
//
//  Created by jack on 2/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize _contentView;
@synthesize _bottomBar;
@synthesize _topBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (BOOL)prefersStatusBarHidden
{
    
    return NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    if(IOS7_OR_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:_backgroundImageView];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    //_contentView.clipsToBounds = NO;
    _http = [[WebClient alloc] initWithDelegate:self];
    _http._httpMethod = @"GET";
    
}

- (void) dealloc {
    _http._successBlock = nil;
    _http._failBlock = nil;
    
}

- (BOOL)shouldAutorotate{
    
    return YES;
    
}
- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font //根据字符串、字体计算长度
{
    CGSize constraint = CGSizeMake(1000.0f, 20000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@
                                          {
                                          NSFontAttributeName:font
                                          }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
    
}

@end
