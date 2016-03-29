//
//  HorasLaboradasVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import EventKit
import DZNEmptyDataSet

class HorasLaboradasVC: UIViewController,UITableViewDataSource,UITableViewDelegate,unconvertedDatesOp, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var datesWithoutTimeTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let calendarName:String = "Freelo Calendar"
    var defaultCalendar:EKCalendar? = nil
    let eventStore = EKEventStore()
    var eventArray:Array<EKEvent> = []
    
    var dateDictionary:Dictionary<NSDate,Array<Cita>>? = nil
    var dateKeyArray:Array<NSDate> = []
    
    let dateFormatter = NSDateFormatter()
    let hourFormatter = NSDateFormatter()
    var navControl:UINavigationController? = nil
    
    var dateToSend:NSDate = NSDate()
    
    var source:String = ""
    let date:NSDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Empty Data Set
        
        self.datesWithoutTimeTableView.emptyDataSetSource = self
        self.datesWithoutTimeTableView.emptyDataSetDelegate = self
        
        self.datesWithoutTimeTableView.tableFooterView = UIView()
        
        
        self.dateDictionary = daoCita().getUnconvertedDates(self.date, store: self.eventStore)
        self.dateKeyArray = Array(self.dateDictionary!.keys)
        self.dateKeyArray.sortInPlace { $0.compare($1) == .OrderedAscending }

        self.navControl = self.navigationController
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        dateFormatter.dateFormat = "ccc, dd MMM"
        hourFormatter.dateFormat = "h:mm a"
        hourFormatter.AMSymbol = "AM"
        hourFormatter.PMSymbol = "PM"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Empty Data Set Functions
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-time-100")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No tienes citas pendientes de convertir"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Haz click en el botón superior derecho para añadir horas laboradas"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -(self.navigationController?.navigationBar.frame.height)!
    }
    
    func refreshUnconvertedDates() {
        self.dateDictionary = nil
        self.dateDictionary = daoCita().getUnconvertedDates(self.date, store: self.eventStore)
        self.dateKeyArray = Array(self.dateDictionary!.keys)
        self.dateKeyArray.sortInPlace { $0.compare($1) == .OrderedAscending }
        self.datesWithoutTimeTableView.reloadData()
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.dateKeyArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.dateKeyArray[section].isToday() {
            return "Citas sin tiempo de hoy"
        } else {
            return "Citas sin tiempo del " +  self.dateFormatter.stringFromDate(self.dateKeyArray[section])
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.dateDictionary![self.dateKeyArray[section]]!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaUACell", forIndexPath: indexPath)
        
        let key = self.dateKeyArray[indexPath.section]
        
        let title = self.hourFormatter.stringFromDate(
        (daoCita().getEventByDateId(self.dateDictionary![key]![indexPath.row], store: self.eventStore)?.startDate)!)
        
        let subtitle = daoCita().getEventByDateId(self.dateDictionary![key]![indexPath.row], store: self.eventStore)!.title
        
        let client = (self.dateDictionary![key]![indexPath.row]).cliente?.nombre
        
        cell.textLabel!.text = title
        
        if client != nil {
            cell.detailTextLabel!.text = subtitle + " - " + client!
        } else {
            cell.detailTextLabel!.text = subtitle + " - (Sin Cliente)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let key = self.dateKeyArray[indexPath.section]
        let cita = self.dateDictionary![key]![indexPath.row]
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar esta cita? Esto borrará toda la información relacionada con la cita.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoCita().deleteDate(cita)
                // Deletes the element from the array
                self.dateDictionary![key]!.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.datesWithoutTimeTableView.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.source = "Date"
        self.performSegueWithIdentifier("addTimeSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "createNewTime" {
                let navVC = segue.destinationViewController as! UINavigationController
                let tableVC = navVC.viewControllers.first as! NuevoTiempoTVC
                tableVC.source = "New"
                tableVC.date = self.dateToSend
                tableVC.delegateAddress = self
        }
        if segue.identifier == "addTimeSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! NuevoTiempoTVC
            let indexpath:NSIndexPath = self.datesWithoutTimeTableView.indexPathForSelectedRow!
            tableVC.source = "Date"
            tableVC.cita = self.dateDictionary![self.dateKeyArray[indexpath.section]]![indexpath.row]
            tableVC.delegateAddress = self
        }
    }
    
    func setCurrentTimeToNewDate(date:NSDate, time:NSDate)->NSDate?{
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components([.Hour, .Minute, .Second], fromDate: date)
        
        components.year = date.year()
        components.month = date.month()
        components.day = date.day()
        components.hour = time.hour()
        components.minute = time.minute()
        components.second = time.second()
        
        return calendar!.dateFromComponents(components)
    }
}
