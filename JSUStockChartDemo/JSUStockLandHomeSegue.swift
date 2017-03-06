//
//  CSFStockLandTimeSegue.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/4/11.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit

class JSUStockLandHomeSegue: UIStoryboardSegue {
    override func perform() {
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        let firstVC = self.sourceViewController as! ViewController
        let secondVC = self.destinationViewController as! JSUStockLandHomeViewController
        
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        secondVC.view.frame = CGRectMake(0,screenHeight, screenWidth, screenHeight)
        
        
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVC.view, aboveSubview: firstVC.view)

        let overplayView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
        overplayView.transform =  CGAffineTransformMakeRotation(-90 * CGFloat(M_PI) / 180.0);
        overplayView.x = 0
        overplayView.y = 0
        secondVC.view.insertSubview(overplayView, belowSubview: secondVC.stockView)
        
        self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
        secondVC.view.layoutIfNeeded()
        UIView.animateWithDuration(0.4, animations: {
            secondVC.topValue.priority = 800
            secondVC.view.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
}
