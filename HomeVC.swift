//
//  HomeVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit
import AddressBook
import AddressBookUI
import Charts


class HomeVC: UIViewController, ChartViewDelegate, dateRangeOp {

    @IBOutlet weak var menuButton: UIBarButtonItem!

    
    let eventStore = EKEventStore()
    var addressBookRef: ABAddressBook? = nil
    var defaultCalendar: EKCalendar? = nil
    var dateSync:DateBatchImport? = nil
    
    var hoursByClient:Dictionary<String,Double>? = nil
    var hoursByContract:Dictionary<Contrato,Array<Tiempo>>? = nil
    
    var clientKeyArray:Array<String>? = nil
    
    var start:NSDate? = nil
    var end:NSDate? = nil
    
    var xAxis: Array<Double>? = nil
    var yAxis: Array<String>? = nil
    
    @IBOutlet weak var barChartView: HorizontalBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.end = NSDate()
        self.start = self.end?.dateByAddingMonths(-1)
        
        self.barChartView.delegate = self
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
        checkAccessForCalendar()
        checkAccessForAddressBook()
        
        self.defaultCalendar = daoCalendar().getCalendar("Freelo Calendar", store: self.eventStore)
        self.dateSync = DateBatchImport.init(eS: eventStore, c: defaultCalendar)
        self.dateSync!.importCalendarDatesToDataBase(-1, endDate: NSDate())
        
        //Charts
        
        self.hoursByClient = daoReports().getAllCashedTiempos(self.start!, end: self.end!)
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
    
    //Calendar Auth
    
    func checkAccessForCalendar(){
        
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
            
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            self.eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error: NSError?) in
                if accessGranted == true {
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.dateTableView.reloadData()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                }
            }
            
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            break
        
        case EKAuthorizationStatus.Denied:
            self.goToSettingsWindow()
            break
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            break
        }
    }
    
    //Address Book Auth
    
    func checkAccessForAddressBook(){
    
        let status = ABAddressBookGetAuthorizationStatus()
        
        switch (status) {
            
            case ABAuthorizationStatus.Authorized:
                //print("Authorized")
                //Ready to go!
                break
        
            case ABAuthorizationStatus.Denied:
                self.goToSettingsWindow()
                break
            
            case ABAuthorizationStatus.NotDetermined:
                //First run
                ABAddressBookRequestAccessWithCompletion(self.addressBookRef, {
                    (granted : Bool, error: CFError!) -> Void in
                    if granted == true
                    {
                        self.addressBookRef = ABAddressBookCreateWithOptions(nil , nil).takeRetainedValue()
                        
                    }else {
                        
                    }
                })

                break
            
            case ABAuthorizationStatus.Restricted:
                print("Restricted")
                break
        }
    }

    func goToSettingsWindow() {
        print("Go to settings window here!")
    }
    
    func returnRangeToHome(start: NSDate, end: NSDate) {
        self.start = start
        self.end = end
        
        self.hoursByClient = daoReports().getAllCashedTiempos(self.start!, end: self.end!)
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
