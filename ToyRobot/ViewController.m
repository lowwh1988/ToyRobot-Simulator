//
//  ViewController.m
//  ToyRobot
//
//  Created by Low Wai Hong on 3/3/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import "ViewController.h"

#define faceNorthDirection @"NORTH"
#define faceWestDirection @"WEST"
#define faceSouthDirection @"SOUTH"
#define faceEastDirection @"EAST"
#define faceDirection @"faceDirection"

#define maximumColumn 5
#define maximumRow 5

#define rotateLeft @"LEFT"
#define rotateRight @"RIGHT"
#define moveForward @"MOVE"
#define placeTheToyRobot @"PLACE"
#define reportToyRobot @"REPORT"

#define xPosition @"xPosition"
#define yPosition @"yPosition"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()
{
    NSMutableDictionary *toyRobot;
    NSArray *directionArray;
}
@end

@implementation ViewController

@synthesize xValueTextField;
@synthesize yValueTextField;
@synthesize faceDirectionTextField;
@synthesize textfieldBlockerButton;
@synthesize gridView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [textfieldBlockerButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8]];
    [textfieldBlockerButton addTarget:self action:@selector(textFieldBlockerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    directionArray = [[NSArray alloc] initWithObjects:faceNorthDirection,faceWestDirection,faceSouthDirection,faceEastDirection, nil];
    
    gridView.numberOfRows = 5;
    gridView.numberOfColumns = 5;
    [gridView setNeedsDisplay];
}

#pragma mark - ToyRobot Command
- (IBAction)placeCommand
{
    BOOL isValidCommand = true;
    
    if([xValueTextField.text intValue]>=maximumColumn)
    {
        isValidCommand = false;
    }
    else if([yValueTextField.text intValue]>=maximumRow)
    {
        isValidCommand = false;
    }
    else
    {
        BOOL foundMatchingDirection = NO;
        
        for(int i=0; i<[directionArray count]; i++)
        {
            if([[faceDirectionTextField.text uppercaseString] isEqualToString:[directionArray objectAtIndex:i]])
            {
                foundMatchingDirection = YES;
                break;
            }
        }
        
        if(!foundMatchingDirection)
        {
            isValidCommand = false;
        }
    }
    
    if(isValidCommand)
    {
        if(toyRobot == nil)
        {
            toyRobot = [[NSMutableDictionary alloc] init];
            gridView.toyRobot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            [gridView.toyRobot setBackgroundColor:[UIColor redColor]];
            UIBezierPath* trianglePath = [UIBezierPath bezierPath];
            [trianglePath moveToPoint:CGPointMake(0, gridView.toyRobot.frame.size.height)];
            [trianglePath addLineToPoint:CGPointMake(gridView.toyRobot.frame.size.width/2,0)];
            [trianglePath addLineToPoint:CGPointMake(gridView.toyRobot.frame.size.width, gridView.toyRobot.frame.size.height)];
            [trianglePath closePath];
            
            CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
            [triangleMaskLayer setPath:trianglePath.CGPath];
            
            gridView.toyRobot.layer.mask = triangleMaskLayer;
            
            [gridView addSubview:gridView.toyRobot];
        }
        
        [toyRobot setObject:[NSNumber numberWithInt:[xValueTextField.text intValue]] forKey:xPosition];
        [toyRobot setObject:[NSNumber numberWithInt:[yValueTextField.text intValue]] forKey:yPosition];
        [toyRobot setObject:[faceDirectionTextField.text uppercaseString] forKey:faceDirection];
        
        [gridView.toyRobot setFrame:CGRectMake([xValueTextField.text intValue]*60, [self mapYValue:[yValueTextField.text intValue]]*60, 60, 60)];
        [gridView.toyRobot setTransform:[self rotateToyRobotWithFaceDirection:[faceDirectionTextField.text uppercaseString]]];
    }
    else
    {
        [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
    }
    
    [xValueTextField setText:@""];
    [yValueTextField setText:@""];
    [faceDirectionTextField setText:@""];
}

- (IBAction)moveCommand
{
    if(toyRobot!=nil)
    {
        BOOL isValidCommand = true;
        
        int moveXByValue = 0;
        int moveYByValue = 0;
        
        if([[toyRobot objectForKey:faceDirection] isEqualToString:faceNorthDirection])
        {
            moveXByValue = 0;
            moveYByValue = 1;
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceWestDirection])
        {
            moveXByValue = -1;
            moveYByValue = 0;
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceSouthDirection])
        {
            moveXByValue = 0;
            moveYByValue = -1;
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceEastDirection])
        {
            moveXByValue = 1;
            moveYByValue = 0;
        }
        
        if([[toyRobot objectForKey:xPosition] intValue]+moveXByValue>=maximumColumn || [[toyRobot objectForKey:xPosition] intValue]+moveXByValue<0)
        {
            isValidCommand = false;
        }
        else if([[toyRobot objectForKey:yPosition] intValue]+moveYByValue>=maximumRow || [[toyRobot objectForKey:yPosition] intValue]+moveYByValue<0)
        {
            isValidCommand = false;
        }
        
        if(isValidCommand)
        {
            [toyRobot setObject:[NSNumber numberWithInt:[[toyRobot objectForKey:xPosition] intValue]+moveXByValue] forKey:xPosition];
            [toyRobot setObject:[NSNumber numberWithInt:[[toyRobot objectForKey:yPosition] intValue]+moveYByValue] forKey:yPosition];
            
            [gridView.toyRobot setFrame:CGRectMake([[toyRobot objectForKey:xPosition] intValue]*60, [self mapYValue:[[toyRobot objectForKey:yPosition] intValue]]*60, 60, 60)];
        }
        else
        {
            [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
        }
    }
    else
    {
        [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
    }
}

- (IBAction)rotateLeftCommand
{
    if(toyRobot!=nil)
    {
        if([[toyRobot objectForKey:faceDirection] isEqualToString:faceNorthDirection])
        {
            [toyRobot setObject:faceWestDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceWestDirection])
        {
            [toyRobot setObject:faceSouthDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceSouthDirection])
        {
            [toyRobot setObject:faceEastDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceEastDirection])
        {
            [toyRobot setObject:faceNorthDirection forKey:faceDirection];
        }
        
        [gridView.toyRobot setTransform:[self rotateToyRobotWithFaceDirection:[toyRobot objectForKey:faceDirection]]];
    }
    else
    {
        [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
    }
}

- (IBAction)rotateRightCommand
{
    if(toyRobot!=nil)
    {
        if([[toyRobot objectForKey:faceDirection] isEqualToString:faceNorthDirection])
        {
            [toyRobot setObject:faceEastDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceWestDirection])
        {
            [toyRobot setObject:faceNorthDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceSouthDirection])
        {
            [toyRobot setObject:faceWestDirection forKey:faceDirection];
        }
        else if([[toyRobot objectForKey:faceDirection] isEqualToString:faceEastDirection])
        {
            [toyRobot setObject:faceSouthDirection forKey:faceDirection];
        }
        
        [gridView.toyRobot setTransform:[self rotateToyRobotWithFaceDirection:[toyRobot objectForKey:faceDirection]]];
    }
    else
    {
        [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
    }
}

- (IBAction)reportCommand
{
    if(toyRobot!=nil)
    {
        [self showMessageWithTitle:[NSString stringWithFormat:@"%d,%d %@",[[toyRobot objectForKey:xPosition] intValue],[[toyRobot objectForKey:yPosition] intValue],[toyRobot objectForKey:faceDirection]]  andMessage:@"" andCancelButton:@"OK"];
    }
    else
    {
        [self showMessageWithTitle:@"Invalid Command" andMessage:@"" andCancelButton:@"OK"];
    }
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textfieldBlockerButton setHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [faceDirectionTextField resignFirstResponder];
    [textfieldBlockerButton setHidden:YES];
    
    return NO;
}

#pragma mark - Helper methods
- (void)textFieldBlockerButtonPressed
{
    [textfieldBlockerButton setHidden:YES];
    [xValueTextField resignFirstResponder];
    [yValueTextField resignFirstResponder];
    [faceDirectionTextField resignFirstResponder];
}

- (int)mapYValue:(int)yValue
{
    int y = 4;
    if(yValue==1)
    {
        y = 3;
    }
    else if(yValue==2)
    {
        y = 2;
    }
    else if(yValue==3)
    {
        y = 1;
    }
    else if(yValue==4)
    {
        y = 0;
    }
    return y;
}

- (CGAffineTransform)rotateToyRobotWithFaceDirection:(NSString *)fDirection
{
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(0));

    if([fDirection isEqualToString:faceWestDirection])
    {
        transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(270));
    }
    else if([fDirection isEqualToString:faceSouthDirection])
    {
        transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(180));
    }
    else if([fDirection isEqualToString:faceEastDirection])
    {
        transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(90));
    }
    
    return transform;
}
-(void)showMessageWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButton:(NSString *)cancel
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
