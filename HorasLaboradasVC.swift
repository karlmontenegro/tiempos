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

class HorasLaboradasVC: UIViewController,CalendarViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var calendarV: UIView!
    @IBOutlet weak var datesWithoutTimeTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let calendarName:String = "Freelo Calendar"
    var defaultCalendar:EKCalendar? = nil
    let eventStore = EKEventStore()
    var eventArray:Array<EKEvent> = []
    var dateArray:Array<Cita> = daoCita().getUnconvertedDates()
    let dateFormatter = NSDateFormatter()
    
    var source:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        dateFormatter.dateFormat = "ccc, dd MMM"
        
        let date = NSDate()
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarV.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        calendarV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        calendarV.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectDate(date: NSDate) {
        self.source = "Calendar"
        //self.performSegueWithIdentifier("createNewTime", sender: self)
    }
    
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Citas sin tiempo asociado"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if self.dateArray.isEmpty {
            return 0
        }else {
            return self.dateArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaUACell", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.dateFormatter.stringFromDate((daoCita().getEventByDateId(self.dateArray[indexPath.row], store: self.eventStore)?.startDate)!)
        
        cell.detailTextLabel!.text = daoCita().getEventByDateId(self.dateArray[indexPath.row], store: self.eventStore)?.title
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
                
                daoCita().deleteDate(self.dateArray[indexPath.row], store: self.eventStore)
                // Deletes the element from the array
                self.dateArray.removeAtIndex(indexPath.row)
                
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
        self.performSegueWithIdentifier("createNewTime", sender: self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "createNewTime" {
            switch (self.source) {
                case "Calendar": //The segue comes from the calendar
                    
                    let navVC = segue.destinationViewController as! UINavigationController
                    let tableVC = navVC.viewControllers.first as! NuevoTiempoTVC
                    tableVC.source = "Calendar"
                    
                    break
                
                case "Date": //The segue comes from an unassigned date
                    
                    let navVC = segue.destinationViewController as! UINavigationController
                    let tableVC = navVC.viewControllers.first as! NuevoTiempoTVC
                    let indexpath:NSIndexPath = self.datesWithoutTimeTableView.indexPathForSelectedRow!
                    tableVC.source = "Date"
                    tableVC.cita = self.dateArray[indexpath.row]
                    break
                
                default: //The segue comes from the new time button
                    
                    let navVC = segue.destinationViewController as! UINavigationController
                    let tableVC = navVC.viewControllers.first as! NuevoTiempoTVC
                    tableVC.source = "New"
                    
                    break
            }
        }
    }
}
