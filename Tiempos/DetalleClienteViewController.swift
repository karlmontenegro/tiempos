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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRazonSocial: UILabel!
    @IBOutlet weak var lblRUC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = data.valueForKey("nombre") as! String?
        lblAddress.text = data.valueForKey("direccion") as! String?
        lblRazonSocial.text = data.valueForKey("razonSocial") as! String?
        lblRUC.text = data.valueForKey("ruc") as! String?
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
