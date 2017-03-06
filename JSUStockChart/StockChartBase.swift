//
//  StockChartBase.swift
//  StockChart
//
//  Created by 苏小超 on 16/2/23.
//  Copyright © 2016年 com.jason. All rights reserved.
//

import UIKit

let JSUNotificationKLineLongPress = "JSUNotificationKLineLongPress"
let JSUNotificationLandKLineLongPress = "JSUNotificationLandKLineLongPress"
let JSUNotificationKLineLongUnPress = "JSUNotificationKLineLongUnPress"
let JSUNotificationLandKLineLongUnPress = "JSUNotificationLandKLineLongUnPress"

let JSUNotificationTimeLineLongPress = "JSUNotificationTimeLineLongPress"
let JSUNotificationLandTimeLineLongPress = "JSUNotificationLandTimeLineLongPress"

@objc protocol KLineChartViewDelegate{
    optional func chartValueSelected(chartView:StockChartBase,entry:AnyObject,entryIndex:Int)
    optional func chartValueNothingSelected(chartView:StockChartBase)
    optional func chartKlineScrollLeft(chartView:StockChartBase)
}


public class StockChartBase:UIView{
    var statusView = UIView()
    var statusLabel = UILabel()
    var act = UIActivityIndicatorView()
    var contentRect:CGRect = CGRectZero
    var contentInnerRect:CGRect = CGRectZero
    var chartHeight:CGFloat = 0
    var chartWidth:CGFloat = 0
    var offsetLeft:CGFloat = 10
    var offsetTop:CGFloat = 10
    var offsetRight:CGFloat = 10
    var offsetBottom:CGFloat = 10
    
    var contentInnerTop:CGFloat{
        get{
            return contentInnerRect.origin.y
        }
    }
    
    var contentInnerBottom:CGFloat{
        get{
            return contentInnerRect.origin.y + contentInnerRect.size.height;
        }
    }
    
    var contentInnerHeight:CGFloat{
        get{
            return contentInnerRect.size.height
        }
    }
    
    
    
    var contentTop:CGFloat{
        get{
            return contentRect.origin.y
        }
    }
    
    var contentLeft:CGFloat{
        get{
            return contentRect.origin.x
        }
    }
    
    var contentRight:CGFloat{
        get{
            return contentRect.origin.x + contentRect.size.width;
        }
    }
    
    var contentBottom:CGFloat{
        get{
            return contentRect.origin.y + contentRect.size.height;
        }
    }
    
    var contentWidth:CGFloat{
        get{
            return contentRect.size.width
        }
    }
    
    var contentHeight:CGFloat{
        get{
            return contentRect.size.height
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObserver()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addObserver()
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "bounds")
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    func addObserver(){
        self.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.New, context: nil)
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "bounds" || keyPath == "frame"{
            let bounds = self.bounds
            if ((bounds.size.width != self.chartWidth)||(bounds.size.height != self.chartHeight)){
                self.setChartDimens(bounds.size.width, height: bounds.size.height)
                self.notifyDataSetChanged()
            }
        }
    }
    
    func notifyDeviceOrientationChanged(){
        
    }
    
    func notifyDataSetChanged(){
        
    }
    
    func deviceOrientationDidChange(notification:NSNotification){
        if UIDevice.currentDevice().orientation != UIDeviceOrientation.Unknown{
            self.notifyDeviceOrientationChanged()
        }
    }
    
    func setupChartOffsetWithLeft(left:CGFloat,top:CGFloat,right:CGFloat,bottom:CGFloat){
        self.offsetLeft = left
        self.offsetRight = right
        self.offsetTop = top
        self.offsetBottom = bottom
    }
    
    func setChartDimens(width:CGFloat,height:CGFloat){
        self.chartHeight = height;
        self.chartWidth = width;
        self.restrainViewPort(offsetLeft, offsetTop: offsetTop, offsetRight: offsetRight, offsetBottom: offsetBottom)
    }
    
    func restrainViewPort(offsetLeft:CGFloat,offsetTop:CGFloat,offsetRight:CGFloat,offsetBottom:CGFloat){
        contentRect.origin.x = offsetLeft;
        contentRect.origin.y = offsetTop;
        contentRect.size.width = self.chartWidth - offsetLeft - offsetRight;
        contentRect.size.height = self.chartHeight - offsetBottom - offsetTop;
        
        contentInnerRect = CGRectMake(contentRect.origin.x, contentRect.origin.y + 10, contentRect.width, contentRect.height - 20)
        statusView.frame = CGRectMake(CGRectGetMidX(contentRect)-60, CGRectGetMidY(contentRect)-50, 120, 30)
        statusLabel.frame = CGRectMake(0,5, statusView.width, 20)
        act.frame = CGRectMake(6,10, 10, 10)
        
    }
    
    func isInBoundsX(x:CGFloat) -> Bool{
        if self.isInBoundsLeft(x) && self.isInBoundsLeft(x) {
            return true
        }else{
            return false
        }
    }
    
    func isInBoundsY(y:CGFloat) -> Bool{
        if self.isInBoundsTop(y) && self.isInBoundsBottom(y) {
            return true
        }else{
            return false
        }
    }
    
    func isInBoundsX(x:CGFloat,y:CGFloat)-> Bool{
        if self.isInBoundsX(x) && isInBoundsY(y){
            return true
        }else{
            return false
        }
    }
    
    func isInBoundsLeft(x:CGFloat) -> Bool{
        return contentRect.origin.x <= x ? true : false
    }
    
    func isInBoundsRight(x:CGFloat) -> Bool{
        let normalizedX = Int(x * CGFloat(100)/CGFloat(100))
        return Int(contentRect.origin.x + contentRect.size.width) >= normalizedX ? true : false
    }
    
    func isInBoundsTop(y:CGFloat) -> Bool{
        return contentRect.origin.y <= y ? true : false
    }
    
    func isInBoundsBottom(y:CGFloat) -> Bool{
        let normalizedY = Int(y * CGFloat(100)/CGFloat(100))
        return Int(contentRect.origin.y + contentRect.size.height) >= normalizedY ? true : false;
    }
}