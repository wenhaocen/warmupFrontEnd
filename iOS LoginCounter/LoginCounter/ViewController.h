//
//  ViewController.h
//  LoginCounter
//
//  Created by Denny Winoto on 2/18/13.
//  Copyright (c) 2013 Denny Winoto. All rights reserved.
//

#import <UIKit/UIKit.h>


// ERROR CODE CONSTANTS
static const int SUCCESS = 1;
static const int ERR_BAD_CREDENTIALS = -1;
static const int ERR_USER_EXISTS = -2;
static const int ERR_BAD_USERNAME = -3;
static const int ERR_BAD_PASSWORD = -4;


@interface ViewController : UIViewController


@property (nonatomic, strong) NSDictionary *errCode; // ERROR CODE Dictionary
@property (nonatomic, strong) NSString *urlString; // Server URL

// User attributes
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *count;

// First View Fields
@property (nonatomic, strong) IBOutlet UITextView *messageText;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (IBAction)usernameTextEntered:(id)sender;
- (IBAction)passwordTextEntered:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)addUserButtonTapped:(id)sender;

- (NSDictionary*)HTTPResponseAndRequest:(NSString*)url_addition;
- (void)loginAndAddAction:(NSDictionary*)response;

@end
