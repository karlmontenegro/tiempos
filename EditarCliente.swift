//
//  EditarCliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 21/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol refreshClientData{
    func refreshClientDelegate()
}

class EditarCliente: UIViewController {

    var data:AnyObject = []
    var delegateClient:refreshClientData? = nil
    
    @IBOutlet weak var lblClientName: UITextField!
    @IBOutlet weak var lblClientRUC: UITextField!
    @IBOutlet weak var lblClientRazSoc: UITextField!

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        daoCliente().updateClient(self.data as! Cliente, nombre:lblClientName.text!, razSoc:lblClientRazSoc.text!, ruc:lblClientRUC.text!)
        delegateClient!.refreshClientDelegate()
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblClientName.text = (data as! Cliente).nombre as String
        self.lblClientRazSoc.text = (data as! Cliente).razonSocial as String
        self.lblClientRUC.text = (data as! Cliente).ruc as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
