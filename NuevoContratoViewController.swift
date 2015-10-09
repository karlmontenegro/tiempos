//
//  NuevoContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 15/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoContratoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,clientOperations,currencyOperations {
    
    var arreglo:Array<Entregable> = []
    var arregloTest:Array<String> = ["1"]
    
    let animationDuration:NSTimeInterval = 0.25
    
    @IBOutlet weak var entregables: UITableView!
    
    @IBOutlet weak var nomContrato: UITextField!
    @IBOutlet weak var txtCliente: UILabel!
    @IBOutlet weak var txtMoneda: UILabel!
    
    @IBOutlet weak var tarifaPorHora: UITextField!
    @IBOutlet weak var nroHoras: UITextField!

    @IBOutlet weak var horasViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalheight: NSLayoutConstraint!
    @IBOutlet weak var nroHorasHeight: NSLayoutConstraint!
    @IBOutlet weak var tarifaHeight: NSLayoutConstraint!
    @IBOutlet weak var entregablesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBAction func factSwitchChanged(sender: UISwitch) {
       
        if sender.on{
            self.tipoFact = "ENT"
            hideView()
            
        }else{
            self.tipoFact = "HRS"
            showView()
        }
        
        //Display container
        
    }
    
    var listaClientes:NSArray = []
    var listaMonedas:NSArray = ["PEN (S/.)","USD (US$)"]
    var cliente:AnyObject = []
    
    //HRS => Por Horas
    //ENT => Por Entregables
    
    var tipoFact:String = ""
    
    func hideView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.nroHorasHeight.constant = 0.0
            self.tarifaHeight.constant = 0.0
            self.totalheight.constant = 0.0
            self.horasViewHeight.constant = 0.0
            self.entregablesViewHeight.constant = 259.0
            self.buttonHeight.constant = 30.0
            self.view.layoutIfNeeded()
        }
    }
    
    func showView(){
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.horasViewHeight.constant = 86.0
            self.nroHorasHeight.constant = 30.0
            self.tarifaHeight.constant = 30.0
            self.totalheight.constant = 30.0
            self.entregablesViewHeight.constant = 0.0
            self.buttonHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let daocliente = daoCliente()
        self.listaClientes = daocliente.getAllClients()
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    func returnClientToContract(client: Cliente) {
        self.cliente = client
        self.txtCliente.text = client.valueForKey("Nombre") as? String
    }
    
    func returnCurrency(currency: String) {
        self.txtMoneda.text = currency
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        
        daoContrato().newContract(self.nomContrato.text!, tipoFact: self.tipoFact, client: self.cliente as! Cliente)
        
         self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
         self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func selectClient(sender: UIButton) {
        performSegueWithIdentifier("clientPickerModal", sender: sender)
    }
    @IBAction func selectCurrency(sender: UIButton) {
        performSegueWithIdentifier("currencyPickerModal", sender: sender)
    }
    //Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return self.arregloTest.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entregableCell", forIndexPath: indexPath)
        
            cell.textLabel!.text = "Entregable " + (indexPath.row + 1).description

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.arregloTest.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    @IBAction func addCell(sender: AnyObject) {
        let elem:String = " "
        var e:Entregable = Entregable()
        
        self.arreglo.append(e)
        self.arregloTest.append(elem)
        
        self.entregables.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clientPickerModal"{
            let vc:ClientModal = segue.destinationViewController as! ClientModal
            vc.delegateAddress = self
        }
        if segue.identifier == "currencyPickerModal"{
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
    }
}
