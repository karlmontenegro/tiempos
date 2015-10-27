//
//  NuevoCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 7/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoCliente: UIViewController{

    @IBOutlet weak var txtRUC: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtRazonSocial: UITextField!
    
    var nuevoCliente:AnyObject = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveTapped(sender: AnyObject) {
        //let defaults = NSUserDefaults.standardUserDefaults()
        self.nuevoCliente = daoCliente().newClient(txtNombre.text!, ruc: txtRUC.text!, razonSoc: txtRazonSocial.text!, direccion: "",usuario: "")
        
        performSegueWithIdentifier("stepTwoNewClient", sender: sender)
        
         //self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

    @IBAction func cancelTapped(sender: AnyObject) {
         self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stepTwoNewClient" {
            let tvc:DetalleClienteViewController = segue.destinationViewController as! DetalleClienteViewController
            
            tvc.data = self.nuevoCliente
            tvc.origin = "NEW"
        }
    }
}
