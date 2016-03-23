//
//  RecibosVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation
import DZNEmptyDataSet

class RecibosVC: UIViewController,UITableViewDelegate,UITableViewDataSource,invoiceOp, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tiemposTableView: UITableView!
    @IBOutlet weak var generateInvoiceButton: UIButton!
    
    var tiemposDictionary:Dictionary<Cliente,Array<Tiempo>> = daoTiempo().getAllActiveTiempos()!
    var tiemposKeys:Array<Cliente> = []
    
    var selectedTimesArray:Array<Tiempo> = [] //Tiempos seleccionados para facturar
    var selectedObj:AnyObject? = nil
    var selectedTyp:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tiemposTableView.emptyDataSetDelegate = self
        self.tiemposTableView.emptyDataSetSource = self
        
        self.tiemposTableView.tableFooterView = UIView()
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tiemposKeys = Array(self.tiemposDictionary.keys)
        self.generateInvoiceButton.enabled = false
        self.generateInvoiceButton.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Empty Data Set Func
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-time-100")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No tienes horas laboradas que facturar"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Registra algunas horas laboradas previamente"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -(self.navigationController?.navigationBar.frame.height)!
    }
    
    
    func reloadTimesList() {
        self.tiemposDictionary = daoTiempo().getAllActiveTiempos()!
        self.tiemposKeys = Array(self.tiemposDictionary.keys)
        self.tiemposTableView.reloadData()
    }
    
    func reloadEntregablesList() {
        //Doesn't get used
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
                self.tiemposTableView.reloadData()
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
                self.generateInvoiceButton.hidden = true
            } else {
                self.generateInvoiceButton.enabled = true
                self.generateInvoiceButton.hidden = false
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
        //let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
    
    func getTotalTime(start:NSDate, end:NSDate)->NSTimeInterval?{
        let interval:NSTimeInterval = end.timeIntervalSinceDate(start)
        return interval
    }
    
    
    func removeFromArray(obj: Tiempo) {
        for index in 0 ..< self.selectedTimesArray.count {
            if self.selectedTimesArray[index] == obj {
                self.selectedTimesArray.removeAtIndex(index)
            }
        }
    }
    
    func sameCurrencyCheck(obj: Array<Tiempo>)->Bool {
        var pivot:Moneda? = nil
        
        if obj.first!.moneda != nil {
            pivot = obj.first!.moneda
        } else {
            pivot = obj.first!.contrato?.moneda
        }
        
        for t in obj {
            if t.moneda != nil {
                if t.moneda != pivot {
                    return false
                }
            } else {
                if t.contrato != nil {
                    if t.contrato?.moneda != pivot {
                        return false
                    }
                } else {
                    return true
                }
            }
        }
        return true
    }
    
    func sameClientCheck(obj: Array<Tiempo>)->Bool {
        let pivot:Cliente? = obj.first!.cliente
        
        for t in obj {
            if t.cliente != pivot {
                return false
            }
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "createInvoiceTimeSegue" {
            if !self.sameClientCheck(self.selectedTimesArray) {
                self.alertMessage("Los tiempos a cobrar deben tener el mismo cliente", winTitle: "Error")
                return false
            } else {
                if !self.sameCurrencyCheck(self.selectedTimesArray){
                    self.alertMessage("Los tiempos a cobrar deben tener la misma moneda", winTitle: "Error")
                    return false
                } else {
                    return true
                }
            }
        }
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createInvoiceTimeSegue" {
            let navVC = segue.destinationViewController as! UINavigationController
            let vc:ReciboEmitidoVC = navVC.viewControllers.first as! ReciboEmitidoVC
            vc.tiemposArray = self.selectedTimesArray
            vc.tipoFact = "HRS"
            vc.cliente = self.selectedTimesArray.first?.cliente
            vc.delegateAddress = self
        }
    }
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
