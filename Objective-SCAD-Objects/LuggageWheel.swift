//
//  LuggageWheel.swift
//  Objective-SCAD-Objects
//
//  Created by Jeffrey Camealy on 7/1/14.
//  Copyright (c) 2014 bearMountain. All rights reserved.
//

import Foundation

let Thickness: Float = 20
let CurveRadius: Float = 5
let CurveResolution: CInt = 20
let TotalDiameter: Float = 60
let HoleDiameter: Float = 10
let WheelResolution: CInt = 40

class LuggageWheel : OSCompositeObject {
    
    override func buildSubObjects() {
        let wheelShape = makeWheelShape()
        
        let rotationalExtrusion = OSRotationalExtrusion(with2DShape: wheelShape, resolution: WheelResolution)
        self.subObjects.addObject(rotationalExtrusion)
    }
    
    func makeWheelShape() -> OSObject {
        let circleRight = OSCircle(radius: CurveRadius, resolution: CurveResolution)
        let circleLeft = OSCircle(radius: CurveRadius, resolution: CurveResolution)
        
        circleRight.transformations.addObject(translate(Thickness/2-CurveRadius, 0, 0))
        circleLeft.transformations.addObject(translate(-(Thickness/2-CurveRadius), 0, 0))
        
        let wheelShape = OSCompositeObject(subObjects: [circleRight, circleLeft])
        wheelShape.compositeType = OSCTHull
        wheelShape.transformations.addObject(translate(0, -(TotalDiameter/2-HoleDiameter/2), 0))
        
        let height = TotalDiameter/2-HoleDiameter/2-CurveRadius
        let rect = OSRectangle(size: sz(Thickness, height))
        rect.transformations.addObject(translate(0, -(height/2+HoleDiameter/2), 0))
        
        let moreWheel = OSCompositeObject(subObjects: [wheelShape, rect]);
        moreWheel.transformations.addObject(rotate(0, 0, 3.14159265358979323846264/2))
        
        return moreWheel
    }
}















