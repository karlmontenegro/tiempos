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
        
        //self.parentViewController?.childViewControllers[1].refreshControl?!.beginRefreshing()
        
        delegateAddress!.refreshAddressesDelegate()
        
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
