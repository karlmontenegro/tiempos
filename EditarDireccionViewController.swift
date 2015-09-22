//
//  EditarDireccionViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 2/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol refreshAddressTableAfterEdit{
    func refreshAddressesDelegate()
}
class EditarDireccionViewController: UIViewController {

    var data:AnyObject = []
    var delegateAddress:refreshAddressTable? = nil
    
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtReferencia1: UITextField!
    @IBOutlet weak var txtReferencia2: UITextField!
    @IBOutlet weak var prinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtDireccion.text = (data as! Direccion).direccion as String
        self.txtReferencia1.text = (data as! Direccion).referenciaUno as String
        self.txtReferencia2.text = (data as! Direccion).referenciaDos as String
        
        if (data as! Direccion).principal as Bool {
            self.prinSwitch.setOn(true, animated:true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        daoDireccion().updateAddressAt(self.data as! Direccion, newDir: self.txtDireccion.text!, newRef1: self.txtReferencia1.text!, newRef2: self.txtReferencia2.text!, p: self.prinSwitch.on)
        
        //self.parentViewController?.childViewControllers[1].beginRefreshing()
        
        delegateAddress!.refreshAddressesDelegate()
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
