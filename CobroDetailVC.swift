//
//  CobroDetailVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol cobrosOp {
    func reloadCashedInvoices()
}

class CobroDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var lblMontoTotal: UILabel!
    @IBOutlet weak var cobroButton: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var lblFechaCobro: UILabel!
    @IBOutlet weak var lblFechaVenc: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    
    var rec:Recibo? = nil
    let dateFormatter = NSDateFormatter()
    let today:NSDate = NSDate()
    var origin:String = ""
    
    var reciboDetalle:Array<ReciboDetalle>? = nil
    var delegateAddress:cobrosOp? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate((self.rec?.fechaEmision!)!)
        self.lblCliente.text = self.rec?.cliente?.nombre
        self.lblFechaVenc.text = self.dateFormatter.stringFromDate((self.rec?.fechaVencimiento!)!)
        
        self.reciboDetalle = self.rec?.reciboDetalle?.allObjects as? Array<ReciboDetalle>
        
        if self.rec?.contrato != nil {
            self.lblContrato.text = self.rec?.contrato?.nombreContrato
            if self.rec?.contrato?.tipoFacturacion == "HRS" {
                self.lblTipoFact.text = "Por Horas"
            } else {
                self.lblTipoFact.text = "Por Entregables"
            }
            
        } else {
            self.lblContrato.text = "(Sin Contrato)"
            self.lblTipoFact.text = "Por Horas"
        }
        
        if self.origin == "NC" {
            self.cobroButton.enabled = true
            self.navigationTitle.title = "Recibo Sin Cobrar"
            self.lblFechaCobro.text = "Sin Cobrar"
        } else {
            self.navigationTitle.title = "Recibo Cobrado"
            self.lblFechaCobro.text = self.dateFormatter.stringFromDate((self.rec?.fechaCobro!)!)
        }
        
        self.txtDescripcion.text = self.rec?.descripcion
        self.lblMontoTotal.text = (self.rec?.moneda?.descripcion)! + Double((self.rec?.valor)!).description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detalle Del Recibo"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.reciboDetalle!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellDetail", forIndexPath: indexPath)
        
        if self.rec?.contrato?.tipoFacturacion == "ENT" {
            cell.textLabel?.text = self.reciboDetalle![indexPath.row].entregable?.nombreEntreg
            cell.detailTextLabel?.text = "Tarifa: " + (self.rec?.moneda?.descripcion)! + Double(self.reciboDetalle![indexPath.row].total!).description
        } else {
            let interval = self.reciboDetalle![indexPath.row].nroHoras
            let timeInterval = NSTimeInterval(interval!.doubleValue)
                
            let subtotal = Double(self.reciboDetalle![indexPath.row].total!)
            
            let moneda = self.rec?.moneda?.descripcion
            cell.textLabel!.text = self.reciboDetalle![indexPath.row].tiempo?.titulo
            cell.detailTextLabel!.text = "Horas: " + self.stringFromTimeInterval(timeInterval) + " - Subtotal: " + moneda! + subtotal.description
        }
        
        return cell
    }
    
    @IBAction func cobrarTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Atención", message:
            "Confirma el cobro del recibo. Ya cobraste los " + Double((self.rec?.valor)!).description + "?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Cobrar
        alertController.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            daoRecibo().cashInvoice(self.rec!, date: self.today, description: self.descripcion.text)
            
            let confirmationController = UIAlertController(title: "Confirmación", message: "Se ha registrado el cobro del recibo exitosamente", preferredStyle:  UIAlertControllerStyle.Alert)
            
            confirmationController.addAction(UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: { (confirmationController) -> Void in
                self.delegateAddress?.reloadCashedInvoices()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }))
            
            self.presentViewController(confirmationController, animated: true, completion: nil)

        }))
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (alertController) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        //let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d horas %02d minutos", hours, minutes)
    }
}
