//
//  DetalleClienteViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class DetalleClienteViewController: UIViewController {

    var data:AnyObject = []
    
    @IBOutlet weak var lblRazonSocial: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTitle.title = data.valueForKey("nombre") as! String?
        lblRazonSocial.text = "Razón Social: " + (data.valueForKey("razonSocial") as! String?)!
        lblRUC.text = "RUC: " + (data.valueForKey("ruc") as! String?)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addAddressTapped(sender: AnyObject) {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "contactTableSegue"){
            let tvc:ContactosPorClienteTableViewController = segue.destinationViewController as! ContactosPorClienteTableViewController
            
            tvc.contactData = (self.data as! Cliente).contacto
        }
        if(segue.identifier == "addressTableSegue"){
            let tvc:DireccionesPorClienteTableViewController = segue.destinationViewController as! DireccionesPorClienteTableViewController
            
            tvc.addressData = (self.data as! Cliente).direccion
        }
    }

}
