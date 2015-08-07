//
//  NuevoCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 7/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoCliente: UIViewController {

    @IBOutlet weak var txtRUC: UITextField!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtRazonSocial: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveTapped(sender: AnyObject) {
        
        // Reference to our app delegate
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Reference Managed Object Context
        
        let contxt:NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Clientes", inManagedObjectContext: contxt)
        
        // Create an instance of our data model and initialize
        
        var newCliente = ClientesModel()
        
        // Map our properties
        
        newCliente.nombre = txtNombre.text
        newCliente.ruc = txtRUC.text
        newCliente.direccion = txtDireccion.text
        newCliente.razonSocial = txtRazonSocial.text
        
        // Save our context
        
        contxt.save(nil)
        
        println(newCliente)
        
        // Navigate back to our root view controller
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
