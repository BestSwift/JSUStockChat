//
//  KLineDataSet.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/24.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

class KLineDataSet{
    var data : [KLineEntity]?
    var highlightLineWidth :CGFloat = 1
    
    var highlightLineColor = UIColor(netHex: 0x546679, alpha: 1)
    var candleRiseColor = UIColor(netHex: 0xf24957, alpha: 1)
    var candleFallColor = UIColor(netHex: 0x1dbf60, alpha: 1)
    var avgMA5Color = UIColor(netHex: 0xe8de85, alpha: 1)
    var avgMA10Color = UIColor(netHex: 0x6fa8bb, alpha: 1)
    var avgMA20Color = UIColor(netHex: 0xdf8fc6, alpha: 1)
    var avgLineWidth : CGFloat = 1
    var candleTopBottmLineWidth : CGFloat = 1
    
    init(){
        
    }
}
