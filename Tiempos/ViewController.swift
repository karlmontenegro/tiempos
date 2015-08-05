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
        
        let filemgr = NSFileManager.defaultManager()
        
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let databasePath = documentsFolder.stringByAppendingPathComponent("tiempos.sqlite")
        
        if filemgr.fileExistsAtPath(databasePath as String){

            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil{
                println("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open(){
                let sql_stmt = "SELECT * FROM 'Usuario'"
                
                let results: FMResultSet? = contactDB.executeQuery(sql_stmt, withArgumentsInArray: nil)
                
                if results?.next() == true {
                    println(results)
                } else {
                    println("not found")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

