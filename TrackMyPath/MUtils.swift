//
//  File.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 29/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation

class MUtils{
    static func  radianToDegrees(radians:Double) -> Double {
        return Utils.rnd((radians * 180/M_PI),decimalPoint: 0)
    }
    static func  degreesToRadian(degree:Double) -> Double {
        return degree * M_PI/180
    }
    static func  degreesToRadian(degree:Int) -> Double {
        return Double(degree) * M_PI/180
    }
    static func  getDisplacment(v0 : Double, a:Double, t:Double) -> Double{
        return Utils.rnd((v0 * t + (0.5 * a * t * t)) * 100) //in cm
    }
    static func  getVelocity(v0:Double,a:Double, t:Double)->Double{
        return v0 + a * t
    }
    
   
    static func getNormalizedRadian(D:Double)->Double{
        
        return degreesToRadian((Utils.rnd(D/Config.FilterAngle2x,decimalPoint: 0)%Config.noOfSectors)*(Config.FilterAngle2x))
    }
    
}