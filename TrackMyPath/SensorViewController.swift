//
//  SensorViewController.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 25/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import UIKit
import CoreMotion

class SensorViewController: UIViewController {
    var manager :CMMotionManager?
    var queue :NSOperationQueue?
    
    var calibrationRequired:Bool = true
    
    //FIXME Move the points to a structure
    var correctionX:Double = 0.0
    var correctionY:Double = 0.0
    var correctionZ:Double = 0.0
    var correctionCount = 1024.0
    var calibrationSeekBar = 0.0
    
    var maxX = 0.0
    var maxY = 0.0
    var maxZ = 0.0
    var minX = -0.0
    var minY = -0.0
    var minZ = -0.0
    
    var currAX:Double = 0.0
    var currAY:Double = 0.0
    var prevAX:Double = 0.0
    var prevAY:Double = 0.0
    
    var currVX:Double = 0.0
    var currVY:Double = 0.0
    var prevVX:Double = 0.0
    var prevVY:Double = 0.0
    
    var currDX:Double = 0.0
    var currDY:Double = 0.0
    var prevDX:Double = 0.0
    var prevDY:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("checking the load function bound")
        manager = CMMotionManager()
        
        queue = NSOperationQueue()
        
        
        if self.manager!.deviceMotionAvailable {
            let updateFrequency = 0.0167// sec
            self.manager!.deviceMotionUpdateInterval = updateFrequency
            self.manager?.startDeviceMotionUpdatesToQueue(  queue!)
                {
                (data:CMDeviceMotion?,error:NSError?) in
                if let d = data{
                    //x,y,z = raw value
                    let x = Utils.convertG2ms2(d.userAcceleration.x)
                    let y = Utils.convertG2ms2(d.userAcceleration.y)
                    let z = Utils.convertG2ms2(d.userAcceleration.z)
                    
                    if self.calibrationRequired {
                        self.doCalibrate(x,y:y,z:y)
                        return
                    }
                   // print("\( x + self.correctionX) ,\( y + self.correctionY),\( z + self.correctionZ) vs \( x - self.correctionX) ,\( y - self.correctionY),\( z - self.correctionZ)")
                    //x1,y1,z1 - Normalized value
                    let x1 = (x < self.maxX && x > self.minX) ? 0 : x
                    let y1 = (y < self.maxY && y > self.minY) ? 0 : y
                    if x1 != 0  || y1 != 0{
                        self.currAX = x1
                        self.currAY = y1
                        //calculate velocity and distance
                        self.currVX = self.prevVX + self.prevAX + ((self.currAX - self.prevAX)/2)
                        self.currVY = self.prevVY + self.prevAY + ((self.currAY - self.prevAY)/2)
                        
                        self.currDX = self.prevDX + self.prevVX + ((self.currVX - self.prevVX)/2)
                        self.currDY = self.prevDY + self.prevVY + ((self.currVY - self.prevVY)/2)
                        
                        self.prevAX = self.currAX
                        self.prevAY = self.currAY
                        
                        self.prevVX = self.currVX
                        self.prevVY = self.currVY
                        
                        self.prevDX = self.currDX
                        self.prevDY = self.currDY
                        
                        print("\(Int(Utils.rnd(self.currDX,decimalPoint:0))) , \(Int(Utils.rnd(self.currDY,decimalPoint:0))) " )
                    }
                }
            }
        }
        
    }
    
    func doCalibrate(x:Double,y:Double,z:Double){
        self.correctionX += x
        self.correctionY += y
        self.correctionZ += z
        if maxX < x { maxX = x }
        if maxY < y { maxY = y }
        if minX > x { minX = x }
        if minY > y { minY = y }
        self.calibrationSeekBar++
        if self.calibrationSeekBar >= self.correctionCount{
            self.calibrationRequired = false
            self.correctionX /= Double(self.correctionCount)
            self.correctionY /= Double(self.correctionCount)
            self.correctionZ /= Double(self.correctionCount)
            print("correction value \(self.correctionX),\(self.correctionY),\(self.correctionZ)")
            
            
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        if let mgr = self.manager{
            mgr.stopDeviceMotionUpdates()
        }
    }
        
}

