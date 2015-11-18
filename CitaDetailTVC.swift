//
//  CitaDetailTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 18/11/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit

class CitaDetailTVC: UITableViewController {

    @IBOutlet weak var txtNomCita: UILabel!
    @IBOutlet weak var txtNomCliente: UILabel!
    @IBOutlet weak var txtStartDate: UILabel!
    @IBOutlet weak var txtEndDate: UILabel!
    @IBOutlet weak var txtNomContract: UILabel!
    @IBOutlet weak var txtTypeContract: UILabel!
    @IBOutlet weak var txtAlarmInfo: UILabel!
    
    
    var event:AnyObject? = []
    var cita:Cita? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cita = daoCita().getDateByEventId(self.event as! EKEvent)
        
        self.txtNomCita.text = (self.event as! EKEvent).title
        self.txtNomCliente.text = self.cita?.cliente?.nombre
        self.txtStartDate.text = (self.event as! EKEvent).startDate.description
        self.txtEndDate.text = (self.event as! EKEvent).endDate.description
        self.txtNomContract.text = self.cita?.contrato?.nombreContrato
        self.txtTypeContract.text = self.cita?.contrato?.tipoFacturacion
        self.txtAlarmInfo.text = (self.event as! EKEvent).alarms![0].relativeOffset.description
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Editar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //Perform editing actions
            
        })
        edit.backgroundColor = UIColor.orangeColor()
        
        return [edit]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
