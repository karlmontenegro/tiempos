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
import DZNEmptyDataSet

class CalendarViewController: UIViewController,UITableViewDataSource,EPCalendarPickerDelegate,UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let calendarName:String = "Freelo Calendar"
    var defaultCalendar:EKCalendar? = nil
    let eventStore = EKEventStore()
    let titleDateFormatter = NSDateFormatter()
    let hourFormatter = NSDateFormatter()
    let weekDateFormatter = NSDateFormatter()
    var date = NSDate()
    var dateSync: DateBatchImport? = nil
    
    var weekEventKeyArray:Array<NSDate> = []
    var weekEventDictionary:Dictionary<NSDate,Array<EKEvent>>? = nil

    override func viewWillAppear(animated: Bool) {
        //Creamos el calendario
        
        self.defaultCalendar = daoCalendar().getCalendar(self.calendarName, store: self.eventStore)
        
        self.weekEventDictionary = daoCalendar().getWeeklyEventsForDate(date, calendar: self.defaultCalendar!, eventStore: self.eventStore)!
        
        self.weekEventKeyArray = Array(self.weekEventDictionary!.keys) 
        self.weekEventKeyArray.sortInPlace { $0.compare($1) == .OrderedAscending }
        
        self.dateTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateSync = DateBatchImport(eS: self.eventStore , c: daoCalendar().getCalendar(self.calendarName, store: self.eventStore))
        
        self.dateTableView.emptyDataSetDelegate = self
        self.dateTableView.emptyDataSetSource = self
        
        self.dateTableView.tableFooterView = UIView()
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Fecha Titulo
        titleDateFormatter.dateFormat = "ccc, dd MMM"
        
        //Fecha de hoy
        hourFormatter.dateFormat = "h:mm a"
        hourFormatter.AMSymbol = "AM"
        hourFormatter.PMSymbol = "PM"
        
        //Fechas de la semana
        weekDateFormatter.dateFormat = "ccc, dd MM"
        weekDateFormatter.AMSymbol = "AM"
        weekDateFormatter.PMSymbol = "PM"
        
        // Do any additional setup after loading the view.
        
        self.dateTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Empty Data Set functions
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-calendar-100")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No tienes citas programadas en los próximos 7 días"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Haz click en el botón superior derecho para añadir tu primera cita"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -(self.navigationController?.navigationBar.frame.height)!
    }
    
    @IBAction func syncCalendarDates(sender: AnyObject) {
        
        if !self.dateSync!.unsyncedDatesExist(-4, endDate: NSDate()) {
            self.alertMessage("Todas las citas se encuentran sincronizadas", winTitle: "")
        } else {
            let alertController = UIAlertController(title: "Atención", message:
                "¿Desea importar las citas del calendario a Freelo?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Importar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                let dateCount = self.dateSync!.importCalendarDatesToDataBase(-4, endDate: NSDate())
                
                self.weekEventDictionary = daoCalendar().getWeeklyEventsForDate(self.date, calendar: self.defaultCalendar!, eventStore: self.eventStore)!
                
                self.weekEventKeyArray = Array(self.weekEventDictionary!.keys)
                self.weekEventKeyArray.sortInPlace { $0.compare($1) == .OrderedAscending }
                
                self.dateTableView.reloadData()
                
                self.alertMessage("Se importaron " + dateCount.description + " citas a Freelo", winTitle: "Exito")
                
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
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

        self.weekEventDictionary = daoCalendar().getWeeklyEventsForDate(self.date, calendar: self.defaultCalendar!, eventStore: self.eventStore)!
        
        self.weekEventKeyArray = Array(self.weekEventDictionary!.keys)
        self.weekEventKeyArray.sortInPlace { $0.compare($1) == .OrderedAscending }
        
        self.dateTableView.reloadData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return self.weekEventKeyArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.weekEventKeyArray[section].isToday() {
            return "Citas para hoy"
        } else {
            return "Citas para el " +  self.titleDateFormatter.stringFromDate(self.weekEventKeyArray[section])
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.weekEventDictionary![self.weekEventKeyArray[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CitaCell", forIndexPath: indexPath)
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        let dateTitle:String = self.weekEventDictionary![self.weekEventKeyArray[indexPath.section]]![indexPath.row].title
        
        let calendarDate:EKEvent = self.weekEventDictionary![self.weekEventKeyArray[indexPath.section]]![indexPath.row]
        
        let date:Cita? = daoCita().getDateByEventId(calendarDate)
    
        if date != nil {
            if date?.cliente != nil {
                cell.detailTextLabel?.text = dateTitle + " - " + (date?.cliente?.nombre!)!
            } else {
                cell.detailTextLabel?.text = dateTitle
            }
            
            if date?.convertido! == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
        } else {
            cell.detailTextLabel?.text = dateTitle
        }
                
        cell.textLabel?.text = self.hourFormatter.stringFromDate(calendarDate.startDate)
        
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
                
                daoCita().deleteEventByDateId(self.weekEventDictionary![self.weekEventKeyArray[indexPath.section]]![indexPath.row], store: self.eventStore)
                
                // Deletes the element from the dictionary
                self.weekEventDictionary![self.weekEventKeyArray[indexPath.section]]!.removeAtIndex(indexPath.row)
                
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
        
        let event:EKEvent = self.weekEventDictionary![self.weekEventKeyArray[indexPath.section]]![indexPath.row]
        
        if daoCita().getDateByEventId(event) != nil {
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
            let event:EKEvent = self.weekEventDictionary![self.weekEventKeyArray[indexpath.section]]![indexpath.row]
            vc.event = event
            vc.eventStore = self.eventStore
        }
        
        if segue.identifier == "newDate" {
            let vc:NuevaCitaTVC = segue.destinationViewController as! NuevaCitaTVC
            vc.startDate = self.date
        }
        
        if segue.identifier == "editEmptyCitaSegue" {
            let indexpath:NSIndexPath = self.dateTableView.indexPathForSelectedRow!
            
            let event:EKEvent = self.weekEventDictionary![self.weekEventKeyArray[indexpath.section]]![indexpath.row]
            
            let cita = daoCita().createGenericDate(event.title, calEvent: event)
            
            let navVC = segue.destinationViewController as! UINavigationController
            let editCitaVC = navVC.viewControllers.first as! EditCitaTVC
            editCitaVC.cita = cita
            editCitaVC.event = event
            editCitaVC.entregable = cita?.entregable
            editCitaVC.eventStore = self.eventStore
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
