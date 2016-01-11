//
//  RecibosEntregablesVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosEntregablesVC: UIViewController, classifierOp {

    var origin = "ClassifierItem"
    var classifier = "Clientes"
    var client:Cliente? = nil
    var classifierItemArray:Array<Cliente>? = nil
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var classifierItemsTable: UITableView!
    @IBOutlet weak var txtClient: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnSelectedOption(selectedObject: AnyObject?, origin: String) {
        self.txtClient.text = (selectedObject as! Cliente).nombre!
        self.client = selectedObject as? Cliente
    }
    
    @IBAction func sortByClientTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("classifierPickerSegue", sender: self)
    }

    @IBAction func generateInvoiceTapped(sender: AnyObject) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Entregables no Facturados"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classifierPickerSegue" {
            let vc:ClassifierPickerModal = segue.destinationViewController as! ClassifierPickerModal
            vc.delegateAddress = self
            vc.origin = self.origin
            vc.classifier = self.classifier
        }
        if segue.identifier == "createInvoiceSegue" {

        }
    }
}
