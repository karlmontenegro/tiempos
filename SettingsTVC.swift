//
//  SettingsTVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 29/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController,currencyOperations {

    var monto:Double = 0.0
    var moneda:String = ""
    
    @IBOutlet weak var txtMonto: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnCurrency(currency: String) {
        self.moneda = currency
        self.lblCurrency.text! = currency
    }

    @IBAction func saveTapped(sender: AnyObject) {
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "currencyModalSegue" {
            let vc:MonedaModal = segue.destinationViewController as! MonedaModal
            vc.delegateAddress = self
        }
    }

}
