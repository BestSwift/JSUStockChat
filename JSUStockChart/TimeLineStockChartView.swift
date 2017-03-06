//
//  TimeLineStockChartView.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/25.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

public class TimeLineStockChartView:KLineStockChartViewBase{

    ///是否画均线
    var drawAvgLine = true
    var countOfTimes = 0
    var endPointShowEnabled = false
    var offsetMaxPrice : CGFloat = 0
    var showFiveDayLabel = false
    var volumeWidth : CGFloat {
        return self.contentWidth/CGFloat(self.countOfTimes)
    }
    var dataSet : TimeDataset?
    var longPressGesture : UILongPressGestureRecognizer{
        return UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureAction(_:)))
    }
    var tapGesture : UITapGestureRecognizer{
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction(_:)))
    }
    var _breathingPoint : CALayer?
    var breathingPoint : CALayer{
        if let b = _breathingPoint{
            return b
        }
        
        _breathingPoint = CALayer()
        self.layer.addSublayer(_breathingPoint!)
        _breathingPoint!.backgroundColor = self.dataSet!.priceLineCorlor.CGColor
        _breathingPoint!.cornerRadius = 2;
        
        let opacityLayer = CALayer()
        opacityLayer.frame = CGRectMake(0, 0, 4, 4)
        opacityLayer.backgroundColor = self.dataSet!.priceLineCorlor.CGColor
        opacityLayer.cornerRadius = 2;
        opacityLayer.addAnimation(self.breathingLight(2),forKey:"breathingPoint")
        _breathingPoint?.addSublayer(opacityLayer)
        
        return _breathingPoint!
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    

    
    func commonInit(){
        self.candleCoordsScale = 0
        self.addGestureRecognizer(longPressGesture)
        self.act.startAnimating()
        
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let d = self.dataSet?.data where d.count > 0{
            self.setCurrentDataMaxAndMin()
            let context = UIGraphicsGetCurrentContext();
            self.drawGridBackground(context!,rect:rect)
            self.drawLabelPrice(context!)
            self.drawLabelRatio(context!)
            self.drawTimeLabel(context!)
            self.drawTimeLine(context!)
        } 
    }
    
    func setupData(dataSet:TimeDataset){
        if let d = dataSet.data where d.count > 0{
            self.hiddenStatusView()
            self.dataSet = dataSet
            self.notifyDataSetChanged()
        }else{
            self.showFailStatusView()
        }
    }
    
    func drawLabelRatio(context:CGContextRef){
        
        let maxRatioStr = self.handleStrWithPrice(self.maxRatio) + "%"
        let maxRatioAttStr = NSMutableAttributedString(string: maxRatioStr, attributes: self.leftYAxisAttributedDic)
        let sizeMaxRatioAttStr = maxRatioAttStr.size()
        var labelX = CGFloat(0)
        if drawLabelRatioInside{
            labelX = self.contentRight - sizeMaxRatioAttStr.width
        }else{
            labelX = self.contentRight
        }
        
        self.drawLabel(context, attributesText: maxRatioAttStr, rect: CGRectMake(labelX, self.contentTop, sizeMaxRatioAttStr.width, sizeMaxRatioAttStr.height))
        
        
        
        let minRatioStr = self.handleStrWithPrice(self.minRatio) + "%"
        let minRatioAttStr = NSMutableAttributedString(string: minRatioStr, attributes: self.leftYAxisAttributedDic)
        let sizeMinRatioAttStr = minRatioAttStr.size()
        if drawLabelRatioInside{
            labelX = self.contentRight - sizeMinRatioAttStr.width
        }else{
            labelX = self.contentRight
        }
        
        self.drawLabel(context, attributesText: minRatioAttStr, rect: CGRectMake(labelX, ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinRatioAttStr.height ), sizeMinRatioAttStr.width, sizeMinRatioAttStr.height))
    }
    
    func setCurrentDataMaxAndMin(){
        if let data = self.dataSet?.data where data.count > 0{
            self.maxPrice = -9999
            self.minPrice = 9999
            self.maxRatio = -9999
            self.minRatio = 9999
            self.maxVolume = 0
            self.offsetMaxPrice = -9999
            
            for i in 0 ..< data.count {
                let entity = data[i]
                self.offsetMaxPrice = self.offsetMaxPrice > fabs(entity.lastPirce - entity.preClosePx) ? self.offsetMaxPrice:fabs(entity.lastPirce-entity.preClosePx)
                self.maxVolume = self.maxVolume > entity.volume ? self.maxVolume : entity.volume
                
                if let r = entity.rate{
                    self.maxRatio = self.maxRatio > fabs(r) ? self.maxRatio : r
                    self.minRatio = self.minRatio < fabs(r) ? self.minRatio : r
                }
                
              
            }
            
            self.maxPrice = data.first!.preClosePx + self.offsetMaxPrice
            self.minPrice = data.first!.preClosePx - self.offsetMaxPrice
            
            if self.minPrice >= self.maxPrice{
                
                self.maxPrice = self.maxPrice * 1.02
                self.minPrice = self.minPrice * 0.98
                
            }
            
            for i in 0 ..< data.count {
                let entity = data[i]
                entity.avgPirce = entity.avgPirce < self.minPrice ? self.minPrice : entity.avgPirce
                entity.avgPirce = entity.avgPirce > self.maxPrice ? self.maxPrice : entity.avgPirce
            }
        }
    }
    
    
    override func drawGridBackground(context:CGContextRef,rect:CGRect){
        super.drawGridBackground(context, rect: rect)
        self.drawline(context, startPoint: CGPointMake(self.contentWidth/2.0 + self.contentLeft, self.contentTop), stopPoint: CGPointMake(self.contentWidth/2.0 + self.contentLeft,(self.uperChartHeightScale * self.contentHeight)+self.contentTop), color: self.borderColor , lineWidth: self.borderWidth/2.0)
    }
    
    func drawTimeLabel(context:CGContextRef){
        
        if !self.highlightLineCurrentEnabled{
            
            if let d = self.dataSet?.days where showFiveDayLabel{
                
                let width = self.contentWidth / 5
                for (index,day) in d.enumerate(){
                    let drawAttributes = self.xAxisAttributedDic
                    let startTimeAttStr = NSMutableAttributedString(string: day, attributes: drawAttributes)
                    let sizeStartTimeAttStr = startTimeAttStr.size()
                    self.drawLabel(context, attributesText: startTimeAttStr, rect: CGRectMake(self.contentLeft + (width - sizeStartTimeAttStr.width) / 2 + width * CGFloat(index), (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeStartTimeAttStr.width, sizeStartTimeAttStr.height))
                }
                
                
                
                

            }else{
                let drawAttributes = self.xAxisAttributedDic
                let startTimeAttStr = NSMutableAttributedString(string: "9:30", attributes: drawAttributes)
                let sizeStartTimeAttStr = startTimeAttStr.size()
                self.drawLabel(context, attributesText: startTimeAttStr, rect: CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeStartTimeAttStr.width, sizeStartTimeAttStr.height))
                
                let midTimeAttStr = NSMutableAttributedString(string: "11:30/13:00", attributes: drawAttributes)
                let sizeMidTimeAttStr = midTimeAttStr.size()
                self.drawLabel(context, attributesText: midTimeAttStr, rect: CGRectMake(self.contentWidth/2.0 + self.contentLeft - sizeMidTimeAttStr.width/2.0, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeMidTimeAttStr.width, sizeMidTimeAttStr.height))
                
                let stopTimeAttStr = NSMutableAttributedString(string: "15:00", attributes: drawAttributes)
                let sizeStopTimeAttStr = stopTimeAttStr.size()
                self.drawLabel(context, attributesText: stopTimeAttStr, rect: CGRectMake(self.contentRight - sizeStopTimeAttStr.width, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeStopTimeAttStr.width, sizeStopTimeAttStr.height))
            }
           
        }
       
        
        
    }
    
    
    func drawTimeLine(context:CGContextRef){
        CGContextSaveGState(context);

        self.candleCoordsScale = (self.uperChartHeightScale * self.contentInnerHeight)/(self.maxPrice-self.minPrice);
        self.volumeCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxVolume - 0);
        
        let fillPath = CGPathCreateMutable();
        
        if let data = self.dataSet?.data where data.count > 0{
            for i in 0 ..< data.count {
                let entity = data[i]
                let left = (self.volumeWidth * CGFloat(i) + self.contentLeft) + self.volumeWidth / 6.0;
                
                let candleWidth = self.volumeWidth - self.volumeWidth / 6.0;
                let startX = left + candleWidth/2.0
                var yPrice:CGFloat = 0;
                
                var color = self.dataSet!.volumeRiseColor
                
                if i > 0 {
                    let lastEntity = data[i-1]
                    let lastX:CGFloat = startX - self.volumeWidth
                    let lastYPrice = (self.maxPrice - lastEntity.lastPirce) * self.candleCoordsScale + self.contentInnerTop
                    yPrice = (self.maxPrice - entity.lastPirce) * self.candleCoordsScale + self.contentInnerTop
                    //画分时线
                    self.drawline(context, startPoint: CGPointMake(lastX, lastYPrice), stopPoint: CGPointMake(startX,yPrice), color: self.dataSet!.priceLineCorlor, lineWidth: self.dataSet!.lineWidth)
                    
                    
                    if drawAvgLine {
                        //画均线
                        let lastYAvg = (self.maxPrice - lastEntity.avgPirce)*self.candleCoordsScale  + self.contentInnerTop;
                        let yAvg = (self.maxPrice - entity.avgPirce)*self.candleCoordsScale  + self.contentInnerTop;
                        
                        self.drawline(context, startPoint: CGPointMake(lastX, lastYAvg), stopPoint: CGPointMake(startX, yAvg), color: self.dataSet!.avgLineCorlor, lineWidth: self.dataSet!.lineWidth)
                    }
                  
                    
                    
                    if (entity.lastPirce > lastEntity.lastPirce) {
                        color = self.dataSet!.volumeRiseColor;
                    }else if (entity.lastPirce < lastEntity.lastPirce){
                        color = self.dataSet!.volumeFallColor;
                    }else{
                        color = self.dataSet!.volumeTieColor;
                    }
                    
                    if (1 == i) {
                        CGPathMoveToPoint(fillPath, nil, self.contentLeft, (self.uperChartHeightScale * self.contentHeight) + self.contentInnerTop / 2 );
                        CGPathAddLineToPoint(fillPath, nil, self.contentLeft,lastYPrice);
                        CGPathAddLineToPoint(fillPath, nil, lastX, lastYPrice);
                    }else{
                        CGPathAddLineToPoint(fillPath, nil, startX, yPrice);
                    }
                    if ((data.count - 1) == i) {
                        CGPathAddLineToPoint(fillPath, nil, startX, yPrice);
                        CGPathAddLineToPoint(fillPath, nil, startX, (self.uperChartHeightScale * self.contentHeight) + self.contentInnerTop / 2);
                        CGPathCloseSubpath(fillPath);
                    }
                }
                
                //成交量
                let volume = ((entity.volume - 0) * self.volumeCoordsScale);
                self.drawRect(context, rect: CGRectMake(left, self.contentBottom - volume , candleWidth, volume), color: color)
                
                //十字线
                if (self.highlightLineCurrentEnabled) {
                    if (i == self.highlightLineCurrentIndex) {
                        if (i == 0) {
                            yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale  + self.contentTop;
                        }
                        
                        self.drawHighlighted(context, point: CGPointMake(startX, yPrice), idex: i, value:entity, color: self.dataSet!.highlightLineColor, lineWidth: self.dataSet!.highlightLineWidth)
                        
                        if self.delegate != nil{
                            self.delegate?.chartValueSelected!(self, entry: entity, entryIndex: i)
                        }
                    }
                }
                
                if (self.endPointShowEnabled) {
                    if (i == data.count - 1) {
                        self.breathingPoint.frame = CGRectMake(startX-4/2, yPrice-4/2,4,4);
                    }
                }

            }
            
            if (self.dataSet!.drawFilledEnabled && data.count > 0) {
                self.drawLinearGradient(context, path: fillPath, alpha: self.dataSet!.fillAlpha, startColor: self.dataSet!.fillStartColor.CGColor, endColor: self.dataSet!.fillStopColor.CGColor)
            }
            
            CGContextRestoreGState(context);
        }
    }
    
    func drawLinearGradient(context:CGContextRef,path:CGPathRef,alpha:CGFloat,startColor:CGColorRef,endColor:CGColorRef){
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        
        let colors = [startColor,endColor]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    
        
        let pathRect = CGPathGetBoundingBox(path);
        
        //具体方向可根据需求修改
        let startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
        let endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
        
        CGContextSaveGState(context);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGContextSetAlpha(context, self.dataSet!.fillAlpha)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions.DrawsBeforeStartLocation)
        CGContextRestoreGState(context)
    }
    
    func handleLongPressGestureAction(recognizer:UIPanGestureRecognizer){
        if !self.highlightLineShowEnabled{
            return
        }
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            let  point = recognizer.locationInView(self)
            
            if (point.x > self.contentLeft && point.x < self.contentRight && point.y > self.contentTop && point.y<self.contentBottom) {
                self.highlightLineCurrentEnabled = true;
                self.getHighlightByTouchPoint(point)
                
            }
            if self.highlightLineCurrentIndex < self.dataSet?.data?.count{
                NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationTimeLineLongPress, object: self.dataSet?.data?[self.highlightLineCurrentIndex])
                NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationLandTimeLineLongPress, object: self.dataSet?.data?[self.highlightLineCurrentIndex])
            }
            
        }
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            self.highlightLineCurrentEnabled = false
            self.setNeedsDisplay()
            NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationKLineLongUnPress, object: nil)
            if self.highlightLineCurrentIndex < self.dataSet?.data?.count{
            NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationLandKLineLongUnPress, object: self.dataSet?.data?[self.highlightLineCurrentIndex])
            }
        }
        if (recognizer.state == UIGestureRecognizerState.Changed) {
            
            let  point = recognizer.locationInView(self)
            
            if (point.x > self.contentLeft && point.x < self.contentRight && point.y > self.contentTop && point.y<self.contentBottom) {
                self.highlightLineCurrentEnabled = true;
                self.getHighlightByTouchPoint(point)
               
                
            }
            
            if self.highlightLineCurrentIndex < self.dataSet?.data?.count{
                NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationTimeLineLongPress, object: self.dataSet?.data?[self.highlightLineCurrentIndex])
                NSNotificationCenter.defaultCenter().postNotificationName(JSUNotificationLandTimeLineLongPress, object: self.dataSet?.data?[self.highlightLineCurrentIndex])
            }
            
            
        }
    }
    
    override func handleTapGestureAction(recognizer:UITapGestureRecognizer){
        super.handleTapGestureAction(recognizer)
    }
    
    override func getHighlightByTouchPoint(point: CGPoint) {
        self.highlightLineCurrentIndex = Int((point.x - self.contentLeft)/self.volumeWidth);
        self.setNeedsDisplay()
    }
    
    override func notifyDataSetChanged() {
        super.notifyDataSetChanged()
        self.setNeedsDisplay()
    }
    
    override func notifyDeviceOrientationChanged() {
        super.notifyDeviceOrientationChanged()
    }
    
    func breathingLight(time:Double)->CAAnimationGroup{
 
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 3
        scaleAnimation.autoreverses = false
        scaleAnimation.removedOnCompletion = true;
        scaleAnimation.repeatCount = MAXFLOAT
        scaleAnimation.duration = time
        
        let opacityAnimation = CABasicAnimation(keyPath:"opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0
        opacityAnimation.autoreverses = false;
        opacityAnimation.duration = time
        opacityAnimation.repeatCount = MAXFLOAT;
        opacityAnimation.removedOnCompletion = true;
        opacityAnimation.fillMode = kCAFillModeForwards;
        
        let group = CAAnimationGroup()
        group.duration = time
        group.autoreverses = false
        group.removedOnCompletion = true
        group.fillMode = kCAFillModeForwards
        group.animations = [scaleAnimation,opacityAnimation]
        group.repeatCount = MAXFLOAT
        
        return group
    }
}
