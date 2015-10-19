//
//  Utils.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 29/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
class Utils {
    static let g2ms2 = 98.0
    static func rnd(val:Double, decimalPoint:Int = 2) -> Double{
        let mulFactor = pow(10.0,Double(decimalPoint))
        //print("\(mulFactor) \(val)")
        return round(val * mulFactor) / mulFactor
    }
    static func convertG2ms2(val:Double) -> Double{
        return Utils.rnd(val * Utils.g2ms2)
    }
    
    static func get90Degree(d:Int)->[Int]{
        
        var res:[Int] = [0,0]
        if d < 0 {
            if (d + 90 < 0){
                res[0] = d + 90
                res[1] = res[0] + 180
            } else {
                res[1] = d + 90
                res[0] = res[1] + 180
            }
        } else {
            if (d - 90 < 0){
                res[0] = d - 90
                res[1] = res[0] + 180
            } else {
                res[1] = d - 90
                res[0] = res[1] - 180
            }
            
        }
        return res
    }
    static func get45DegreePlus(d:Int) -> Int{
        let res = d + 45
        return res > 180 ? (res - 360) : res
    }
    static func get45DegreeMinus(d:Int) -> Int{
        let res = d - 44
        return res < -180 ? (res + 360) : res
    }
    
    static func isInside(low:Int, high:Int , deg: Int) -> Bool{
        print(" \(low) \(high) \(deg)")
        let deg = deg < 0 ? deg + 360 : deg
        let l = low < 0 ? low + 360 : low
        let h = high < 0 ? high + 360 : high
        
        if  l > h  { // high move to 0 degree and low is with in 360
            if (deg >= 0 && deg <= h){
                print("true")
                return true
            } else if (deg >= l && deg >= 359) {
                print("true")
                return true
            } else if (deg >= h && deg <= l){
                print("true")
                return true
                
            } else {
                print("false")
                return false
            }
        } else{
            if deg >= l && deg <= h {
                print("true")
                return true
            }
        }
        print("false")
        return false
    }

}