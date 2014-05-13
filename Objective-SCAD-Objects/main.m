//
//  main.m
//  Objective-SCAD-Objects
//
//  Created by Jeffrey Camealy on 5/12/14.
//  Copyright (c) 2014 bearMountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveSCAD.h"
#import "BikeMirror.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [ObjectiveSCAD scadObjects:@[[BikeMirror new]]];
    }
    return 0;
}

