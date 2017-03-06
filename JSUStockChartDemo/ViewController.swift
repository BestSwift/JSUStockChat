//
//  ViewController.swift
//  JSUStockChartDemo
//
//  Created by 苏小超 on 16/7/4.
//  Copyright © 2016年 com.jason.su. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var StockChartView:UIView!
    var timeController :JSUTimeViewController?
    var fiveController : JSUFiveTimeViewController?
    var kLineController : JSUKLineViewController?
    var weekController : JSUWeekLineViewController?
    var monthController : JSUMonthLineViewController?
    var curVC :UIViewController!
    var oldVC :UIViewController!
    var curType = KLineType.Time
    var statusData : JSUStateModel!
    var tapGesture : UITapGestureRecognizer{
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        let data:JSUStateModel = readFile("priceData", ext: "json")
        self.statusData = data
        
        timeController = jsuStoryboardMain("JSUTimeViewController") as? JSUTimeViewController
        timeController!.view.frame = StockChartView.bounds
        fiveController = jsuStoryboardMain("JSUFiveTimeViewController") as? JSUFiveTimeViewController
        fiveController!.view.frame = StockChartView.bounds
        kLineController = jsuStoryboardMain("JSUKLineViewController") as? JSUKLineViewController
        kLineController!.view.frame = StockChartView.bounds
        weekController = jsuStoryboardMain("JSUWeekLineViewController") as? JSUWeekLineViewController
        weekController!.view.frame = StockChartView.bounds
        monthController = jsuStoryboardMain("JSUMonthLineViewController") as? JSUMonthLineViewController
        monthController!.view.frame = StockChartView.bounds
        self.addChildViewController(timeController!)
        self.addChildViewController(fiveController!)
        self.addChildViewController(kLineController!)
        self.addChildViewController(weekController!)
        self.addChildViewController(monthController!)
        self.StockChartView.addSubview(monthController!.view)
        self.StockChartView.addSubview(weekController!.view)
        self.StockChartView.addSubview(fiveController!.view)
        self.StockChartView.addSubview(kLineController!.view)
        self.StockChartView.addSubview(timeController!.view)
        self.StockChartView.addGestureRecognizer(tapGesture)
        curVC = timeController
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "JSUStockLandHomeSegue"{
            let controller = segue.destinationViewController as! JSUStockLandHomeViewController
            controller.statusData = self.statusData
            controller.curType = self.curType
        }
    }
    
    func handleTapGestureAction(recognizer:UITapGestureRecognizer){
        self.performSegueWithIdentifier("JSUStockLandHomeSegue", sender: self)
    }
    
    @IBAction func returnFromSegueActions(sender:UIStoryboardSegue){
    }

    
    @IBAction func timeButtonClick(){
        if curVC != timeController{
            oldVC = self.curVC
            curType = .Time
            self.transitionFromViewController(self.curVC, toViewController: timeController!, duration: 0, options: .CurveEaseIn, animations: { () -> Void in
            }) { (finish) -> Void in
                if finish{
                    self.curVC = self.timeController
                }else{
                    self.curVC = self.oldVC
                }
            }
        }
    }
    
    @IBAction func fiveButtonClick(){
        if curVC != fiveController{
            oldVC = self.curVC
            curType = .Five
            self.transitionFromViewController(self.curVC, toViewController: fiveController!, duration: 0, options: .CurveEaseIn, animations: { () -> Void in
            }) { (finish) -> Void in
                if finish{
                    self.curVC = self.fiveController
                }else{
                    self.curVC = self.oldVC
                }
            }
        }
    }
    
    @IBAction func kLineButtonClick(){
        if self.curVC != kLineController{
            oldVC = self.curVC
            curType = .Day
            self.transitionFromViewController(self.curVC, toViewController: kLineController!, duration: 0, options: .CurveEaseIn, animations: { () -> Void in
            }) { (finish) -> Void in
                if finish{
                    self.curVC = self.kLineController
                }else{
                    self.curVC = self.oldVC
                }
            }
        }
    }
    
    @IBAction func weekButtonClick(){
        if self.curVC != weekController{
            oldVC = self.curVC
            curType = .Week
            self.transitionFromViewController(self.curVC, toViewController: weekController!, duration: 0, options: .CurveEaseIn, animations: { () -> Void in
            }) { (finish) -> Void in
                if finish{
                    self.curVC = self.weekController
                }else{
                    self.curVC = self.oldVC
                }
            }
        }
    }
    
    @IBAction func monthButtonClick(){
        if self.curVC != monthController{
            oldVC = self.curVC
            curType = .Month
            self.transitionFromViewController(self.curVC, toViewController: monthController!, duration: 0, options: .CurveEaseIn, animations: { () -> Void in
            }) { (finish) -> Void in
                if finish{
                    self.curVC = self.monthController
                }else{
                    self.curVC = self.oldVC
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

