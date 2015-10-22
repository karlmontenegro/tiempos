//
//  EntregableVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class EntregableVC: UIViewController {

    var data:AnyObject? = []
    var moneda:String = ""
    var nro:Int = 0
    
    @IBOutlet weak var txtEntregable: UILabel!
    @IBOutlet weak var txtNomEntregable: UITextField!
    @IBOutlet weak var txtTarifa: UITextField!
    
    @IBAction func cancelTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveTapped(sender: UIButton) {
        daoEntregable().updateEntregable(txtNomEntregable.text as String!, tarifa: txtTarifa.text as String!, object: self.data as! Entregable)
        print(self.data)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEntregable.text = "Entregable " + nro.description
        // Do any additional setup after loading the view.
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
