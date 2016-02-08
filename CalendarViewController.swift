//
//  CalendarViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 3/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//


import UIKit
import CoreData
import Foundation
import EventKit

class CalendarViewController: UIViewController,UITableViewDataSource,EPCalendarPickerDelegate,UITableViewDelegate{
    
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let calendarName:String = "Freelo Calendar"
    var defaultCalendar:EKCalendar? = nil
    let eventStore = EKEventStore()
    let titleDateFormatter = NSDateFormatter()
    let todayDateFormatter = NSDateFormatter()
    let weekDateFormatter = NSDateFormatter()
    var date = NSDate()
    
    var weekEventArray:Array<EKEvent> = []
    var eventArray:Array<EKEvent> = []

    override func viewWillAppear(animated: Bool) {
        //Creamos el calendario
        self.defaultCalendar = daoCalendar().getCalendar(calendarName, store: self.eventStore)
        
        self.weekEventArray = daoCalendar().getWeekEventsForDate(date, calendar: self.defaultCalendar!, eventStore: self.eventStore)!
        
        self.eventArray = daoCalendar().getEventsForDate(date, calendar: self.defaultCalendar!, eventStore: self.eventStore)
        
        self.dateTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Fecha Titulo
        titleDateFormatter.dateFormat = "ccc, dd MMM"
        
        //Fecha de hoy
        todayDateFormatter.dateFormat = "h:mm a"
        todayDateFormatter.AMSymbol = "AM"
        todayDateFormatter.PMSymbol = "PM"
        
        //Fechas de la semana
        weekDateFormatter.dateFormat = "ccc, dd h:mm a"
        weekDateFormatter.AMSymbol = "AM"
        weekDateFormatter.PMSymbol = "PM"
        
        // Do any additional setup after loading the view.
        
        self.dateTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarTapped(sender: AnyObject) {
        let calendarPicker = EPCalendarPicker(startYear: 2015, endYear: 2040, multiSelection: false)
        calendarPicker.calendarDelegate = self
        
        let calendarNavController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(calendarNavController, animated: true, completion: nil)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error: NSError) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date: NSDate) {
        self.date = self.setCurrentTimeToNewDate(date, time: NSDate())!
        print(self.date)
        self.eventArray = daoCalendar().getEventsForDate(self.date, calendar: self.defaultCalendar!, eventStore: self.eventStore)
        self.dateTableView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            if self.date.isToday() {
                return "Citas para hoy"
            } else {
                return "Citas para " + self.titleDateFormatter.stringFromDate(self.date)
            }
        } else {
            return "Citas para próximos 6 días"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return self.eventArray.count
        } else {
            return self.weekEventArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaCell", forIndexPath: indexPath)
        
        if !self.eventArray.isEmpty{
            if indexPath.section == 0 {
                let date:Cita? = daoCita().getDateByEventId(self.eventArray[indexPath.row])
                
                if date != nil {
                    cell.detailTextLabel?.text = self.eventArray[indexPath.row].title + " - " + (date?.cliente?.nombre!)!
                    if date?.convertido == true {
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                } else {
                    cell.detailTextLabel?.text = self.eventArray[indexPath.row].title
                }
                
                cell.textLabel?.text = self.todayDateFormatter.stringFromDate(self.eventArray[indexPath.row].startDate)
            } else {
                cell.textLabel?.text = self.weekDateFormatter.stringFromDate(self.weekEventArray[indexPath.row].startDate)
                cell.detailTextLabel?.text = self.weekEventArray[indexPath.row].title
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar esta cita? Esto borrará toda la información relacionada con la cita.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoCita().deleteEventByDateId(self.eventArray[indexPath.row], store: self.eventStore)
                
                // Deletes the element from the array
                self.eventArray.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.dateTableView.reloadData()
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
        
        if daoCita().getDateByEventId(self.eventArray[indexPath.row]) != nil {
            self.performSegueWithIdentifier("showDateDetail", sender: self)
        } else {
            self.performSegueWithIdentifier("editEmptyCitaSegue", sender: self)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDateDetail" {
            let vc:CitaDetailTVC = segue.destinationViewController as! CitaDetailTVC
            let indexpath:NSIndexPath = self.dateTableView.indexPathForSelectedRow!
            vc.event = self.eventArray[indexpath.row]
        }
        
        if segue.identifier == "newDate" {
            let vc:NuevaCitaTVC = segue.destinationViewController as! NuevaCitaTVC
            vc.startDate = self.date
        }
        
        if segue.identifier == "editEmptyCitaSegue" {
            let indexpath:NSIndexPath = self.dateTableView.indexPathForSelectedRow!
            let cita = daoCita().createGenericDate((self.eventArray[indexpath.row]).title, calEvent: self.eventArray[indexpath.row])
            
            let navVC = segue.destinationViewController as! UINavigationController
            let editCitaVC = navVC.viewControllers.first as! EditCitaTVC
            editCitaVC.cita = cita
            editCitaVC.event = self.eventArray[indexpath.row]
            editCitaVC.entregable = cita?.entregable
                       
        }
    }
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
