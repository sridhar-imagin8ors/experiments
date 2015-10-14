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
    @IBOutlet weak var mailTextLabel: UILabel!
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
    var currAZ:Double = 0.0
    var prevAX:Double = 0.0
    var prevAY:Double = 0.0
    var prevAZ:Double = 0.0
    
    var currVX:Double = 0.0
    var currVY:Double = 0.0
    var currVZ:Double = 0.0
    var prevVX:Double = 0.0
    var prevVY:Double = 0.0
    var prevVZ:Double = 0.0
    
    var currDX:Double = 0.0
    var currDY:Double = 0.0
    var currDZ:Double = 0.0
    var prevDX:Double = 0.0
    var prevDY:Double = 0.0
    var prevDZ:Double = 0.0
    
    var resetCount = 0
    var resetWhenReach = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("checking the load function bound")
        manager = CMMotionManager()
        
        queue = NSOperationQueue()
        
        
        if self.manager!.deviceMotionAvailable {
            let updateFrequency = 0.0167// sec
            self.manager!.deviceMotionUpdateInterval = updateFrequency
            self.manager?.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical, toQueue: queue!)
                {
                (data:CMDeviceMotion?,error:NSError?) in
                if let d = data{
                    //x,y,z = raw value
                    let x = Utils.convertG2ms2(d.userAcceleration.x)
                    let y = Utils.convertG2ms2(d.userAcceleration.y)
                    let z = Utils.convertG2ms2(d.userAcceleration.z)
                    //self.mailTextLabel.text = "Calibrating... Keep the device still"
                    if self.calibrationRequired {
                        self.doCalibrate(x,y:y,z:z)
                        return
                    }
                  //  self.mailTextLabel.text = "Calibration Completed.\n Now you move the device"
                   // self.mailTextLabel.text = "Collecting data"
                    
                    //x1,y1,z1 - Normalized value
                    let x1 = (x < self.maxX && x > self.minX) ? 0 : x
                    let y1 = (y < self.maxY && y > self.minY) ? 0 : y
                    let z1 = (z < self.maxZ && z > self.minZ) ? 0 : z
                    
                    if x1 != 0  || y1 != 0 || z1 != 0 {
                        self.currAX = x1
                        self.currAY = y1
                        self.currAZ = z1
                       // print("\( x1 ) , \( y1 ), \( z1 ) ")
                        //calculate velocity and distance
                        self.currVX = self.prevVX + self.prevAX + ((self.currAX - self.prevAX)/2)
                        self.currVY = self.prevVY + self.prevAY + ((self.currAY - self.prevAY)/2)
                        self.currVZ = self.prevVZ + self.prevAZ + ((self.currAZ - self.prevAZ)/2)
                        
                        self.currDX = self.prevDX + self.prevVX + ((self.currVX - self.prevVX)/2)
                        self.currDY = self.prevDY + self.prevVY + ((self.currVY - self.prevVY)/2)
                        self.currDZ = self.prevDZ + self.prevVZ + ((self.currVZ - self.prevVZ)/2)
                    
                        if self.resetCount % self.resetWhenReach == 0 {
                            self.prevAX = 0.0
                            self.prevAY = 0.0
                            self.prevAZ = 0.0
                            
                            self.prevVX = 0.0
                            self.prevVY = 0.0
                            self.prevVZ = 0.0
                        } else {
                            self.prevAX = self.currAX
                            self.prevAY = self.currAY
                            self.prevAZ = self.currAZ
                            
                            self.prevVX = self.currVX
                            self.prevVY = self.currVY
                            self.prevVZ = self.currVZ
                        
                        }
                        self.prevDX = self.currDX
                        self.prevDY = self.currDY
                        self.prevDZ = self.currDZ
                        self.resetCount++

                        
                        print("\(Int(Utils.rnd(self.currDX,decimalPoint:0))) , \(Int(Utils.rnd(self.currDY,decimalPoint:0))) , \(Int(Utils.rnd(self.currDZ,decimalPoint:0))) " )
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
        if maxZ < z { maxZ = z }
        if minX > x { minX = x }
        if minY > y { minY = y }
        if minZ > z { minZ = z }
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

