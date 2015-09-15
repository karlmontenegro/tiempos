//
//  DetalleContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class DetalleContratoViewController: UIViewController {

    var data:AnyObject = []
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cliente: UILabel!
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle.title = (self.data as! Contrato).valueForKey("nombreContrato") as! String?
        tipo.text = (self.data as! Contrato).valueForKey("tipoFacturacion") as! String?
        cliente.text = (((self.data as! Contrato).valueForKey("cliente")) as! Cliente).valueForKey("nombre") as! String?
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
