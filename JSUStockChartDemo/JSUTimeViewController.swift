//
//  JSUTimeViewController.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/2/26.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit
import ObjectMapper

let kRedColor = UIColor(netHex: 0xf24957,alpha: 1)  //红色
let kGreenColor = UIColor(netHex:0x1dbf60,alpha: 1) //绿色
let kGrayColor = UIColor(netHex: 0xaaaaaa,alpha: 1) //灰色

class JSUTimeViewController: UIViewController {

    @IBOutlet weak var timeView:TimeLineStockChartView!
    @IBOutlet weak var sell1Price:UILabel!
    @IBOutlet weak var sell2Price:UILabel!
    @IBOutlet weak var sell3Price:UILabel!
    @IBOutlet weak var sell4Price:UILabel!
    @IBOutlet weak var sell5Price:UILabel!
    @IBOutlet weak var sell1Count:UILabel!
    @IBOutlet weak var sell2Count:UILabel!
    @IBOutlet weak var sell3Count:UILabel!
    @IBOutlet weak var sell4Count:UILabel!
    @IBOutlet weak var sell5Count:UILabel!
    
    @IBOutlet weak var buy1Price:UILabel!
    @IBOutlet weak var buy2Price:UILabel!
    @IBOutlet weak var buy3Price:UILabel!
    @IBOutlet weak var buy4Price:UILabel!
    @IBOutlet weak var buy5Price:UILabel!
    @IBOutlet weak var buy1Count:UILabel!
    @IBOutlet weak var buy2Count:UILabel!
    @IBOutlet weak var buy3Count:UILabel!
    @IBOutlet weak var buy4Count:UILabel!
    @IBOutlet weak var buy5Count:UILabel!
    
    var isLandScape = false
    var dataSource : JSUPriceModel?
    var tradeSource : JSUTradeModel?
    var code : String?
    var tick : String?
    var openPrice : Double?
    var timer:NSTimer?
    
    func loadData(){
        //get priceData
        let model:JSUPriceModel = readFile("timeLineData", ext: "json")
        self.setupTimeLineView(model)
        
        //get tradeData
        let state:JSUTradeModel = readFile("timeStateData", ext: "json")
        self.setupTradeView(state)
    }
    
    func setupTradeView(data:JSUTradeModel){
        if let bp = data.bp1{
            self.buy1Price.text = bp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where bp.toDouble() >= o{
                self.buy1Price.textColor = kRedColor
            }else{
                self.buy1Price.textColor = kGreenColor
            }
        }
        if let bp = data.bp2{
            self.buy2Price.text = bp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where bp.toDouble() >= o{
                self.buy2Price.textColor = kRedColor
            }else{
                self.buy2Price.textColor = kGreenColor
            }

        }
        if let bp = data.bp3{
            self.buy3Price.text = bp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where bp.toDouble() >= o{
                self.buy3Price.textColor = kRedColor
            }else{
                self.buy3Price.textColor = kGreenColor
            }
        }
        if let bp = data.bp4{
            self.buy4Price.text = bp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where bp.toDouble() >= o{
                self.buy4Price.textColor = kRedColor
            }else{
                self.buy4Price.textColor = kGreenColor
            }
        }
        if let bp = data.bp5{
            self.buy5Price.text = bp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where bp.toDouble() >= o{
                self.buy5Price.textColor = kRedColor
            }else{
                self.buy5Price.textColor = kGreenColor
            }
        }
        
        if let bc = data.bc1{
            self.buy1Count.text = "\(bc.toInt()/100)"
        }
        if let bc = data.bc2{
            self.buy2Count.text = "\(bc.toInt()/100)"
        }
        if let bc = data.bc3{
            self.buy3Count.text = "\(bc.toInt()/100)"
        }
        if let bc = data.bc4{
            self.buy4Count.text = "\(bc.toInt()/100)"
        }
        if let bc = data.bc5{
            self.buy5Count.text = "\(bc.toInt()/100)"
        }
        
        if let sp = data.sp1{
            self.sell1Price.text = sp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where sp.toDouble() >= o{
                self.sell1Price.textColor = kRedColor
            }else{
                self.sell1Price.textColor = kGreenColor
            }
        }
        if let sp = data.sp2{
            self.sell2Price.text = sp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where sp.toDouble() >= o{
                self.sell2Price.textColor = kRedColor
            }else{
                self.sell2Price.textColor = kGreenColor
            }
        }
        if let sp = data.sp3{
            self.sell3Price.text = sp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where sp.toDouble() >= o{
                self.sell3Price.textColor = kRedColor
            }else{
                self.sell3Price.textColor = kGreenColor
            }
        }
        if let sp = data.sp4{
            self.sell4Price.text = sp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where sp.toDouble() >= o{
                self.sell4Price.textColor = kRedColor
            }else{
                self.sell4Price.textColor = kGreenColor
            }
        }
        if let sp = data.sp5{
            self.sell5Price.text = sp.toDouble().toStringWithFormat("%.2f")
            if let o = self.openPrice where sp.toDouble() >= o{
                self.sell5Price.textColor = kRedColor
            }else{
                self.sell5Price.textColor = kGreenColor
            }
        }
        
        if let sc = data.sc1{
            self.sell1Count.text = "\(sc.toInt()/100)"
        }
        
        if let sc = data.sc2{
            self.sell2Count.text = "\(sc.toInt()/100)"
        }
        
        if let sc = data.sc3{
            self.sell3Count.text = "\(sc.toInt()/100)"
        }
        
        if let sc = data.sc4{
            self.sell4Count.text = "\(sc.toInt()/100)"
        }
        
        if let sc = data.sc5{
            self.sell5Count.text = "\(sc.toInt()/100)"
        }
        
        
    }
    
    func setupTimeLineView(data:JSUPriceModel){
        var timeArray = [TimeLineEntity]()
        var lastVolume = CGFloat(0)
        
        if let shares = data.shares{
            var lastAvg = CGFloat(0)
            for dic in shares{
                let entity = TimeLineEntity()
                entity.currtTime = dic.dt?.toString("HH:mm")
                if let c = data.close{
                    entity.preClosePx = CGFloat(c)
                }
                
                if let p = dic.price{
                    entity.lastPirce = CGFloat(p)
                }
                
                if let v = dic.volume{
                    entity.volume = CGFloat(v) - lastVolume
                    lastVolume = CGFloat(v)
                    
                    if let a = dic.amount{
                        //均线
                        entity.avgPirce = CGFloat(a/v)
                    }
                }
                
                if isnan(entity.avgPirce){
                    entity.avgPirce = lastAvg
                }else{
                    lastAvg = entity.avgPirce
                }
                
                //涨跌幅
                if let r = dic.ratio{
                   entity.rate = CGFloat(r)
                }
                timeArray.append(entity)
            }
        }

        let set  = TimeDataset()
        set.data = timeArray;
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
        self.timeView.highlightLineShowEnabled = true;
        self.timeView.endPointShowEnabled = true //是否显示呼吸灯
        self.timeView.setupData(set)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sell1Count.adjustsFontSizeToFitWidth = true
        self.sell2Count.adjustsFontSizeToFitWidth = true
        self.sell3Count.adjustsFontSizeToFitWidth = true
        self.sell4Count.adjustsFontSizeToFitWidth = true
        self.sell5Count.adjustsFontSizeToFitWidth = true
        
        self.buy1Count.adjustsFontSizeToFitWidth = true
        self.buy2Count.adjustsFontSizeToFitWidth = true
        self.buy3Count.adjustsFontSizeToFitWidth = true
        self.buy4Count.adjustsFontSizeToFitWidth = true
        self.buy5Count.adjustsFontSizeToFitWidth = true
        
        self.sell1Price.adjustsFontSizeToFitWidth = true
        self.sell2Price.adjustsFontSizeToFitWidth = true
        self.sell3Price.adjustsFontSizeToFitWidth = true
        self.sell4Price.adjustsFontSizeToFitWidth = true
        self.sell5Price.adjustsFontSizeToFitWidth = true
        
        self.buy1Price.adjustsFontSizeToFitWidth = true
        self.buy2Price.adjustsFontSizeToFitWidth = true
        self.buy3Price.adjustsFontSizeToFitWidth = true
        self.buy4Price.adjustsFontSizeToFitWidth = true
        self.buy5Price.adjustsFontSizeToFitWidth = true
        
        if isLandScape{
            self.timeView.setupChartOffsetWithLeft(40,top:10,right:40,bottom:10)
            self.timeView.drawLabelPriceInside = false
            self.timeView.drawLabelRatioInside = false
            self.timeView.drawMidLabelPrice = true
        }else{
            self.timeView.setupChartOffsetWithLeft(16,top:10,right:16,bottom:10)
            self.timeView.drawLabelPriceInside = true
            self.timeView.drawLabelRatioInside = true
        }
        
        
       
        self.timeView.gridBackgroundColor = UIColor.whiteColor()
        self.timeView.borderColor = UIColor(netHex: 0xe4e4e4, alpha: 1)
        self.timeView.borderWidth = 0.5
        self.timeView.uperChartHeightScale = 0.7;
        self.timeView.xAxisHeitht = 25
        self.timeView.countOfTimes = 242


        loadData()
        
       

    }
    
   


}
