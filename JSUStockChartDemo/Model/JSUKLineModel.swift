//
//  JSUKLineModel.swift
//  JSUStockChartDemo
//
//  Created by 苏小超 on 16/7/4.
//  Copyright © 2016年 com.jason.su. All rights reserved.
//

import Foundation
import ObjectMapper


public class JSUKLineMessage:Mappable{
    public var message : [JSUKLineModel]?
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        message <- map["message"]
    }
}

public class JSUKLineModel: Mappable {
    public var dt:String?
    public var tick:String?
    public var open:Double?
    public var close:Double?
    public var high:Double?
    public var low:Double?
    public var inc:Double?
    public var vol:Double?
    
    public var ma:JSUMAModel?
    

    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        dt <- map["dt"]
        tick <- map["tick"]
        open <- map["open"]
        close <- map["close"]
        high <- map["high"]
        low <- map["low"]
        inc <- map["inc"]
        vol <- map["vol"]
        ma <- map["ma"]
        
    }
}

public class JSUMAModel:Mappable{
    public var MA5:Double?
    public var MA10:Double?
    public var MA20:Double?
    
    public init(){
        
    }
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        MA5 <- map["MA5"]
        MA10 <- map["MA10"]
        MA20 <- map["MA20"]
    }
}
