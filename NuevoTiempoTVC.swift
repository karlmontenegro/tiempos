//
//  NuevoTiempoTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit
import Foundation

class NuevoTiempoTVC: UITableViewController {
    
    var date:NSDate? = nil
    var cita:Cita? = nil
    var source:String = ""
    var event:EKEvent? = nil
    let eventStore = EKEventStore()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblCita: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var citaAsociada: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.source == "Date" {
            self.event = daoCita().getEventByDateId(self.cita!, store: self.eventStore)
            self.dateFormatter.dateFormat = "ccc, dd MMM"
            self.lblCliente.text = self.cita?.cliente?.nombre
            self.lblContrato.text = self.cita?.contrato?.nombreContrato
            self.lblCita.text = self.event?.title
            self.lblFecha.text = self.dateFormatter.stringFromDate((self.event?.startDate)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
