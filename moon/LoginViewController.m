//
//  LoginViewController.m
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "LoginViewController.h"
#import "NetworkChecker.h"
#import "SvUDIDTools.h"
#import "User.h"
#import "DataCache.h"
#import "SBJson4Parser.h"
#import "UserDefaultsKV.h"

#define T7DaySecs (7*24*3600)


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable)
    {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    }
    else
    {
        _networkStatus.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _welcome = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    _welcome.backgroundColor = [UIColor clearColor];
//    _welcome.font = [UIFont boldSystemFontOfSize:25];
//    _welcome.text = @"欢迎登录CMA iPad智销系统";
//    _welcome.textAlignment = NSTextAlignmentCenter;
//    _welcome.textColor = COLOR_TEXT_B;
//    [self._contentView addSubview:_welcome];
    
    _inputBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_biankuang.png"]];
    [self._contentView addSubview:_inputBg];
    _inputBg.userInteractionEnabled = YES;
    
    if(IOS7_OR_BEFORE)
        _inputBg.center = CGPointMake(SCREEN_HEIGHT/2, SCREEN_WIDTH/2-40);
    else
        _inputBg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);

    
    CGRect rc  = _welcome.frame;
    rc.size.width = CGRectGetWidth(_inputBg.frame);
    rc.origin.x = CGRectGetMinX(_inputBg.frame);
    rc.origin.y = CGRectGetMinY(_inputBg.frame)-50;
    _welcome.frame = rc;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 200, 40)];
    tL.backgroundColor = [UIColor clearColor];
    [_inputBg addSubview:tL];
    tL.text = @"用户登录";
    
    UIImageView *enterBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_shurutiao.png"]];
    [_inputBg addSubview:enterBg];
    enterBg.center = CGPointMake(CGRectGetWidth(_inputBg.frame)/2, 70);
    
    _userName = [[UITextField alloc] initWithFrame:CGRectInset(enterBg.frame, 8, 3)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.returnKeyType = UIReturnKeyNext;
    _userName.placeholder = @"请输入用户名";
    [_inputBg addSubview:_userName];
    
    enterBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denglu_shurutiao.png"]];
    [_inputBg addSubview:enterBg];
    enterBg.center = CGPointMake(CGRectGetWidth(_inputBg.frame)/2, 115);

    
    _userPwd = [[UITextField alloc] initWithFrame:CGRectInset(enterBg.frame, 8, 3)];
    _userPwd.backgroundColor = [UIColor clearColor];
    _userPwd.returnKeyType = UIReturnKeyDone;
    _userPwd.placeholder = @"请输入密码";
    _userPwd.secureTextEntry = YES;
    [_inputBg addSubview:_userPwd];
    
    
    UIButton *btnLogin = [UIButton buttonWithColor:RGB(16, 82, 155) selColor:nil];
    btnLogin.frame = CGRectMake(0, 0, CGRectGetWidth(enterBg.frame), 45);
    btnLogin.layer.cornerRadius = 3;
    btnLogin.clipsToBounds = YES;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_inputBg addSubview:btnLogin];
    btnLogin.center = CGPointMake(CGRectGetWidth(_inputBg.frame)/2, CGRectGetHeight(_inputBg.frame)-50);
    [btnLogin addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
   
    UILabel *_padNo = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_SCREEN_WIDTH-460,
                                                                CGRectGetMinY(_bottomBar.frame)-70,
                                                                460, 30)];
    _padNo.backgroundColor = [UIColor clearColor];
    _padNo.textAlignment = NSTextAlignmentLeft;
     NSString *cms_uuid = [SvUDIDTools UDID];
    _padNo.text = [NSString stringWithFormat:@"设备编号：%@", cms_uuid];
    [self._contentView addSubview:_padNo];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    UILabel *_versonNo = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_SCREEN_WIDTH-460,
                                                                CGRectGetMinY(_bottomBar.frame)-90,
                                                                460, 20)];
    _versonNo.backgroundColor = [UIColor clearColor];
    _versonNo.textAlignment = NSTextAlignmentLeft;
    _versonNo.text = [NSString stringWithFormat:@"版 本 号：%@", version];
    [self._contentView addSubview:_versonNo];
 
    
    _networkStatus = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               CGRectGetMaxY(_inputBg.frame)+10,
                                                               DEFAULT_SCREEN_WIDTH-20, 20)];
    _networkStatus.backgroundColor = [UIColor clearColor];
    _networkStatus.textAlignment = NSTextAlignmentCenter;
    _networkStatus.textColor = RGB(88, 11, 106);
    [self._contentView addSubview:_networkStatus];
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable)
    {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    }
   else
   {
       _networkStatus.hidden = YES;
   }
    _userName.delegate = self;
    _userPwd.delegate = self;
    
    //测试
    //_userName.text = @"A8888801";
    //_userPwd.text = @"123456";
    
    self._bottomBar.hidden = YES;
    
    cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouye.png"]];
    [self.view addSubview:cover];
    
    //self._contentView.alpha = 0.0;
    self._contentView.transform  = CGAffineTransformMakeScale(0.5, 0.5);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyNetworkStatusChanged:)
                                                 name:Notify_Network_Status_Changed
                                               object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(enter) userInfo:nil repeats:NO];
    
    
    
    
   
}

- (void) notifyNetworkStatusChanged:(NSNotification*)notify{
    
    NSDictionary *userinfo = [notify userInfo];
    BOOL network = [[userinfo objectForKey:@"status"] boolValue];
    if(!network)
    {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    }
    else
    {
        _networkStatus.hidden = YES;
    }
}


- (void) enter{
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         cover.transform = CGAffineTransformMakeScale(2.0, 2.0);
                         cover.alpha = 0.0;
                         
                         self._contentView.transform = CGAffineTransformIdentity;
                         
                     } completion:^(BOOL finished) {
                        
                         [cover removeFromSuperview];
                     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(IOS7_OR_BEFORE)
        _inputBg.center = CGPointMake(SCREEN_HEIGHT/2, SCREEN_WIDTH/2-220);
    else
        _inputBg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-220);
    

    
    _networkStatus.frame = CGRectMake(10,
               CGRectGetMaxY(_inputBg.frame)+10,
               DEFAULT_SCREEN_WIDTH-20, 20);
    
//    CGRect rc  = _welcome.frame;
//    rc.size.width = CGRectGetWidth(_inputBg.frame);
//    rc.origin.x = CGRectGetMinX(_inputBg.frame);
//    rc.origin.y = CGRectGetMinY(_inputBg.frame)-50;
//    _welcome.frame = rc;

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(IOS7_OR_BEFORE)
        _inputBg.center = CGPointMake(SCREEN_HEIGHT/2, SCREEN_WIDTH/2-60);
    else
        _inputBg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60);
    

    
    _networkStatus.frame = CGRectMake(10,
               CGRectGetMaxY(_inputBg.frame)+10,
               DEFAULT_SCREEN_WIDTH-20, 20);
    
//    CGRect rc  = _welcome.frame;
//    rc.size.width = CGRectGetWidth(_inputBg.frame);
//    rc.origin.x = CGRectGetMinX(_inputBg.frame);
//    rc.origin.y = CGRectGetMinY(_inputBg.frame)-50;
//    _welcome.frame = rc;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == _userName)
    {
        [_userPwd becomeFirstResponder];
    }
    
    return YES;
}

- (void) loginAction:(UIButton*)btn{
    
    if([_userName.text length] < 1)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入登录名！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([_userPwd.text length] < 1)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入密码！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable)
    {
        //没有网络的情况下
        User *u = [[DataCache sharedDataCacheDatabaseInstance] queryUser:_userName.text];//[UserDefaultsKV getUser];
        if(u)
        {
            long long times = [u._lastLoginDate longLongValue];
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:times];
            NSDate *today = [NSDate date];
            int timeSpan = [today timeIntervalSinceDate:d];
            if(timeSpan < T7DaySecs)
            {
                if([u._userName isEqualToString:_userName.text]
                   && [u._password isEqualToString:_userPwd.text])
                {
                    [self didLogin];
                }
                else
                {
                    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"您输入的密码错误！"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:@"您已经超过7天未登录此iPad，请联网并登录！"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"未查询到此用户在此iPad上的登录记录！"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
            [alert show];
        }
        //返回
        return;
    }
    
   
    if([_userName isFirstResponder])
        [_userName resignFirstResponder];
    
    if([_userPwd isFirstResponder])
        [_userPwd resignFirstResponder];
    
    if(_http == nil)
        _http = [[WebClient alloc] initWithDelegate:self];
    
    _http._method = API_LOGIN;
    _http._requestParam = [NSDictionary dictionaryWithObjectsAndKeys:
                           _userName.text, @"username",
                           _userPwd.text,@"password",
                           nil];
    _http._httpMethod = @"GET";
    
    IMP_BLOCK_SELF(LoginViewController);
    
    btn.enabled = NO;
    
    [_http requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        btn.enabled = YES;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                
                NSString *status = [v objectForKey:@"code"];
                //NSString *key = [v objectForKey:@"key"];
                if([status intValue] == 0xEEEE )//
                {
                    [block_self enterAdminMode];
                    return;
                }
                
                if([status intValue] == 0)
                {
                    User *u = [[User alloc] initWithDicionary:v];
                    u._userName = _userName.text;
                    u._password = _userPwd.text;
                    u._lastLoginDate = [NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970]];
                    [UserDefaultsKV saveUser:u];
                    
                    [[DataCache sharedDataCacheDatabaseInstance] saveUserData:u];
                    
                    [block_self didLogin];
                    
                }
                else
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败！"
                                                                    message:@"用户名或密码错误！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
                return;
            }
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            NSLog(@"OOPS: %@", err);
            
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        btn.enabled = YES;
    }];

    
    
}

- (void) didLogin{
    
//    VideoGalleryViewController *videoGallery = [[VideoGalleryViewController alloc] init];
//    [self.navigationController pushViewController:videoGallery animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
