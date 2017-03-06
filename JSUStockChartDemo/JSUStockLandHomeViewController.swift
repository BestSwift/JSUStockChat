//
//  CSFStockLandHomeViewController.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/4/11.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit

enum KLineType {
    case Time
    case Five
    case Day
    case Week
    case Month
}

class JSUStockLandHomeViewController: UIViewController {
    
    @IBOutlet weak var topView : UIView!

    @IBOutlet weak var bgView : UIView!
    
    @IBOutlet weak var stockView : UIView!
    
    @IBOutlet weak var topValue: NSLayoutConstraint!
    
    @IBOutlet weak var stockNameLabel : UILabel!
    
    @IBOutlet weak var priceLabel : UILabel!
    
    @IBOutlet weak var ratioLabel : UILabel!
    
    @IBOutlet weak var timeLabel : UILabel!
    
    var lineView : UIView?
    
    @IBOutlet weak var timeButton : UIButton!
    @IBOutlet weak var fiveButton : UIButton!
    @IBOutlet weak var kLineButton : UIButton!
    @IBOutlet weak var weekButton : UIButton!
    @IBOutlet weak var monthButton : UIButton!
    
    @IBOutlet weak var timeTapView:UIView!
    @IBOutlet weak var kLineTapView:UIView!
    
    @IBOutlet weak var openLabel : UILabel!
    @IBOutlet weak var highLabel : UILabel!
    @IBOutlet weak var lowLabel : UILabel!
    @IBOutlet weak var closeLabel : UILabel!
    @IBOutlet weak var dtLabel : UILabel!
    @IBOutlet weak var kRatioLabel : UILabel!
    
    @IBOutlet weak var tPriceLabel : UILabel!
    @IBOutlet weak var tRatioLabel : UILabel!
    @IBOutlet weak var tVolLabel : UILabel!
    @IBOutlet weak var tAvgLabel : UILabel!
    @IBOutlet weak var tTimeLabel : UILabel!
    
    
    
    
    
    
    
    
    
    
    
    //数据模型
    var statusData:JSUStateModel? //股价
    private var code : String?
    private var tick : String?
    private var stockName : String?
    var curType = KLineType.Time
    
    var curVC : UIViewController!
    var oldVC : UIViewController!
    var timeController :JSUTimeViewController?
    var fiveController : JSUFiveTimeViewController?
    var kLineController : JSUKLineViewController?
    var weekController : JSUWeekLineViewController?
    var monthController : JSUMonthLineViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(landKLineLongTapPressed), name: JSUNotificationLandKLineLongPress, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(landTimeLineLongTapPressed), name: JSUNotificationLandTimeLineLongPress, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(landLongTapUnPressed), name: JSUNotificationLandKLineLongUnPress, object: nil)
        
        lineView = UIView(frame: CGRectMake(0,0,40,2))
        lineView?.backgroundColor = UIColor(netHex: 0xff6e4b, alpha: 1)
        self.topView.addSubview(lineView!)

        
        
        if let data = statusData{
            if let c = data.code{
                self.code = c
            }
            
            if let t = data.tick{
                self.tick = t
            }
            
            if let name = data.name?.szh{
                self.stockName = name
            }
            
            if let name = data.name?.szh{
                self.stockName = name
                self.stockNameLabel.text = name
            }else{
                self.stockNameLabel.text = "--"
            }
            
            if let r = data.ratio{
                if r < 0{
                    self.ratioLabel.textColor = UIColor(netHex: 0x1dbf60, alpha: 1)
                    self.priceLabel.textColor = UIColor(netHex: 0x1dbf60, alpha: 1)
                }else if r > 0{
                    self.ratioLabel.textColor = UIColor(netHex: 0xf24957, alpha: 1)
                    self.priceLabel.textColor = UIColor(netHex: 0xf24957, alpha: 1)
                }else{
                    self.ratioLabel.textColor = UIColor(netHex: 0xaaaaaa, alpha: 1)
                    self.priceLabel.textColor = UIColor(netHex: 0xaaaaaa, alpha: 1)
                }
                self.ratioLabel.text = r.toStringWithFormat("%.2f") + "%"
            }else{
                self.ratioLabel.text = "--"
            }
            
            if let p = data.price{
                self.priceLabel.text = p.toStringWithFormat("%.2f")
            }else{
                self.priceLabel.text = "--"
            }
            
            self.timeLabel.text = NSDate().toString("HH:mm")
            
            loadControllers()

        }else{
            loadTopIndex()
        }
        
        
       
        // Do any additional setup after loading the view.
    }
    
    
    func landKLineLongTapPressed(notification:NSNotification){
        self.kLineTapView.hidden = false
        self.topView.hidden = true
        self.timeTapView.hidden = true
        let data = notification.object as? KLineEntity
        if let t = data?.date{
            self.dtLabel.text = t
        }else{
            self.dtLabel.text = ""
        }
        
        if let o = data?.open{
            self.openLabel.text = o.toStringWithFormat("%.2f")
            if o > data?.preClosePx{
                self.openLabel.textColor = kRedColor
            }else if o < data?.preClosePx{
                self.openLabel.textColor = kGreenColor
            }else{
                self.openLabel.textColor = kGrayColor
            }
        }else{
            self.openLabel.text = ""
        }
        
        if let p = data?.close{
            self.closeLabel.text = p.toStringWithFormat("%.2f")
            if p > data?.preClosePx{
                self.closeLabel.textColor = kRedColor
            }else if p < data?.preClosePx{
                self.closeLabel.textColor = kGreenColor
            }else{
                self.closeLabel.textColor = kGrayColor
            }
        }else{
            self.closeLabel.text = ""
        }
        
        if let h = data?.high{
            self.highLabel.text = h.toStringWithFormat("%.2f")
            if h > data?.preClosePx{
                self.highLabel.textColor = kRedColor
            }else if h < data?.preClosePx{
                self.highLabel.textColor = kGreenColor
            }else{
                self.highLabel.textColor = kGrayColor
            }
        }else{
            self.highLabel.text = ""
        }
        
        if let l = data?.low{
            self.lowLabel.text = l.toStringWithFormat("%.2f")
            if l > data?.preClosePx{
                self.lowLabel.textColor = kRedColor
            }else if l < data?.preClosePx{
                self.lowLabel.textColor = kGreenColor
            }else{
                self.lowLabel.textColor = kGrayColor
            }
            
        }else{
            self.lowLabel.text = ""
        }
        
        if let r = data?.rate{
            if r > 0{
                self.kRatioLabel.textColor = kRedColor
                self.kRatioLabel.text = "+"+r.toStringWithFormat("%.2f")+"%"
            }else if r < 0 {
                self.kRatioLabel.textColor = kGreenColor
                self.kRatioLabel.text = r.toStringWithFormat("%.2f")+"%"
            }else{
                self.kRatioLabel.textColor = kGrayColor
                self.kRatioLabel.text = r.toStringWithFormat("%.2f")+"%"
            }
        }else{
            self.kRatioLabel.text = ""
        }
    }
    
    func landTimeLineLongTapPressed(notification:NSNotification){
        self.kLineTapView.hidden = true
        self.topView.hidden = true
        self.timeTapView.hidden = false
        let data = notification.object as? TimeLineEntity
        if let t = data?.currtTime{
            self.tTimeLabel.text = t
        }else{
            self.tTimeLabel.text = ""
        }
        
        if let p = data?.lastPirce{
            self.tPriceLabel.text = p.toStringWithFormat("%.2f")
        }else{
            self.tPriceLabel.text = ""
        }
        
        if let r = data?.rate{
            self.tRatioLabel.text = r.toStringWithFormat("%.2f")+"%"
            if r > 0{
                self.tRatioLabel.textColor = kRedColor
                self.tPriceLabel.textColor = kRedColor
            }else if r < 0 {
                self.tRatioLabel.textColor = kGreenColor
                self.tPriceLabel.textColor = kGreenColor
            }else{
                self.tRatioLabel.textColor = kGrayColor
                self.tPriceLabel.textColor = kGrayColor
            }
        }else{
            self.tRatioLabel.text = ""
        }
        
        if let v = data?.volume{
            let temp:CGFloat = v / 100
            if temp < 10000{
                self.tVolLabel.text = temp.toStringWithFormat("%.0f") + "手"
            }else{
                self.tVolLabel.text = "\((temp/10000).toStringWithFormat("%.2f"))万手"
            }
        }else{
            self.tVolLabel.text = ""
        }
        
        if let a = data?.avgPirce{
            self.tAvgLabel.text = a.toStringWithFormat("%.2f")
            if a > data?.preClosePx{
                self.tAvgLabel.textColor = kRedColor
            }else if a < data?.preClosePx{
                self.tAvgLabel.textColor = kGreenColor
            }else{
                self.tAvgLabel.textColor = kGrayColor
            }
            
        }else{
            self.tVolLabel.text = ""
        }
        
        self.kLineTapView.hidden = true
    
    }

    func landLongTapUnPressed(){
        self.topView.hidden = false
        self.kLineTapView.hidden = true
        self.timeTapView.hidden = true
    }

    @IBAction func didBackButtonClick(){
        self.performSegueWithIdentifier("JSUStockLandHomeSegueUnwind", sender: self)
    }
    
    func loadControllers(){
        
        if let t = self.tick{
            timeController = jsuStoryboardMain("JSUTimeViewController") as? JSUTimeViewController
            timeController?.code = self.code!
            timeController?.isLandScape = true
            timeController?.tick = t
            timeController?.openPrice = statusData?.open
            fiveController = jsuStoryboardMain("JSUFiveTimeViewController") as? JSUFiveTimeViewController
            fiveController?.isLandScape = true
            fiveController?.tick = t
            kLineController = jsuStoryboardMain("JSUKLineViewController") as? JSUKLineViewController
            kLineController?.isLandScape = true
            kLineController?.tick = t
            weekController = jsuStoryboardMain("JSUWeekLineViewController") as? JSUWeekLineViewController
            weekController?.tick = t
            weekController?.isLandScape = true
            monthController = jsuStoryboardMain("JSUMonthLineViewController") as? JSUMonthLineViewController
            monthController?.tick = t
            monthController?.isLandScape = true
            let frame = self.stockView.bounds
            timeController!.view.frame = frame
            kLineController!.view.frame = frame
            fiveController!.view.frame = frame
            weekController!.view.frame = frame
            monthController!.view.frame = frame
            self.addChildViewController(weekController!)
            self.addChildViewController(monthController!)
            self.addChildViewController(timeController!)
            self.addChildViewController(kLineController!)
            self.addChildViewController(fiveController!)
            self.stockView.addSubview(weekController!.view)
            self.stockView.addSubview(monthController!.view)
            self.stockView.addSubview(kLineController!.view)
            self.stockView.addSubview(fiveController!.view)
            self.stockView.addSubview(timeController!.view)
            
            
            
            curVC = timeController
            
            
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        switch curType {
        case .Time:
            timeButtonClick()
        case .Five:
            fiveButtonClick()
        case .Day:
            kLineButtonClick()
        case .Week:
            weekButtonClick()
        case .Month:
            fiveButtonClick()
        }
    }

    
    //价格
    func loadTopIndex(){
        
        let data:JSUStateModel = readFile("priceData", ext: "json")
        
       
                            self.statusData = data
            
                            if let c = data.code{
                                self.code = c
                            }
            
                            if let t = data.tick{
                                self.tick = t
                            }
            
                            if let name = data.name?.szh{
                                self.stockName = name
                                self.stockNameLabel.text = name
                            }else{
                                self.stockNameLabel.text = "--"
                            }
            
                            if let r = data.ratio{
                                self.ratioLabel.text = r.toStringWithFormat("%%.2f")
                            }else{
                                self.ratioLabel.text = "--"
                            }
            
                            if let p = data.price{
                                self.priceLabel.text = p.toStringWithFormat("%.2f")
                            }else{
                                self.priceLabel.text = "--"
                            }
                            
                            self.timeLabel.text = NSDate().toString("HH:mm")
                            
                            self.loadControllers()
        
        
//        csfRequest(.GET, CSFURLServerMarket, CSFURLPortfStockPrice, parameters: ["code":self.code!], encoding: nil, headers: nil, success: { (statusCode, data, model:CSFBaseModel<CSFOptionalPriceModel>?) -> Void in
//            if let data = model?.message{
//                self.statusData = data
//               
//                if let c = data.code{
//                    self.code = c
//                }
//                
//                if let t = data.tick{
//                    self.tick = t
//                }
//                
//                if let name = data.name?.szh{
//                    self.stockName = name
//                    self.stockNameLabel.text = name
//                }else{
//                    self.stockNameLabel.text = "--"
//                }
//                
//                if let r = data.ratio{
//                    self.ratioLabel.text = r.toStringWithFormat("%%.2f")
//                }else{
//                    self.ratioLabel.text = "--"
//                }
//                
//                if let p = data.price{
//                    self.priceLabel.text = p.toStringWithFormat("%.2f")
//                }else{
//                    self.priceLabel.text = "--"
//                }
//                
//                self.timeLabel.text = NSDate().toString("HH:mm")
//                
//                self.loadControllers()
//            }
//            
//            
//        })
    }
    
    ///股价图切换
    
   @IBAction func timeButtonClick(){
        self.lineView?.center.x = self.timeButton.center.x
        self.lineView?.y = self.topView.height - 2
    
        if curVC != timeController{
            self.timeButton.selected = true
            self.fiveButton.selected = false
            self.kLineButton.selected = false
            self.weekButton.selected = false
            self.monthButton.selected = false
            oldVC = self.curVC
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
            self.timeButton.selected = false
            self.fiveButton.selected = true
            self.kLineButton.selected = false
            self.weekButton.selected = false
            self.monthButton.selected = false
            self.lineView!.center.x = self.fiveButton.center.x
            self.lineView?.y = self.topView.height - 2
            oldVC = self.curVC
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
            self.timeButton.selected = false
            self.fiveButton.selected = false
            self.kLineButton.selected = true
            self.weekButton.selected = false
            self.monthButton.selected = false
            self.lineView?.center.x = self.kLineButton.center.x
            self.lineView?.y = self.topView.height - 2
            oldVC = self.curVC
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
            self.timeButton.selected = false
            self.fiveButton.selected = false
            self.kLineButton.selected = false
            self.weekButton.selected = true
            self.monthButton.selected = false
            self.lineView?.center.x = self.weekButton.center.x
            self.lineView?.y = self.topView.height - 2
            oldVC = self.curVC
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
            self.timeButton.selected = false
            self.fiveButton.selected = false
            self.kLineButton.selected = false
            self.weekButton.selected = false
            self.monthButton.selected = true
            self.lineView?.center.x = self.monthButton.center.x
            self.lineView?.y = self.topView.height - 2
            oldVC = self.curVC
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
        return true
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight
    }

}
