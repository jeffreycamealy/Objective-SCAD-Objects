//
//  LuggageWheel.swift
//  Objective-SCAD-Objects
//
//  Created by Jeffrey Camealy on 7/1/14.
//  Copyright (c) 2014 bearMountain. All rights reserved.
//

import Foundation

class LuggageWheel : OSCompositeObject {
    
    override func buildSubObjects() {
        let wheelShape = makeWheelShape()
        wheelShape.transformations.addObject(rotate(0, 0, 3.14159265358979323846264/2))
        wheelShape.transformations.addObject(translate(10, 0, 0))
        
        let rotationalExtrusion = OSRotationalExtrusion(with2DShape: wheelShape, resolution: 10)
        self.subObjects.addObject(rotationalExtrusion)
    }
    
    func makeWheelShape() -> OSObject {
        let circleRight = OSCircle(radius: 3, resolution: 10)
        let circleLeft = OSCircle(radius: 3, resolution: 10)
        
        circleRight.transformations.addObject(translate(4, 0, 0))
        circleLeft.transformations.addObject(translate(-4, 0, 0))
        
        let wheelShape = OSCompositeObject(subObjects: [circleRight, circleLeft])
        wheelShape.compositeType = OSCTHull
        
        return wheelShape
    }
}
