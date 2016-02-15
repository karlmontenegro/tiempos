//
//  RecibosVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var classifierItemsDetailTV: UITableView!
    @IBOutlet weak var generateInvoiceButton: UIButton!

    var tiemposDictionary:Dictionary<Cliente,Array<Tiempo>> = daoTiempo().getAllTiempos()!
    var tiemposKeys:Array<Cliente> = []
    
    var selectedTimesArray:Array<Tiempo> = [] //Tiempos seleccionados para facturar
    var selectedObj:AnyObject? = nil
    var selectedTyp:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tiemposKeys = Array(self.tiemposDictionary.keys)
        
        self.generateInvoiceButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.tiemposKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tiemposDictionary[self.tiemposKeys[section]]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tiemposKeys[section].nombre
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("classifierItemCell", forIndexPath: indexPath)
        
        let tiempo = self.tiemposDictionary[self.tiemposKeys[indexPath.section]]![indexPath.row]
        let contrato = self.tiemposDictionary[self.tiemposKeys[indexPath.section]]![indexPath.row].contrato
        
        cell.textLabel?.text = tiempo.titulo
        
        if contrato != nil {
            cell.detailTextLabel?.text = "Contrato: " + (contrato?.nombreContrato)!
        } else {
            cell.detailTextLabel?.text = "(Sin Contrato)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let tiempo = self.tiemposDictionary[self.tiemposKeys[indexPath.section]]![indexPath.row]
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este tiempo? Esto borrará toda la información relacionada con el tiempo.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoTiempo().deleteTiempo(tiempo)
                
                // Deletes the element from the array
                self.tiemposDictionary[self.tiemposKeys[indexPath.section]]!.removeAtIndex(indexPath.row)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Cancel action
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
                self.classifierItemsDetailTV.reloadData()
            }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let tiempo = self.tiemposDictionary[self.tiemposKeys[indexPath.section]]![indexPath.row]
        
        if self.selectedTimesArray.isEmpty {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            self.removeFromArray(tiempo)
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedTimesArray.append(tiempo)
            if self.selectedTimesArray.count == 0 {
                self.generateInvoiceButton.enabled = false
            } else {
                self.generateInvoiceButton.enabled = true
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func stringFromTimeInterval(interval: Int) -> String {
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
    
    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        return interval
    }
    
    
    func removeFromArray(obj: Tiempo) {
        for var index = 0; index < self.selectedTimesArray.count; ++index {
            if self.selectedTimesArray[index] == obj {
                self.selectedTimesArray.removeAtIndex(index)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInvoiceTimeSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let vc:ReciboEmitidoVC = navVC.viewControllers.first as! ReciboEmitidoVC
            vc.dataArray = self.selectedTimesArray
            vc.tipoFact = "HRS"
        }
    }
}
