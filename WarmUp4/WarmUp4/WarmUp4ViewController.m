//
//  WarmUp4ViewController.m
//  WarmUp4
//
//  Created by Wenhao Cen on 2/18/13.
//  Copyright (c) 2013 Wenhao Cen. All rights reserved.
//

#import "WarmUp4ViewController.h"
#import "SecondWarmUp4ViewController.h"

@interface WarmUp4ViewController ()
 
@end   

@implementation WarmUp4ViewController
@synthesize user = _user;
- (void)viewDidLoad
{ 
    [super viewDidLoad];
    self.BaseURL = @"https://sheltered-wave-4048.herokuapp.com";
    self.errCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Invalid username and password combination. Please try again.", [NSNumber numberWithInt:ERR_BAD_CREDENTIALS],
                    @"This user name already exists. Please try again.",  [NSNumber numberWithInt:ERR_USER_EXISTS],
                    @"The user name should not be empty and at most 128 characters long. Please try again.",  [NSNumber numberWithInt:ERR_BAD_USERNAME],
                    @"The password should be at most 128 characters long. Please try again.", [NSNumber numberWithInt:ERR_BAD_PASSWORD],
                    nil];
    self.textfieldPassword.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)Login:(id)sender {
    self.user = self.textField.text;
    self.password = self.textfieldPassword.text;
    [self userController:@"/users/login"];
    
}
- (IBAction)AddUser:(id)sender {
    self.user = self.textField.text;
    self.password = self.textfieldPassword.text;
    [self userController:@"/users/add"];
}

//The Generic controller to handle all the request from login and add user. 
- (void) userController:(NSString*)requestPath
{
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.user, @"user",
                              self.password, @"password",
                              nil];
    NSError *error;
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *FullRequestPath = [NSString stringWithFormat:@"%@%@", self.BaseURL, requestPath];
    NSURL *url = [NSURL URLWithString:FullRequestPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonRequest];
    
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *jsonResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
    
    NSDictionary *jsonDictionaryResponse = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    NSNumber *error_code = [jsonDictionaryResponse objectForKey:@"errCode"];
    
    // if there are error while trying to login or add user. 
    if (error_code != [NSNumber numberWithInt:1]) {
        self.messageBox.text = [self.errCodes objectForKey:error_code];
    }
    // SUCCESS, then proceed to second view. 
    else {
        NSNumber *counter = [jsonDictionaryResponse objectForKey:@"count"];
        SecondWarmUp4ViewController *nextView = [[SecondWarmUp4ViewController alloc]initWithNibName:@"SecondWarmUp4ViewController" bundle:nil];
        [self presentViewController:nextView animated:YES completion:NULL];
        
        nextView.messageBox.text = [NSString stringWithFormat:@"Welcome %@ ! \n You have logged in %@ times.", self.user, counter];
    }
    // Reinitialize the text in 'username' and 'password' of First View
    self.textField.text = @"";
    self.textfieldPassword.text = @"";
    self.user = @"";
    self.password = @"";


    
}
@end
