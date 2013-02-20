//
//  SecondViewController.h
//  LoginCounter
//
//  Created by Denny Winoto on 2/18/13.
//  Copyright (c) 2013 Denny Winoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *messageText_2;

- (IBAction)logoutButtonTapped:(id)sender;

@end
