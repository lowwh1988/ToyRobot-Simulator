//
//  ViewController.h
//  ToyRobot
//
//  Created by Low Wai Hong on 3/3/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *xValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *yValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *faceDirectionTextField;
@property (nonatomic, retain) IBOutlet UIButton *textfieldBlockerButton;

- (IBAction)rotateLeftCommand;
- (IBAction)rotateRightCommand;
- (IBAction)moveCommand;
- (IBAction)placeCommand;
- (IBAction)reportCommand;
@end

