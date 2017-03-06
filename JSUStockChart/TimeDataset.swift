//
//  KTimeDataset.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/24.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

class TimeDataset{
    var days : [String]?  //五日图的日期
    var data : [TimeLineEntity]?
    var highlightLineWidth : CGFloat = 0
    var highlightLineColor = UIColor.blueColor()
    var lineWidth : CGFloat = 1
    var priceLineCorlor = UIColor.grayColor()
    var avgLineCorlor = UIColor.yellowColor()
    var volumeRiseColor = UIColor.redColor()
    var volumeFallColor = UIColor.greenColor()
    var volumeTieColor = UIColor.grayColor()
    var drawFilledEnabled = false
    var fillStartColor = UIColor.orangeColor()
    var fillStopColor = UIColor.blackColor()
    var fillAlpha:CGFloat = 0.5
}
