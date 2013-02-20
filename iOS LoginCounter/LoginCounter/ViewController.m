//
//  ViewController.m
//  LoginCounter
//
//  Created by Denny Winoto on 2/18/13.
//  Copyright (c) 2013 Denny Winoto. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initializations
    self.errCode = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Invalid username and password combination. Please try again.", [NSNumber numberWithInt:ERR_BAD_CREDENTIALS],
                    @"This user name already exists. Please try again.",  [NSNumber numberWithInt:ERR_USER_EXISTS],
                    @"The user name should not be empty and at most 128 characters long. Please try again.",  [NSNumber numberWithInt:ERR_BAD_USERNAME],
                    @"The password should be at most 128 characters long. Please try again.", [NSNumber numberWithInt:ERR_BAD_PASSWORD],
                    nil];
    
    self.username = @"";
    self.password = @"";
    
    self.urlString = [NSString stringWithFormat:@"http://enigmatic-taiga-6580.herokuapp.com"];
    //self.urlString = [NSString stringWithFormat:@"http://192.168.1.107:8000"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method will change the username's atrribute with the text entered to Username's Field
- (IBAction)usernameTextEntered:(id)sender
{
    self.username = self.usernameField.text;
    //NSLog(@"Username: %@", self.username);
}

// This method will change the username's atrribute with the text entered to Password's Field
- (IBAction)passwordTextEntered:(id)sender
{
    self.password = self.passwordField.text;
    //NSLog(@"Password: %@", self.passwordField.text);
}

/*
 *  This method will call HTTPResponseAndRequest() method to send and receive data to server and
 *  display appropriate output by calling loginAndAddAction() method when the 'Login' button is tapped.
 */
- (IBAction)loginButtonTapped:(id)sender
{
    NSDictionary *response = [self HTTPResponseAndRequest:@"/users/login"];
    NSLog(@"jsonResponse: %@", response);
    
    [self loginAndAddAction:response];
}

/*
*  This method will call HTTPResponseAndRequest() method to send and receive data to server and
*  display appropriate output by calling loginAndAddAction() method when the 'Add User' button is tapped.
*/
- (IBAction)addUserButtonTapped:(id)sender
{
    NSDictionary *response = [self HTTPResponseAndRequest:@"/users/add"];
    NSLog(@"jsonResponse: %@", response);
    
    [self loginAndAddAction:response];
}


/* 
*  This method will serialize 'username' and password' attribute to JSON and create a HTTP connection with
*  server with content-type 'application/json' and will receive response in JSON which will then 
*  be deserialized to NSDictionary() for further processing.
*/
- (NSDictionary*)HTTPResponseAndRequest:(NSString*)url_addition
{
    NSLog(@"Username: %@", self.username);
    NSLog(@"Password: %@", self.password);
    
    // Creating JSON Object
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.username, @"user",
                              self.password, @"password",
                              nil];
    NSError *error;
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"jsonRequest: %@", [[NSString alloc] initWithData:jsonRequest encoding:NSUTF8StringEncoding]);
    
    // Making final URL by concatenating 'url_addition' to server's URL stored in 'urlString'
    NSString *final_urlString = [NSString stringWithFormat:@"%@%@", self.urlString, url_addition];
    NSLog(@"\n%@ URL: %@", url_addition, final_urlString);
    
    // Constructing HTTP Header and Body, and acquiring request and response
    NSURL *url = [NSURL URLWithString:final_urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonRequest];
    
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *jsonResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
    
    // Converting JSON Object to NSDictionary
    NSDictionary *jsonDictionaryResponse = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    return jsonDictionaryResponse;
}

/*
*  This method will receive response of type NSDictionary which will contain the keys:
*    1) 'errCode'
*    2) (optional) 'count'
*
*  If the value in 'errCode' key is in 'self.errCode' dictionary,
*   set self.message.text to its value in First View
*  Else,
*   create Second View and display the Welcome message
*
*  It will also reinitialize the text in 'username' and 'password of First View
*/
- (void)loginAndAddAction:(NSDictionary*)response
{
    // Getting the 'errCode' value from 'response' dictionary
    NSNumber *error_code = [response objectForKey:@"errCode"];
    NSLog(@"Error Code: %@", error_code);
    
    NSString *message = [self.errCode objectForKey:error_code];
    
    // if there is a value exists in 'self.errCode' dictionary, print the message in First View
    if (message != nil) {
        self.messageText.text = message;
    }
    // else, create a Second View and display the Welcome message
    else {
        self.count = [response objectForKey:@"count"];
        NSLog(@"Count: %@", self.count);
        
        SecondViewController *SVC = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
        [self presentViewController:SVC animated:YES completion:NULL];
        
        SVC.messageText_2.text = [NSString stringWithFormat:@"Welcome %@ ! \n You have logged in %@ times.", self.username, self.count];
    }
    // Reinitialize the text in 'username' and 'password' of First View
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.username = @"";
    self.password = @"";
}

@end
