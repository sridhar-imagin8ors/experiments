//
//  Utils.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 29/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
class Utils {
    static func rnd(val:Double, decimalPoint:Int = 2) -> Double{
        let mulFactor = pow(10.0,Double(decimalPoint))
        //print("\(mulFactor) \(val)")
        return round(val * mulFactor) / mulFactor
    }
}