//
//  CSFPortfStockKLineViewController.swift
//  csfsamradar
//
//  Created by 苏小超 on 16/3/1.
//  Copyright © 2016年 vsto. All rights reserved.
//

import UIKit

class JSUKLineViewController: UIViewController,KLineChartViewDelegate {
    
    @IBOutlet weak var kLineView:KLineStockChartView!
    
    var isLandScape = false
    
    var dataSource : [JSUKLineModel]?
    
    var tick : String?
    
    func loadData(){

        let model:JSUKLineMessage = readFile("kLineData", ext: "json")
        self.setupKLineView(model.message!)

    }
    
    func setupKLineView(data:[JSUKLineModel]){
        var array = [KLineEntity]()
        
        for (index,dic) in data.enumerate(){
            let entity = KLineEntity()
            if let h = dic.high{
                entity.high = CGFloat(h)
            }
            
            if let o = dic.open{
                entity.open = CGFloat(o)
                if index == 0{
                    entity.preClosePx = CGFloat(o)
                }else{
                    if let c = data[index-1].close{
                        entity.preClosePx = CGFloat(c)
                    }else{
                        entity.preClosePx = CGFloat(o)
                    }
                    
                }
            }
            
            if let l = dic.low{
                entity.low = CGFloat(l)
            }
            
            if let c = dic.close{
                entity.close = CGFloat(c)
            }
            
            if let r = dic.inc{
                entity.rate = CGFloat(r)
            }
            
            if let d = dic.dt{
                entity.date = d
            }
            
            if let ma5 = dic.ma?.MA5{
                entity.ma5 = CGFloat(ma5)
            }
            
            if let ma10 = dic.ma?.MA10{
                entity.ma10 = CGFloat(ma10)
            }
            
            if let ma20 = dic.ma?.MA20{
                entity.ma20 = CGFloat(ma20)
            }
            
            if let v = dic.vol{
                entity.volume = CGFloat(v)
            }
            
            
            
            
            array.append(entity)
        }
        
        let dataSet = KLineDataSet()
        dataSet.data = array
        dataSet.highlightLineColor = UIColor(netHex: 0x546679, alpha: 1)
        self.kLineView.setupData(dataSet)
    }
    
    func chartKlineScrollLeft(chartView: StockChartBase) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kLineView.userInteractionEnabled = true
        self.kLineView.setupChartOffsetWithLeft(16,top:10,right:16,bottom:10)
        self.kLineView.gridBackgroundColor = UIColor.whiteColor()
        self.kLineView.borderColor = UIColor(red: 203/255.0, green: 215/255.0, blue: 224/255.0, alpha: 1)
        self.kLineView.borderWidth = 0.5;
        self.kLineView.candleWidth = 8;
        self.kLineView.candleMaxWidth = 30;
        self.kLineView.candleMinWidth = 1;
        self.kLineView.uperChartHeightScale = 0.7;
        self.kLineView.xAxisHeitht = 25;
        self.kLineView.delegate = self
        self.kLineView.highlightLineShowEnabled = true;
        
        if isLandScape {
            self.kLineView.zoomEnabled = true;
            self.kLineView.scrollEnabled = true;
        }else{
            self.kLineView.zoomEnabled = false;
            self.kLineView.scrollEnabled = false;
        }
        
        self.kLineView.commonInit()
        
        
    }
    
    //Because use autolayout,so must loadData in viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        self.loadData()
    }
    
}
