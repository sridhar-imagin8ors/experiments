//
//  Utils.swift
//  TrackMyPath
//
//  Created by Sridhar Murali on 29/09/15.
//  Copyright © 2015 Sridhar Murali. All rights reserved.
//

import Foundation
import MessageUI

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
    
    static func sendMail(viewController:UIViewController, delegate:MFMailComposeViewControllerDelegate, fileName: String, data:String){
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(fileName);
            
            //writing
            do {
                try data.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
            
            if( MFMailComposeViewController.canSendMail() ) {
                print("Can send email.")
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = delegate
                mailComposer.setSubject("Sample data")
                mailComposer.setMessageBody("Hi, User grapher in the mac to present it in graph view. Thanks", isHTML: false)
                if let fileData = NSData(contentsOfFile: path) {
                    print("File data loaded.")
                    mailComposer.addAttachmentData(fileData, mimeType: "text/plain", fileName: "Sample Data.txt")
                    viewController.presentViewController(mailComposer, animated: true, completion: nil)
                }
            }else{
                let objectsToShare = [data]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                viewController.presentViewController(activityVC, animated: true, completion: nil)
            }
            
        }
    }

}