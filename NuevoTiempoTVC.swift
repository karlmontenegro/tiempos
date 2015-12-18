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
    var horas:String = ""
    var source:String = ""
    var event:EKEvent? = nil
    let eventStore = EKEventStore()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblCita: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblHoras: UILabel!
    
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
            self.horas = self.stringFromTimeInterval(self.getTotalTime((self.event?.startDate)!, end: (self.event?.endDate)!)!)
            self.lblHoras.text = self.horas

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
        let alertController = UIAlertController(title: "Atención", message:
            "Se guardarán " + self.horas + " como tiempo laborado. ¿Deseas continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Save action
        alertController.addAction(UIAlertAction(title: "Guardar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            
            let alert = UIAlertView()
            alert.title = "Tiempos"
            alert.message = "El tiempo laborado se guardó exitosamente"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }

    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        return interval
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
