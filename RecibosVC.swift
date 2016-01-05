//
//  RecibosVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosVC: UIViewController, classifierOp,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtClassifier: UITextField!
    @IBOutlet weak var txtClassifierItem: UITextField!
    @IBOutlet weak var lblClassifier: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var classifierItemsDetailTV: UITableView!
    
    var classifierItemArray:Array<Tiempo> = []
    var selectedTimesArray:Array<Tiempo> = []
    
    var origin:String = ""
    var selectedObj:AnyObject? = nil
    var selectedTyp:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.txtClassifier.enabled = false
        self.txtClassifierItem.enabled = false
        self.lblClassifier.text = "..."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.classifierItemArray.isEmpty {
            return 0
        }else {
            return self.classifierItemArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("classifierItemCell", forIndexPath: indexPath)
        
        if !self.classifierItemArray.isEmpty {
            cell.textLabel?.text = self.classifierItemArray[indexPath.row].titulo!
            cell.detailTextLabel?.text = self.stringFromTimeInterval(self.classifierItemArray[indexPath.row].horas! as Int)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // Alerts before the delete just in case it wasn't meant to be
            let alertController = UIAlertController(title: "Atención", message:
                "¿Estás seguro que quieres borrar este tiempo? Esto borrará toda la información relacionada con el tiempo.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Delete action
            alertController.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
                // Deletes the row from the DAO
                
                daoTiempo().deleteTiempo(self.classifierItemArray[indexPath.row])
                
                // Deletes the element from the array
                self.classifierItemArray.removeAtIndex(indexPath.row)
                
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
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            
        }else{
            
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedTimesArray.append(self.classifierItemArray[indexPath.row])
        }
        print(self.selectedTimesArray)
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
    
    func returnSelectedOption(selectedObject: AnyObject?, origin: String) {
        if origin == "Classifier" {
            self.txtClassifier.text = selectedObject as? String
            self.lblClassifier.text = selectedObject as? String
        } else {
            if self.lblClassifier.text! == "Clientes" {
                self.txtClassifierItem.text = (selectedObject as? Cliente)?.nombre
                
                //Refresh table with times by client
                self.classifierItemArray = daoTiempo().getTiemposByClient((selectedObject as? Cliente)!)!
                self.classifierItemsDetailTV.reloadData()
                self.selectedTyp = "Cliente"
            }
            if self.lblClassifier.text! == "Contratos" {
                self.txtClassifierItem.text = (selectedObject as? Contrato)?.nombreContrato
                
                //Refresh table with times by contract
                self.classifierItemArray = daoTiempo().getTiemposByContract((selectedObject as? Contrato)!)!
                self.classifierItemsDetailTV.reloadData()
                self.selectedTyp = "Contrato"
            }
            self.selectedObj = selectedObject
        }
    }
    
    @IBAction func addClassifierTapped(sender: AnyObject) {
        self.origin = "Classifier"
        self.performSegueWithIdentifier("classifierPickerSegue", sender: self)
    }

    @IBAction func addClassifierItemTapped(sender: AnyObject) {
        self.origin = "ClassifierItem"
        self.performSegueWithIdentifier("classifierPickerSegue", sender: nil)
    }
    
    @IBAction func createInvoiceTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createInvoiceSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classifierPickerSegue" {
            let vc:ClassifierPickerModal = segue.destinationViewController as! ClassifierPickerModal
            vc.delegateAddress = self
            vc.origin = self.origin
            vc.classifier = self.lblClassifier.text!
        }
        if segue.identifier == "createInvoiceSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let vc:ReciboEmitidoVC = navVC.viewControllers.first as! ReciboEmitidoVC
            vc.tiemposArray = self.selectedTimesArray
        }
    }
}
