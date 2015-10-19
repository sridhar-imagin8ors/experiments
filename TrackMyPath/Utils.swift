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
}