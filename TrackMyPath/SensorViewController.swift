//
//  SensorViewController.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 25/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI

class SensorViewController: UIViewController , MFMailComposeViewControllerDelegate{
    var manager :CMMotionManager?
    var queue :NSOperationQueue?
    
    var calibrationRequired:Bool = true
    
    @IBOutlet weak var mailTextLabel: UILabel!
    
    var correction = Point()
    let correctionCount = 64.0
    var calibrationSeekBar = 0.0
    
    var max = Point(x:3.0,y:3.0,z:3.0)
    var min = Point(x:-3.0,y:-3.0,z:-3.0)
    var acceleration = [Point(),Point()]
    var velocity = [Point(),Point()]
    var displacement = [Point(),Point()]
    
    var resetCount = 0
    let resetWhenReach = 20
    let updateFrequency = Utils.rnd(1/40, decimalPoint: 4)// sec
    var filename = "track_data.txt"
    var dumpdata:String = ""
    var yawDegree:Int = 0
    let degreeBand:Int = 5
    let useYaw = true
    
    
    func doCalibrate(x:Double,y:Double,z:Double,yaw:Int){
        self.correction.x += x
        self.correction.y += y
        self.correction.z += z
        if self.max.x < x { self.max.x = x }
        if self.max.y < y { self.max.y = y }
        
        if self.max.z < z { self.max.z = z }
        if self.min.x > x { self.min.x = x }
        if self.min.y > y { self.min.y = y }
        if self.min.z > z { self.min.z = z }
        self.yawDegree += self.yawDegree
        self.calibrationSeekBar++
        if self.calibrationSeekBar >= self.correctionCount{
            self.calibrationRequired = false
            self.correction.x /= Double(self.correctionCount)
            self.correction.y /= Double(self.correctionCount)
            self.correction.z /= Double(self.correctionCount)
            self.yawDegree /= Int(self.correctionCount)
            print("correction value \(self.correction.x),\(self.correction.y),\(self.correction.z), y reference angle : \( self.yawDegree)")
            print("max value \(self.max.x),\(self.max.y),\(self.max.z)")
            print("min value \(self.min.x),\(self.min.y),\(self.min.z)")
            //mailTextLabel.text = " Calibrated. Lets go for a walk"
        }
        
    }
    
    @IBAction func stopTracking(sender: UIButton) {
        if let mgr = self.manager{
            mgr.stopDeviceMotionUpdates()
        }
    }
    
    
    @IBAction func sendMail(sender: UIButton) {
        
        Utils.sendMail(self, delegate: self, fileName: self.filename, data: self.dumpdata)
        
    }
    override func viewWillDisappear(animated: Bool) {
        if let mgr = self.manager{
            mgr.stopDeviceMotionUpdates()
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("checking the load function bound")
        manager = CMMotionManager()
        dumpdata = ""
        queue = NSOperationQueue()
        
        if self.manager!.deviceMotionAvailable {
            
            self.manager!.deviceMotionUpdateInterval = self.updateFrequency
            self.manager?.startDeviceMotionUpdatesToQueue(queue!,withHandler:trackHandler)
            
        }
    }
    
    func trackHandler(data:CMDeviceMotion?,error:NSError?) {
        
        if let d = data{
            
            //x,y,z = raw value
            let a = Point(x: 0.0,y:Utils.convertG2ms2(d.userAcceleration.y), z:0.0)
            //print("\(Int(MUtils.radianToDegrees(d.attitude.yaw))) , \(d.attitude.yaw)")
            //self.mailTextLabel.text = "Calibrating... Keep the device still",
            if self.calibrationRequired {
                let degree = self.useYaw ? Int(MUtils.radianToDegrees(d.attitude.yaw)) : Int(MUtils.radianToDegrees(d.attitude.pitch))
                self.doCalibrate(a.x , y: a.y , z: a.z , yaw: degree)
                return
            }
            
            //x1,y1,z1 - Normalized value
            let x1 = (a.x + self.correction.x < self.max.x && a.x  + self.correction.x > self.min.x) ? 0 : a.x  + self.correction.x
            var y1 = (a.y + self.correction.y < self.max.y && a.y  + self.correction.y > self.min.y) ? 0 : a.y  + self.correction.y
            let z1 = (a.z + self.correction.z < self.max.y && a.z  + self.correction.z > self.min.z) ? 0 : a.z  + self.correction.z
            //FIXME Do refactor. Change to generic method
            if x1 != 0  || y1 != 0 || z1 != 0 {
                var yBy:Bool = true
                var isForward:Bool = true
                var currDegree = (self.useYaw ? Int(MUtils.radianToDegrees(d.attitude.yaw)) : Int(MUtils.radianToDegrees(d.attitude.pitch))) + self.yawDegree
               // print(currDegree)
                currDegree = currDegree < 0 ? currDegree + 360 : currDegree
                var currDegreeRnd = 0.0
                if (45 > currDegree && currDegree >= 0 ) || (359 >= currDegree && currDegree >= 315){
                    isForward = true
                    yBy = true
                    currDegreeRnd = MUtils.degreesToRadian(0.0)
                    print("y")
                } else if (135 <= currDegree && currDegree < 225){
                    yBy = true
                    isForward = false
                    currDegreeRnd = MUtils.degreesToRadian(180.0)
                    print("-y")
                } else if (225 <= currDegree && currDegree < 315){
                    yBy = false
                    isForward = true
                    currDegreeRnd = MUtils.degreesToRadian(90.0)
                    print("x")
                }else if (45 <= currDegree && currDegree < 135){
                    isForward = false
                    currDegreeRnd = MUtils.degreesToRadian(-90.0)
                    yBy = false
                    print("-x")
                } else{
                    print(" fixme - I am not suppose to be here  \(Int(MUtils.radianToDegrees(d.attitude.yaw)))" )
                }
                
                if !isForward{
                    y1 = abs(y1) * -1
                }else{
                    y1 = abs(y1)
                }
                
                if yBy {
                    self.acceleration[1].x = x1
                    self.acceleration[1].y = y1
                    
                } else {
                    self.acceleration[1].x = y1
                    self.acceleration[1].y = x1
                    
                }
//                self.acceleration[1].x = y1 * cos(Double(currDegree))
//                self.acceleration[1].y = y1 * sin(Double(currDegree))
                self.acceleration[1].z = z1
                // print(" acceleration : \( a.dump() )  ")
                //calculate velocity and distance
                //delta v = va x t
                //va = vi+vf/2
                //vf = at
                //va = vi +at/2
                //delta v = vit + at^2/2
                self.velocity[1].x = self.velocity[0].x  + self.acceleration[0].x + ((self.acceleration[1].x - self.acceleration[0].x )/2)
                self.velocity[1].y = self.velocity[0].y  + self.acceleration[0].y + ((self.acceleration[1].y - self.acceleration[0].y )/2)
                self.velocity[1].z = self.velocity[0].z  + self.acceleration[0].z + ((self.acceleration[1].z - self.acceleration[0].z )/2)
                
                //delta displacement = di t + delta v * t
                self.displacement[1].x = self.displacement[0].x  + self.velocity[0].x + ((self.velocity[1].x - self.velocity[0].x )/2)
                self.displacement[1].y = self.displacement[0].y  + self.velocity[0].y + ((self.velocity[1].y - self.velocity[0].y )/2)
                self.displacement[1].z = self.displacement[0].z  + self.velocity[0].z + ((self.velocity[1].z - self.velocity[0].z )/2)
                
                self.acceleration[0] = self.acceleration[1]
                self.velocity[0] = self.velocity[1]
                self.displacement[0] = self.displacement[1]
                
                if(self.resetCount % self.resetWhenReach == 0){
                    //make velocity == 0 after reset times
                    self.velocity[0] = Point()
                    self.acceleration[0] = Point()
                    self.resetCount = 0
                }
                if self.displacement[1].doesContainValue(){
                   // print("\(self.displacement[1].dump())")
                    self.dumpdata += self.displacement[1].dump() + "\n"
                }
                self.resetCount++
            }
        }
        
    }

}

