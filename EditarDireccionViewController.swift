//
//  EditarDireccionViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 2/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class EditarDireccionViewController: UIViewController {

    var data:AnyObject = []
    
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtReferencia1: UITextField!
    @IBOutlet weak var txtReferencia2: UITextField!
    @IBOutlet weak var prinSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
