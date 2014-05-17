//
//  BikeMirror.m
//  Objective-SCAD-Objects
//
//  Created by Jeffrey Camealy on 5/12/14.
//  Copyright (c) 2014 bearMountain. All rights reserved.
//

#import "BikeMirror.h"
#import "ObjectiveSCADHeaders.h"


#pragma mark - Measurements

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

// Mount
const float MOUNT_HEIGHT = 35.0;
const float MOUNT_WIDTH = 50;
const float MOUNT_THICKNESS = 3.0;

// Mount Bracket
const float MOUNT_BRACKET_LENGTH = 8.0;
const float MOUNT_BRACKET_WIDTH = 5.0;
const float MOUNT_CUTOUT_WIDTH = 2.0;
const float MOUNT_CUTOUT_LENGTH = MOUNT_HEIGHT/2;
const float MOUNT_CUTOUT_OFFSET = MOUNT_WIDTH*(1.0/4.0);


@implementation BikeMirror

#pragma mark - Override

- (void)buildSubObjects {
    [self.subObjects addObject:[self piecesLaidOut]];
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

- (OSCompositeObject *)fullArm {
    OSCompositeObject *halfArmHead = [self halfArmHead];
    [halfArmHead addTransformation:mirror(1, 0, 0)];
    
    OSCompositeObject *fullArm = [[OSCompositeObject alloc] initWithSubObjects:@[halfArmHead, [self halfArmHead]]];
    return fullArm;
}

- (OSObject *)twoArmsInPlace {
    OSObject *arm1 = [self fullArm];
    [arm1.transformations addObject:mirror(0, 0, -1)];
    [arm1.transformations addObject:translate(0, 0, SOCKET_HEIGHT)];
    
    OSCompositeObject *arms = [[OSCompositeObject alloc] initWithSubObjects:@[arm1, [self fullArm]]];
    return arms;
}

- (OSObject *)mountBlank {
    OSCylinder *mount = [[OSCylinder alloc] initWithDiameter:MOUNT_HEIGHT height:MOUNT_THICKNESS];
    [mount.transformations addObject:scale(MOUNT_WIDTH/MOUNT_HEIGHT, 1, 1)];
    
    float curveSlop = BALL_JOINT_DIAMETER/2;
    OSCube *bracket = [[OSCube alloc] initWithSizeVector:v(MOUNT_BRACKET_WIDTH, MOUNT_BRACKET_LENGTH+curveSlop, MOUNT_THICKNESS)];
    [bracket.transformations addObject:translate(0, -(MOUNT_HEIGHT/2+MOUNT_BRACKET_LENGTH/2), 0)];
    
    OSSphere *ball = [[OSSphere alloc] initWithDiameter:BALL_JOINT_DIAMETER];
    [ball.transformations addObject:translate(0, -(MOUNT_HEIGHT/2+MOUNT_BRACKET_LENGTH+BALL_JOINT_DIAMETER/2), 0)];
    
    
    OSCompositeObject *armBlank = [[OSCompositeObject alloc] initWithSubObjects:@[mount, bracket, ball]];
    return armBlank;
}

- (OSObject *)mountCutout {
    OSCube *cutout = [[OSCube alloc] initWithSizeVector:v(MOUNT_CUTOUT_WIDTH, MOUNT_CUTOUT_LENGTH, MOUNT_THICKNESS+os_epsilon)];
    [cutout.transformations addObject:translate(MOUNT_CUTOUT_OFFSET, MOUNT_CUTOUT_LENGTH/2.0, 0)];
    [cutout.transformations addObject:[OSColorTransformation transformationWithColor:redColor()]];
    return cutout;
}

- (OSObject *)mount {
    OSObject *mountBlank = [self mountBlank];
    
    OSObject *cutout1 = [self mountCutout];
    [cutout1.transformations addObject:mirror(1, 0, 0)];
    
    OSCompositeObject *mount = [[OSCompositeObject alloc] initWithSubObjects:@[mountBlank, cutout1, [self mountCutout]]];
    mount.compositeType = OSCTDifference;
    
    return mount;
}

- (OSObject *)piecesLaidOut {
    OSObject *mount = [self mount];
    [mount.transformations addObject:translate(0, 0, BALL_JOINT_DIAMETER/2.0)];
    
    OSObject *arm = [self fullArm];
    [arm.transformations addObject:translate(0, MOUNT_HEIGHT*(3.0/4.0), SOCKET_HEIGHT)];
    
    OSObject *arm2 = [self fullArm];
    [arm2.transformations addObject:translate(0, MOUNT_HEIGHT*(3.0/4.0)+SOCKET_DIAMETER*1.5, SOCKET_HEIGHT)];
    
    OSCompositeObject *pieces = [[OSCompositeObject alloc] initWithSubObjects:@[mount, arm, arm2]];
    return pieces;
}

@end
