//
//  KLineStockChartViewBase.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/23.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

public class KLineStockChartViewBase: StockChartBase {
    
    var delegate: KLineChartViewDelegate?
    var uperChartHeightScale:CGFloat = 1
    var xAxisHeitht:CGFloat = 0
    
    var gridBackgroundColor:UIColor = UIColor.whiteColor()
    var borderColor = UIColor(netHex: 0xe4e4e4, alpha: 1)
    var borderWidth : CGFloat = 0
    
    var maxPrice = CGFloat.min
    var minPrice = CGFloat.max
    var maxRatio = CGFloat.min
    var minRatio = CGFloat.max
    var maxVolume = CGFloat.min
    var candleCoordsScale : CGFloat = 0
    var volumeCoordsScale : CGFloat = 0
    
    var highlightLineCurrentIndex : Int = 0
    var highlightLineCurrentPoint : CGPoint = CGPointZero
    var highlightLineCurrentEnabled = false
    var drawLabelPriceInside = true  //是否把左边股价label 画在里面
    var drawLabelRatioInside = true //是否把右边涨跌幅画在里面
    var drawVolumeLabel = false  //是否画成交量Label
    var drawMidLabelPrice = false //是否画中间的股价label

    

    
    var defaultAttributedDic:[String:AnyObject]{
        get{
            return [NSFontAttributeName:UIFont.systemFontOfSize(10),NSBackgroundColorAttributeName:gridBackgroundColor]
        }
    }
    
    var leftYAxisAttributedDic:[String:AnyObject] = [NSFontAttributeName:UIFont.systemFontOfSize(9),NSBackgroundColorAttributeName:UIColor.clearColor(),NSForegroundColorAttributeName:UIColor(netHex: 0x8695a6, alpha: 1)]
    var xAxisAttributedDic = [NSFontAttributeName:UIFont.systemFontOfSize(10),NSBackgroundColorAttributeName:UIColor.clearColor(),NSForegroundColorAttributeName:UIColor(netHex: 0x8695a6, alpha: 1)]
    var highlightAttributedDic = [NSFontAttributeName:UIFont.systemFontOfSize(10),NSBackgroundColorAttributeName:UIColor(netHex: 0x8695a6, alpha: 1),NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    var highlightLineShowEnabled = true
    var scrollEnabled = false
    var zoomEnabled = false

    

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hiddenStatusView(){
        self.act.stopAnimating()
        self.statusView.hidden = true
    }
    
    func showStatusView(){
        self.statusLabel.text = "数据加载中"
        self.act.startAnimating()
        self.statusView.hidden = false
    }
    
    func showFailStatusView(){
        self.statusLabel.text = "数据加载失败"
        self.act.stopAnimating()
    }
    
    
    
    func drawGridBackground(context:CGContextRef,rect:CGRect){
        CGContextSetFillColorWithColor(context, gridBackgroundColor.CGColor);
        CGContextFillRect(context, rect);
        
        //画外面边框
        CGContextSetLineWidth(context, self.borderWidth/2);
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextStrokeRect(context, CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, (self.uperChartHeightScale * self.contentHeight)));

        self.drawline(context, startPoint: CGPointMake(self.contentLeft,self.contentInnerTop), stopPoint: CGPointMake(self.contentLeft+self.contentWidth,self.contentInnerTop), color: self.borderColor, lineWidth: self.borderWidth/2.0)
        
        self.drawline(context, startPoint: CGPointMake(self.contentLeft,self.contentInnerTop + (self.uperChartHeightScale * self.contentHeight)-self.contentInnerTop), stopPoint: CGPointMake(self.contentLeft+self.contentWidth,self.contentInnerTop + (self.uperChartHeightScale * self.contentHeight)-self.contentInnerTop), color: self.borderColor, lineWidth: self.borderWidth/2.0)
        
        //画交易量边框
        CGContextStrokeRect(context, CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, self.contentWidth, (self.contentBottom - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)));
        
        //画中间的线
        self.drawline(context, startPoint: CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop), stopPoint: CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop), color: self.borderColor, lineWidth: self.borderWidth/2.0)
        
        self.drawline(context, startPoint: CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentInnerHeight)/4.0 + self.contentInnerTop), stopPoint: CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentInnerHeight)/4.0 + self.contentInnerTop), color: self.borderColor, lineWidth: self.borderWidth/2.0)
        
        self.drawline(context, startPoint: CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentInnerHeight)*0.75 + self.contentInnerTop), stopPoint: CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentInnerHeight)*0.75 + self.contentInnerTop), color: self.borderColor, lineWidth: self.borderWidth/2.0)
    }
    
    func drawLabelPrice(context:CGContextRef){
        
        
        if !self.highlightLineCurrentEnabled{
            let maxPriceStr = self.handleStrWithPrice(self.maxPrice)
            let maxPriceAttStr = NSMutableAttributedString(string: maxPriceStr, attributes: self.leftYAxisAttributedDic)
            let sizeMaxPriceAttStr = maxPriceAttStr.size()
            var labelX = CGFloat(0)
            if drawLabelPriceInside{
                labelX = self.contentLeft
            }else{
                labelX = self.contentLeft - sizeMaxPriceAttStr.width
            }
            self.drawLabel(context, attributesText: maxPriceAttStr, rect: CGRectMake(labelX, self.contentTop, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height))
            
            if drawMidLabelPrice{
                let midPriceStr = self.handleStrWithPrice((self.maxPrice+self.minPrice)/2.0)
                let midPriceAttStr = NSMutableAttributedString(string: midPriceStr, attributes: self.leftYAxisAttributedDic)
                let sizeMidPriceAttStr = midPriceAttStr.size()
                
                if drawLabelPriceInside{
                    labelX = self.contentLeft
                }else{
                    labelX = self.contentLeft - sizeMidPriceAttStr.width
                }
                
                self.drawLabel(context, attributesText: midPriceAttStr, rect: CGRectMake(labelX, ((self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop)-sizeMidPriceAttStr.height/2.0, sizeMidPriceAttStr.width, sizeMidPriceAttStr.height))
            }
            
            
            
            let minPriceStr = self.handleStrWithPrice(self.minPrice)
            let minPriceAttStr = NSMutableAttributedString(string: minPriceStr, attributes: self.leftYAxisAttributedDic)
            let sizeMinPriceAttStr = minPriceAttStr.size()
            if drawLabelPriceInside{
                labelX = self.contentLeft
            }else{
                labelX = self.contentLeft - sizeMinPriceAttStr.width
            }
            
            self.drawLabel(context, attributesText: minPriceAttStr, rect: CGRectMake(labelX, ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinPriceAttStr.height ), sizeMinPriceAttStr.width, sizeMinPriceAttStr.height))
        }
        
        if drawVolumeLabel{
            let zeroVolumeAttStr =  NSMutableAttributedString(string: self.handleShowWithVolume(self.maxVolume), attributes: self.leftYAxisAttributedDic)
            let zeroVolumeAttStrSize = zeroVolumeAttStr.size()
            self.drawLabel(context, attributesText: zeroVolumeAttStr, rect: CGRectMake(self.contentLeft - zeroVolumeAttStrSize.width, self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height))
            
            let maxVolumeStr = self.handleShowNumWithVolume(self.maxVolume)
            let maxVolumeAttStr = NSMutableAttributedString(string: maxVolumeStr, attributes: self.leftYAxisAttributedDic)
            let maxVolumeAttStrSize = maxVolumeAttStr.size()
            self.drawLabel(context, attributesText: maxVolumeAttStr, rect: CGRectMake(self.contentLeft - maxVolumeAttStrSize.width, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height))
        }
      
        
        
    }
    
    func drawHighlighted(context:CGContextRef,point:CGPoint,idex:Int,value:AnyObject,color:UIColor,lineWidth:CGFloat){
        var leftMarkerStr = ""
        var bottomMarkerStr = ""
        var rightMarkerStr = ""
        
        if value.isKindOfClass(TimeLineEntity.self){
            let entity = value as! TimeLineEntity
            
            leftMarkerStr = self.handleStrWithPrice(entity.lastPirce)
            
            if let t = entity.currtTime{
                 bottomMarkerStr = t
            }
           
            if let r = entity.rate{
                rightMarkerStr = r.toStringWithFormat("%.2f")
            }
        }else if value.isKindOfClass(KLineEntity.self){
            let entity = value as! KLineEntity
            
                leftMarkerStr = self.handleStrWithPrice(entity.close)
            
                bottomMarkerStr = entity.date
            
                rightMarkerStr = entity.rate.toStringWithFormat("%.2f")
        }else{
            return
        }
        
//        if leftMarkerStr == "" || bottomMarkerStr == "" || rightMarkerStr == "" {
//            return
//        }
        
        bottomMarkerStr = " ".stringByAppendingString(bottomMarkerStr).stringByAppendingString(" ")
        CGContextSetStrokeColorWithColor(context,color.CGColor);
        CGContextSetLineWidth(context, lineWidth);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, point.x, self.contentTop);
        CGContextAddLineToPoint(context, point.x, self.contentBottom);
        CGContextStrokePath(context);
        
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.contentLeft, point.y);
        CGContextAddLineToPoint(context, self.contentRight, point.y);
        CGContextStrokePath(context);
        
        let radius:CGFloat = 3.0;
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius))
        
        let drawAttributes = self.highlightAttributedDic
        
        let leftMarkerStrAtt = NSMutableAttributedString(string: leftMarkerStr, attributes: drawAttributes)
        let leftMarkerStrAttSize = leftMarkerStrAtt.size()
        var labelX = CGFloat(0)
        if drawLabelPriceInside{
            labelX = self.contentLeft
        }else{
           labelX = self.contentLeft - leftMarkerStrAttSize.width
        }
        self.drawLabel(context, attributesText: leftMarkerStrAtt, rect: CGRectMake(labelX,point.y - leftMarkerStrAttSize.height/2.0, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height))
        
        let bottomMarkerStrAtt = NSMutableAttributedString(string: bottomMarkerStr, attributes: drawAttributes)
        let bottomMarkerStrAttSize = bottomMarkerStrAtt.size()
        self.drawLabel(context, attributesText: bottomMarkerStrAtt, rect: CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  ((self.uperChartHeightScale * self.contentHeight) + self.contentTop), bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height))
        
        let rightMarkerStrAtt = NSMutableAttributedString(string: rightMarkerStr, attributes: drawAttributes)
        let rightMarkerStrAttSize = rightMarkerStrAtt.size()
        
        if drawLabelRatioInside{
            labelX = self.contentRight - rightMarkerStrAttSize.width
        }else{
            labelX = self.contentRight
        }
        self.drawLabel(context, attributesText: rightMarkerStrAtt, rect: CGRectMake(labelX, point.y - rightMarkerStrAttSize.height/2.0, rightMarkerStrAttSize.width, rightMarkerStrAttSize.height))
    }
    
    func drawLabel(context:CGContextRef,attributesText:NSAttributedString,rect:CGRect){
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor);
        attributesText.drawInRect(rect)
    }
    
    func drawRect(context:CGContextRef,rect:CGRect,color:UIColor){
        if ((rect.origin.x + rect.size.width) > self.contentRight) {
            return;
        }
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
    }
    
    func drawline(context:CGContextRef,startPoint:CGPoint,stopPoint:CGPoint,color:UIColor,lineWidth:CGFloat){
        if (startPoint.x < self.contentLeft || stopPoint.x > self.contentRight || startPoint.y < self.contentTop || stopPoint.y < self.contentTop) {
            return
        }
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, lineWidth);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
        CGContextStrokePath(context);
    }
    
    func handleStrWithPrice(price:CGFloat) -> String{
        return NSString(format: "%.2f", price) as String
    }
    
    func handleRateWithPrice(price:CGFloat,originPX:CGFloat) -> String{
         return NSString(format: "%.2f",(price - originPX)/originPX * 100.00) as String
    }
    
    func handleShowWithVolume(argVolume:CGFloat) -> String{
        let volume = argVolume/100.0;
        
        if (volume < 10000.0) {
            return "手 ";
        }else if (volume > 10000.0 && volume < 100000000.0){
            return "万手 ";
        }else{
            return "亿手 ";
        }
    }
    
    func handleShowNumWithVolume(argVolume:CGFloat) -> String{
        let volume = argVolume/100.0;
        if (volume < 10000.0) {
            return NSString(format: "%.0f", volume) as String
        }else if (volume > 10000.0 && volume < 100000000.0){
            return NSString(format: "%.2f", volume/10000.0) as String
        }else{
            return NSString(format: "%.2f", volume/100000000.0) as String
        }
    }
    

    
    func getHighlightByTouchPoint(point:CGPoint){
        
    }
    
    func handleTapGestureAction(recognizer:UITapGestureRecognizer){
        if self.highlightLineCurrentEnabled{
            self.highlightLineCurrentEnabled = false
        }
        
        self.setNeedsDisplay()
    }
    
    
}