//
//  HomeViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 9/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "contractView"{
            var clientes = daoCliente().getAllClients()
            
            if clientes.count > 0 {
                return true
            }else{
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Debe haber por lo menos un cliente al cual asociar el contrato"
                alert.addButtonWithTitle("OK")
                alert.show()
                return false
            }
        }
        return true
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
