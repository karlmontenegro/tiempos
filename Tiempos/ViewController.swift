//
//  ViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin-Borkowski on 7/20/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let path = documents.stringByAppendingPathComponent("tiempos.sqlite")
        
        // open database
        
        var db: COpaquePointer = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            println("Error opening database")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

