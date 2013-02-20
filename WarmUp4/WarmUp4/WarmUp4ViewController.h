//
//  WarmUp4ViewController.h
//  WarmUp4
//
//  Created by Wenhao Cen on 2/18/13.
//  Copyright (c) 2013 Wenhao Cen. All rights reserved.
//

#import <UIKit/UIKit.h>
static const int SUCCESS = 1;
static const int ERR_BAD_CREDENTIALS = -1;
static const int ERR_USER_EXISTS = -2;
static const int ERR_BAD_USERNAME = -3;
static const int ERR_BAD_PASSWORD = -4;

@interface WarmUp4ViewController : UIViewController
//text field for user name;
@property (retain, nonatomic) IBOutlet UITextField *textField;
//message box
@property (strong, nonatomic) IBOutlet UITextView *messageBox;
//user name label
@property (retain, nonatomic) IBOutlet UILabel *labeluserName;
//text field for password
@property (retain, nonatomic) IBOutlet UITextField *textfieldPassword;
//property of a view. easier for us to invoke
@property (copy, nonatomic) NSString *user;
//property of a view. easier for us to invoke
@property (copy, nonatomic) NSString *password;
//a dictionary contains all the message. used when we get response from server
@property (nonatomic, strong) NSDictionary *errCodes;
//label for password
@property (retain, nonatomic) IBOutlet UILabel *label;
//the base url for our server. In this case, should be ****herokuapp.com
@property (nonatomic, strong) NSString *BaseURL;
//Login action
- (IBAction)Login:(id)sender;
//Add User action
- (IBAction)AddUser:(id)sender; 

@end
