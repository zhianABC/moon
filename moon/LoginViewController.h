//
//  LoginViewController.h
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "BaseViewController.h"


@interface LoginViewController : BaseViewController <UITextFieldDelegate>
{
    UIImageView *_inputBg;
    
    UITextField *_userName;
    UITextField *_userPwd;
    
    UILabel *_welcome;
    
    UIImageView *cover;
    
    UILabel *_networkStatus;
}
@end
