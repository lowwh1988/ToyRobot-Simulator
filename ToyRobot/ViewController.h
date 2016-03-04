//
//  ViewController.h
//  ToyRobot
//
//  Created by Low Wai Hong on 3/3/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customUIGridView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *xValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *yValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *faceDirectionTextField;
@property (nonatomic, retain) IBOutlet UIButton *textfieldBlockerButton;
@property (nonatomic,retain)IBOutlet customUIGridView *gridView;

- (IBAction)rotateLeftCommand;
- (IBAction)rotateRightCommand;
- (IBAction)moveCommand;
- (IBAction)placeCommand;
- (IBAction)reportCommand;
@end

