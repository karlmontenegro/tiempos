//
//  DAODireccion.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class daoDireccion{
    
    var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func newAddress(usuario: Usuario, cliente:Cliente, dir:String, p:Bool){
        
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var entityAddress = NSEntityDescription.entityForName("Direccion", inManagedObjectContext: context)
        //var entityCliente = NSEntityDescription.entityForName("Cliente", inManagedObjectContext: context)
        
        var error: NSError?
        
        let newDir = Direccion(entity: entityAddress!, insertIntoManagedObjectContext: context)
        
        newDir.setValue(cliente, forKey: "cliente")
        newDir.setValue(dir, forKey: "direccion")
        newDir.setValue(p, forKey: "principal")
        
        cliente.addAddress(newDir)
        
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            //Descomentar para debugging
            println(newDir)
        }
    }
    
    func setMainAddress(dir:Direccion){
        
    }
    
    func deleteAddressAt(dir:Direccion){
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        context.deleteObject(dir)
        context.save(nil)
    }
}