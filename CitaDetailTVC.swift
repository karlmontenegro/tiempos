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
    
    var event:AnyObject? = []
    var cita:Cita? = nil
    var hideTableSection:Bool = false
    
    @IBOutlet weak var nomCita: UILabel!
    @IBOutlet weak var nomCliente: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var nomContrato: UILabel!
    @IBOutlet weak var tipoFacturacion: UILabel!
    @IBOutlet weak var nomEntregable: UILabel!
    @IBOutlet weak var alerts: UILabel!
    @IBOutlet weak var entregableCell: UITableViewCell!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ccc, dd MMM hh:mm a"
        
        self.cita = daoCita().getDateByEventId(self.event as! EKEvent)
           
        self.nomCita.text = (self.event as! EKEvent).title
        self.nomCliente.text = self.cita?.cliente?.nombre
        self.startDate.text = dateFormatter.stringFromDate((self.event as! EKEvent).startDate)
        self.endDate.text = dateFormatter.stringFromDate((self.event as! EKEvent).endDate)
        self.nomContrato.text = self.cita?.contrato?.nombreContrato
        
        if self.cita?.contrato?.tipoFacturacion == "HRS" {
            self.tipoFacturacion.text = "Por Horas"
            self.entregableCell.hidden = true
        }else{
            if self.cita?.contrato?.tipoFacturacion == "ENT" {
                self.tipoFacturacion.text = "Por Entregables"
                self.entregableCell.detailTextLabel?.text = self.cita?.entregable?.nombreEntreg
            } else {
                self.tipoFacturacion.text = ""
                self.entregableCell.hidden = true
                self.nomContrato.text = "(Sin Contrato Asociado)"
            }
        }
        
        if (self.event as! EKEvent).hasAlarms{
            self.alerts.text = self.getOffsetText((self.event as! EKEvent).alarms![0].relativeOffset)
        }else{
            self.alerts.text = "(Sin recordatorios)"
        }
        
        if (self.cita!.convertido == 1) {
            self.editButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2{
            if indexPath.row == 1{
                if self.cita?.contrato?.tipoFacturacion == "HRS"{
                    return 0.0
                }
            }
        }
        return 44.0
    }
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 4) //Index number of interested section
        {
            if (hideTableSection) {
                return 0; //number of row in section when you click on hide
            }else{
                return 1; //number of row in section when you click on show (if it's higher than rows in Storyboard, app willcrash)
            }
        }else{
            return 1//keeps inalterate all other rows
        }
    }
    */
    
    func getOffsetText(offset: NSTimeInterval)->String{
        let interval = Int(offset * -1.0)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if minutes != 0 && hours == 0 {
            return "" + minutes.description + " minutos antes"
        }
        
        if hours != 0 {
            return "" + hours.description + " horas antes"
        }
        
        return "Ninguno"
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDateSegue"{
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! EditCitaTVC
            tableVC.cita = self.cita
            tableVC.event = self.event as? EKEvent
            tableVC.entregable = self.cita?.entregable
        }
        if segue.identifier == "convertDateToTimeSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let tableVC = navVC.viewControllers.first as! ConvertirCitaTVC
            tableVC.cita = self.cita
            tableVC.event = self.event as? EKEvent
            tableVC.entregable = self.cita?.entregable
        }
    }

}
