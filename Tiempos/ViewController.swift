//
//  ViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin-Borkowski on 7/20/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var daoCount:daoPais = daoPais()
        //daoCount.seedCountries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        var daoUser:daoUsuario = daoUsuario()
        var tup = daoUser.signInUser(txtUser.text, password: txtPass.text)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if tup.0{
            println(tup.1)
            defaults.setObject((tup.2), forKey: "loggedUserKey")
            performSegueWithIdentifier("loginDashboard", sender: sender)
        }else{
            println(tup.1)
        }
        
    }
}

