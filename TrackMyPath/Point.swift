//
//  Point.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 18/10/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
class Point{
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    
    init(x:Double, y:Double, z:Double){
        self.x = x
        self.y = y
        self.z = z
    }
    init(){}
    
    func dump() -> String{
        return "\(Int(x)),\(Int(y)),\(Int(z))"
    }
    
    func doesContainValue()->Bool{
        return (Int(x) != 0 || Int(y) != 0 || Int(z) != 0)
    }
}