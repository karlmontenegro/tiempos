//
//  NuevaDireccionViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

protocol refreshAddressTable{
    func refreshAddressesDelegate()
}

class NuevaDireccionViewController: UIViewController {

    var data:AnyObject = []    
    var delegateAddress:refreshAddressTable? = nil
    
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var refUno: UITextField!
    @IBOutlet weak var refDos: UITextField!
    @IBOutlet weak var prinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButton(sender: UIBarButtonItem) {
       
        daoDireccion().newAddress(data as! Cliente, dir: self.direccion.text!,ref1: self.refUno.text!,ref2: self.refDos.text!, p: prinSwitch.on)
    
        delegateAddress!.refreshAddressesDelegate()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
