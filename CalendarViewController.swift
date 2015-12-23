//
//  CalendarViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 3/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//


//TODO

//Conseguir listado de calendarios, si no se encuentra, crear de nuevo el calendario.
//Crear eventos desde la aplicación y setear alertas.

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
    let dateFormatter = NSDateFormatter()
    var date = NSDate()
    
    var eventArray:Array<EKEvent> = []
    
    override func viewWillAppear(animated: Bool) {
        //Creamos el calendario
        self.defaultCalendar = daoCalendar().getCalendar(calendarName, store: self.eventStore)
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
        dateFormatter.dateFormat = "ccc, dd MMM"
        
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
        self.date = date
        self.eventArray = daoCalendar().getEventsForDate(self.date, calendar: self.defaultCalendar!, eventStore: self.eventStore)
        self.dateTableView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Citas programadas para " + self.dateFormatter.stringFromDate(self.date)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.eventArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaCell", forIndexPath: indexPath)

        if !self.eventArray.isEmpty{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.AMSymbol = "AM"
            dateFormatter.PMSymbol = "PM"
            let startTimeStr:String = dateFormatter.stringFromDate(self.eventArray[indexPath.row].startDate)
            cell.detailTextLabel?.text = self.eventArray[indexPath.row].title
            cell.textLabel?.text = startTimeStr
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
        self.performSegueWithIdentifier("showDateDetail", sender: self)
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
    }

}
