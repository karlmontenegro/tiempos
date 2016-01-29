//
//  CobroDetailVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class CobroDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var lblMontoTotal: UILabel!
    @IBOutlet weak var cobroButton: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var rec:Recibo? = nil
    let dateFormatter = NSDateFormatter()
    let today:NSDate = NSDate()
    var origin:String = ""
    
    var entregables:Array<Entregable> = []
    var tiempos:Array<Tiempo> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate((self.rec?.fechaEmision!)!)
        self.lblCliente.text = self.rec?.cliente?.nombre
        self.lblContrato.text = self.rec?.contrato?.nombreContrato
        
        if self.origin == "NC" {
            self.cobroButton.enabled = true
            self.navigationTitle.title = "Recibo Sin Cobrar"
        } else {
            self.navigationTitle.title = "Recibo Cobrado"
        }
        
        if self.rec?.tiempo != nil {
            self.lblTipoFact.text = "Por Horas"
            self.tiempos = daoRecibo().getTiempoListFromInvoice(self.rec!)!
        }
        if self.rec?.entregable != nil{
            self.lblTipoFact.text = "Por Entregables"
            self.entregables = daoRecibo().getEntregablesListFromInvoice(self.rec!)!
        }
        
        self.txtDescripcion.text = self.rec?.descripcion
        self.lblMontoTotal.text = Double((self.rec?.valor)!).description
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
        if self.rec?.entregable != nil {
            //Por entregables
            return self.entregables.count
        }
        if self.rec?.tiempo != nil {
            //Por horas
            return self.tiempos.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellDetail", forIndexPath: indexPath)
        
        if self.rec?.entregable != nil {
            cell.textLabel?.text = self.entregables[indexPath.row].nombreEntreg
            cell.detailTextLabel?.text = "Tarifa:" + Double(self.entregables[indexPath.row].tarifa!).description
        }
        
        if self.rec?.tiempo != nil {
            
            cell.textLabel?.text = self.tiempos[indexPath.row].titulo
            cell.detailTextLabel?.text = "Subtotal:"
        }
        
        return cell
    }
    
    @IBAction func cobrarTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Atención", message:
            "Confirma el cobro del recibo. Ya cobraste los " + Double((self.rec?.valor)!).description + "?", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Cobrar
        alertController.addAction(UIAlertAction(title: "Si", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
            daoRecibo().cashInvoice(self.rec!, date: self.today)
            
            let confirmationController = UIAlertController(title: "Confirmación", message: "Se ha registrado el cobro del recibo exitosamente", preferredStyle:  UIAlertControllerStyle.Alert)
            
            confirmationController.addAction(UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: { (confirmationController) -> Void in
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

}
