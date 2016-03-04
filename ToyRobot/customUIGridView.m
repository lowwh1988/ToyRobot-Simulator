//
//  customUIGridView..m
//  ToyRobot
//
//  Created by Low Wai Hong on 3/3/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import "customUIGridView.h"

@implementation customUIGridView

@synthesize numberOfColumns;
@synthesize numberOfRows;
@synthesize toyRobot;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGFloat columnWidth = self.frame.size.width / self.numberOfColumns;
    
    for(int i = 1; i < self.numberOfColumns; i++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }

    CGFloat rowHeight = self.frame.size.height / self.numberOfRows;
    
    for(int j = 1; j < self.numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}
@end
