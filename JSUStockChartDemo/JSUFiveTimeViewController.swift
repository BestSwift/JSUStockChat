//
//  CSFPortfStockFiveTimeViewController.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/3/3.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit

class JSUFiveTimeViewController: UIViewController {
    
    @IBOutlet weak var timeView:TimeLineStockChartView!
    var dataSource : JSUPriceModel?
    var tick : String?
    var timer : NSTimer?
    var isLandScape = false
    
    func loadData(){
        
        let model:JSUPriceModel = readFile("fiveLineData", ext: "json")
        self.setupTimeLineView(model)
        
//        if let t = tick{
//            csfRequest(.GET, CSFURLServerMarket, CSFURLCompanyPrice, parameters: ["code":t,"freq":"w"], encoding: nil, headers: nil, success: { (statusCode, data, model:CSFBaseModel<CSFOptionalCompanyPriceModel>?) -> Void in
//                if let m = model?.message{
//                    self.dataSource = m
//                    self.setupTimeLineView(m)
//                }
//                
//                }) { (statusCode, message) -> Void in
//                    self.timeView.showFailStatusView()
//            }
//        }
    }
    
    func setupTimeLineView(data:JSUPriceModel){
        var timeArray = [TimeLineEntity]()
        var lastVolume = CGFloat(0)
        var preClose = data.close
        var days = [String]()
        if let d = data.days{
            for day in d{
                let date = day.toDate("yyyy-MM-dd")?.toString("MM-dd")
                days.append(date!)
            }
        }
        
        if let shares = data.shares{
            var lastAvg = CGFloat(0)
            for  (index,dic) in shares.enumerate(){
                let entity = TimeLineEntity()
                entity.currtTime = dic.dt?.toString("HH:mm")
                if let c = data.close{
                    entity.preClosePx = CGFloat(c)
                }
                
                if let p = dic.price{
                    entity.lastPirce = CGFloat(p)
                    if index == 0{
                        lastAvg = entity.lastPirce
                    }
                    
                    //涨跌幅
                    if let c = preClose{
                        entity.rate = (CGFloat(p/c)-1)*100
                    }
                }
                
                if let v = dic.volume{
                    entity.volume = CGFloat(v) - lastVolume
                    lastVolume = CGFloat(v)
                    if let a = dic.amount{
                        //均线
                        entity.avgPirce = CGFloat(a/v)
                    }
                }
             
                
                if isnan(entity.avgPirce) {
                    entity.avgPirce = lastAvg
                }else{
                    lastAvg = entity.avgPirce
                }
                
                timeArray.append(entity)
            }
        }
        
        
        
        
        let set  = TimeDataset()
        set.data = timeArray;
        set.days = days
        set.avgLineCorlor = UIColor(netHex: 0xffc004, alpha: 1)
        set.priceLineCorlor = UIColor(netHex: 0x0095ff, alpha: 1)
        set.lineWidth = 1;
        set.highlightLineWidth = 0.8
        set.highlightLineColor = UIColor(netHex: 0x546679, alpha: 1)
        
        
        
        set.volumeTieColor = UIColor(netHex: 0xaaaaaa, alpha: 1)
        set.volumeRiseColor = UIColor(netHex: 0xf24957, alpha: 1)
        set.volumeFallColor = UIColor(netHex: 0x1dbf60, alpha: 1)
        
        set.fillStartColor = UIColor(netHex: 0xe3efff, alpha: 1)
        set.fillStopColor = UIColor(netHex: 0xe3efff, alpha: 1)
        set.fillAlpha = 0.5
        set.drawFilledEnabled = true
        //self.timeLineView.delegate = self;
        self.timeView.countOfTimes = 405
        self.timeView.highlightLineShowEnabled = true;
        self.timeView.endPointShowEnabled = NSDate().isTradingTime();
        self.timeView.setupData(set)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.timeView.setupChartOffsetWithLeft(16,top:10,right:16,bottom:10)
        self.timeView.showFiveDayLabel = true
        self.timeView.gridBackgroundColor = UIColor.whiteColor()
        self.timeView.borderColor = UIColor(netHex: 0xe4e4e4, alpha: 1)
        self.timeView.borderWidth = 0.5;
        self.timeView.uperChartHeightScale = 0.7;
        self.timeView.xAxisHeitht = 25;

        loadData()
        
    }
    

    
    
}
