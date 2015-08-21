//
//  EditarCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 21/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class EditarCliente: UIViewController {

    var data:AnyObject = []
    
    @IBOutlet weak var lblClientName: UITextField!
    @IBOutlet weak var lblClientRUC: UITextField!
    @IBOutlet weak var lblClientRazSoc: UITextField!
    @IBOutlet weak var lblClientAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
