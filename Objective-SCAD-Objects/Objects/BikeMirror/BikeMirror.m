//
//  BikeMirror.m
//  Objective-SCAD-Objects
//
//  Created by Jeffrey Camealy on 5/12/14.
//  Copyright (c) 2014 bearMountain. All rights reserved.
//

#import "BikeMirror.h"
#import "ObjectiveSCADHeaders.h"

// Main Arm
const float ARM_LENGTH = 90.0;
const float ARM_WIDTH = 5.0;
const float ARM_HEIGHT = 4.0;

// Ball Joint
const float BALL_JOINT_DIAMETER = 9.5;

// Arm Head
const float SOCKET_WALL_THICKNESS = 2.0;
const float SOCKET_DIAMETER = BALL_JOINT_DIAMETER+SOCKET_WALL_THICKNESS;
const float SOCKET_HEIGHT = SOCKET_DIAMETER;

@implementation BikeMirror

- (void)buildSubObjects {
    OSCube *arm = [[OSCube alloc] initWithSizeVector:v(ARM_LENGTH, ARM_WIDTH, ARM_HEIGHT)];
    [arm addTransformation:translate(0, 0, -ARM_HEIGHT/2)];
    
    OSCylinder *socket = [[OSCylinder alloc] initWithDiameter:SOCKET_DIAMETER height:SOCKET_HEIGHT];
    [socket addTransformation:translate(ARM_LENGTH/2, 0, -SOCKET_HEIGHT/2)];
    
    OSSphere *ball = [[OSSphere alloc] initWithDiameter:BALL_JOINT_DIAMETER];
    [ball addTransformation:[OSColorTransformation transformationWithColor:color(1, 0, 0, 1)]];
    
    [self.subObjects addObject:arm];
    [self.subObjects addObject:socket];
    [self.subObjects addObject:ball];
}

@end
