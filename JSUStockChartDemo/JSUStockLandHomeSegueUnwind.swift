//
//  CSFStockLandHomeSegueUnwind.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/4/11.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit

class JSUStockLandHomeSegueUnwind: UIStoryboardSegue {
    override func perform() {
        
        let firstVC = self.sourceViewController as! JSUStockLandHomeViewController
        
        firstVC.view.layoutIfNeeded()
        UIView.animateWithDuration(0.4, animations: {
            firstVC.topValue.priority = 700
            firstVC.bgView.alpha = 0
            firstVC.timeTapView.alpha = 0
            firstVC.kLineTapView.alpha = 0
            firstVC.view.layoutIfNeeded()
        }) { (finish) in
            self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
            //UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        }

    }
}
