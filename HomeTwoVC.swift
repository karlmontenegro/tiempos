//
//  HomeTwoVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 29/04/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Charts

class HomeTwoVC: UIViewController, ChartViewDelegate, dateRangeOp {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lblDateRange: UILabel!
    @IBOutlet weak var barChartView: HorizontalBarChartView!

    
    var hoursByClient:Dictionary<String,Double>? = nil
    var hoursByContract:Dictionary<Contrato,Array<Tiempo>>? = nil
    
    var clientKeyArray:Array<String>? = nil
    
    var start:NSDate? = nil
    var end:NSDate? = nil
    
    var xAxis: Array<Double>? = nil
    var yAxis: Array<String>? = nil
    
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.end = NSDate()
        self.start = self.end?.dateByAddingMonths(-1)
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        self.lblDateRange.text = "Del: " + self.dateFormatter.stringFromDate(self.start!) + " Al: " + self.dateFormatter.stringFromDate(self.end!)
        
        self.barChartView.delegate = self
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Charts
        
        self.hoursByClient = daoReports().getAllUncashedTiempos(self.start!, end: self.end!)
        
        print(self.hoursByClient)
        self.clientKeyArray = Array(self.hoursByClient!.keys)
        
        self.barChartView.backgroundColor = UIColor.whiteColor()
        self.yAxis = self.clientKeyArray!
        self.xAxis = self.getArrayFromDict(self.clientKeyArray!, dict: self.hoursByClient!)
        
        setChart(yAxis!, values: xAxis!)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInBounce)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Charts
    
    
    func setChart(dataPoints: Array<String>, values: Array<Double>) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i]/3600, xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Horas")
        let chartData = BarChartData(xVals: yAxis, dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func getArrayFromDict(keys: Array<String>, dict: Dictionary<String,Double>)->Array<Double>?{
        
        var res:Array<Double> = []
        
        for k in keys {
            res.append(dict[k]!)
        }
        
        return res
    }
    
    func returnRangeToHome(start: NSDate, end: NSDate) {
        self.start = start
        self.end = end
        
        self.lblDateRange.text = "Del: " + self.dateFormatter.stringFromDate(self.start!) + " Al: " + self.dateFormatter.stringFromDate(self.end!)
        
        self.hoursByClient = daoReports().getAllUncashedTiempos(self.start!, end: self.end!)
        self.clientKeyArray = Array(self.hoursByClient!.keys)
        
        self.barChartView.backgroundColor = UIColor.whiteColor()
        self.yAxis = self.clientKeyArray!
        self.xAxis = self.getArrayFromDict(self.clientKeyArray!, dict: self.hoursByClient!)
        
        setChart(yAxis!, values: xAxis!)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInBounce)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "dateRangeSegue" {
            let rangeVC = segue.destinationViewController as! DateRangeModal
            rangeVC.delegateAddress = self
        }
    }
}
