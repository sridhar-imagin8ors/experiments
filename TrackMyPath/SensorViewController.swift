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
    override func viewDidLoad() {
        super.viewDidLoad()
        print("checking the load function bound")
        manager = CMMotionManager()
        
        queue = NSOperationQueue()
        
        
        if self.manager!.deviceMotionAvailable {
            let updateFrequency = 1.0 // sec
            self.manager!.deviceMotionUpdateInterval = updateFrequency
            self.manager!.startDeviceMotionUpdatesToQueue(queue!) {
                (data:CMDeviceMotion?,error:NSError?) in
                /*var xv0:Double = 0
                var xv:Double = 0
                var yv0:Double = 0
                var yv:Double = 0
                var x = 0.0
                var y = 0.0*/
                if let d = data{
                    //print("Attitude : pitch :: \(self.degrees(d.attitude.pitch)) Roll :: \(self.degrees(d.attitude.roll)) Yaw :: \(self.degrees(d.attitude.yaw))")
                   // print("Gyro : x :: \( (d.rotationRate.x)) y :: \( (d.rotationRate.y)) z :: \( (d.rotationRate.z))")
                    print("GA : x :: \( Utils.rnd(d.gravity.x)) y :: \( Utils.rnd(d.gravity.y)) z :: \( Utils.rnd(d.gravity.z))")
                    print("UA : x :: \( Utils.rnd(d.userAcceleration.x)) y :: \( Utils.rnd(d.userAcceleration.y)) z :: \( Utils.rnd(d.userAcceleration.z))")
                   /* xv = MUtils.getVelocity(xv0,a:d.userAcceleration.x,t:updateFrequency)
                    yv = MUtils.getVelocity(yv0,a:d.userAcceleration.y,t:updateFrequency)
                    x += MUtils.getDisplacment(xv0,a:d.userAcceleration.x,t:updateFrequency)
                    y += MUtils.getDisplacment(yv0,a:d.userAcceleration.y,t:updateFrequency)
                    xv0 = xv
                    yv0 = yv
                    print("\(x),\(y)")*/
                }
            }
            
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        if let mgr = self.manager{
            mgr.stopDeviceMotionUpdates()
        }
    }
    
}

