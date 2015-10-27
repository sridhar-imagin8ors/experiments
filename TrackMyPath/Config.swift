//
//  Config.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 10/27/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
class Config{
    static let FilterAngle = 5.0
    static let missCountMax = 50
    static let updateFrequency = Utils.rnd(1/40, decimalPoint: 4)// sec
    static let FilterAngle2x = FilterAngle*2.0
    static let noOfSectors = 360.0/Config.FilterAngle2x
}