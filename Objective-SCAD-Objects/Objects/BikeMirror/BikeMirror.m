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
const float SOCKET_BALL_UNDERSIZED_OFFSET_FACTOR = 0.1;
const float SOCKET_WALL_THICKNESS = 2.0;
const float SOCKET_DIAMETER = BALL_JOINT_DIAMETER+SOCKET_WALL_THICKNESS;
const float SOCKET_HEIGHT = BALL_JOINT_DIAMETER*(1-SOCKET_BALL_UNDERSIZED_OFFSET_FACTOR)/2.0+SOCKET_WALL_THICKNESS;


@implementation BikeMirror

#pragma mark - Override

- (void)buildSubObjects {
    OSCompositeObject *halfArmHead = [self halfArmHead];
    [halfArmHead addTransformation:mirror(1, 0, 0)];
    
    [self.subObjects addObject:halfArmHead];
    [self.subObjects addObject:[self halfArmHead]];
}


#pragma mark - Private API

- (OSCompositeObject *)halfArmHead {
    OSCube *arm = [[OSCube alloc] initWithSizeVector:v(ARM_LENGTH/2, ARM_WIDTH, ARM_HEIGHT)];
    [arm addTransformation:translate(ARM_LENGTH/4, 0, -ARM_HEIGHT/2)];
    
    OSCylinder *socketBlank = [[OSCylinder alloc] initWithDiameter:SOCKET_DIAMETER height:SOCKET_HEIGHT];
    [socketBlank addTransformation:translate(ARM_LENGTH/2, 0, -SOCKET_HEIGHT/2)];
    
    OSCompositeObject *armHeadBlank = [[OSCompositeObject alloc] initWithSubObjects:@[arm, socketBlank]];
    armHeadBlank.compositeType = OSCTUnion;
    
    OSSphere *ball = [[OSSphere alloc] initWithDiameter:BALL_JOINT_DIAMETER];
    [ball addTransformation:[OSColorTransformation transformationWithColor:color(1, 0, 0, 1)]];
    [ball addTransformation:translate(ARM_LENGTH/2, 0, BALL_JOINT_DIAMETER*SOCKET_BALL_UNDERSIZED_OFFSET_FACTOR)];
    
    OSCompositeObject *armHead = [[OSCompositeObject alloc] initWithSubObjects:@[armHeadBlank, ball]];
    armHead.compositeType = OSCTDifference;
    
    return armHead;
}

@end
