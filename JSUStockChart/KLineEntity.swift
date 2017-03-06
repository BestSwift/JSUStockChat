//
//  KLineEntity.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/24.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

class KLineEntity {
    var open:CGFloat = 0
    var high:CGFloat = 0
    var low:CGFloat = 0
    var close:CGFloat = 0
    var index:Int = 0
    var date:String = ""
    
    var volume:CGFloat = 0
    var ma5:CGFloat = 0
    var ma10:CGFloat = 0
    var ma20:CGFloat = 0
    var preClosePx:CGFloat = 0
    var rate:CGFloat = 0
    
    init(){
        
    }
}