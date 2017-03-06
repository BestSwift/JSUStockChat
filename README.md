# JSUStockChat

JSUStockChat is a easy way to make stock chart with Auto Layout And StoryBoard!

* Xcode 7.3 / Swift 2.2 / 3.0
* iOS 8.0 / 9.0 

##Key Features
1.Standard

<img src="https://github.com/BestSwift/JSUStockChat/blob/master/JSUStockChartDemo/stock.gif" alt="" />

2.Breathing Lamp

<img src="https://github.com/BestSwift/JSUStockChat/blob/master/JSUStockChartDemo/breathPoint.gif" alt="" />

3.Landscape

<img src="https://github.com/BestSwift/JSUStockChat/blob/master/JSUStockChartDemo/landEsape.gif" alt="" />

4.LongPress

<img src="https://github.com/BestSwift/JSUStockChat/blob/master/JSUStockChartDemo/longPress.gif" alt="" />

5.Zoom

<img src="https://github.com/BestSwift/JSUStockChat/blob/master/JSUStockChartDemo/zoom.gif" alt="" />

3.
## Usage

1.Drag JSUStockChart to your project.

2.Drag a UIView to your ViewController.

3.Change the view Custom Class to TimeLineStockChartView and Connect to @IBOutlet weak var timeView.

4.In ViewDidLoad.

```swift

class JSUTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeView.setupChartOffsetWithLeft(16,top:10,right:16,bottom:10)
        self.timeView.drawLabelPriceInside = true
        self.timeView.drawLabelRatioInside = true
        self.timeView.gridBackgroundColor = UIColor.whiteColor()
        self.timeView.borderColor = UIColor(netHex: 0xe4e4e4, alpha: 1)
        self.timeView.borderWidth = 0.5
        self.timeView.uperChartHeightScale = 0.7;
        self.timeView.xAxisHeitht = 25
        self.timeView.countOfTimes = 242

        loadData()
        
    }

}
```

5.loadData,I get data from a json file,you can get it from your webservice.
```swift
    func loadData(){
        //get priceData
        let model:JSUPriceModel = readFile("timeLineData", ext: "json")
        self.setupTimeLineView(model)
    }
```

6.setupTimeLineView
```swift
 
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
        self.timeView.endPointShowEnabled = NSDate().isTradingTime()
        self.timeView.setupData(set)

    }
```

## License

MIT license. See the `LICENSE` file for details.
