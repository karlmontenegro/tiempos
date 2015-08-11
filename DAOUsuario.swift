//
//  DAOUsuario.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoUsuario {
    func newUser(nombres:String, apellidos:String,email:String,pais:String,username:String,pass:String){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("Usuario",inManagedObjectContext: context) as!NSManagedObject
        
        newUser.setValue(nombres, forKey: "nombres")
        newUser.setValue(apellidos, forKey: "apellidos")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(pais, forKey: "pais")
        newUser.setValue(username, forKey: "username")
        newUser.setValue(pass, forKey: "password")
        
        //Se consigue la fecha actual y se asigna al nuevo usuario 
        
        let fechaAlta = NSDate()
        
        newUser.setValue(fechaAlta, forKey: "fechaAlta")
        
        context.save(nil)
        
        println(newUser)

    }
    
    func signInUser(username:String, password:String)->Bool{
        
        return true
    }
    
    func signOutUser()->Bool{
        
        return true
    }
}
