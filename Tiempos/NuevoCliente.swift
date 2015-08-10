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
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newClient = NSEntityDescription.insertNewObjectForEntityForName("Cliente",inManagedObjectContext: context) as!NSManagedObject
        
        newClient.setValue(txtRUC.text, forKey: "ruc")
        newClient.setValue(txtNombre.text, forKey: "nombre")
        newClient.setValue(txtRazonSocial.text, forKey: "razonSocial")
        newClient.setValue(txtDireccion.text, forKey: "direccion")
        
        context.save(nil)
        
        //println(newClient)
        //println("Object Saved")
        
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
