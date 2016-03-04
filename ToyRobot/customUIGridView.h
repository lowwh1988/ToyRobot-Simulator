//
//  customUIGridView.h
//  ToyRobot
//
//  Created by Low Wai Hong on 3/3/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customUIGridView : UIView
{
    UIView *toyRobot;
}
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int numberOfRows;
@property (nonatomic) UIView *toyRobot;

@end
