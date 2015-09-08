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
    func newAddress(cliente:Cliente, dir:String, ref1:String, ref2:String, p:Bool){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var entityAddress = NSEntityDescription.entityForName("Direccion", inManagedObjectContext: context)
        
        //Para uso de usuarios:usuario: Usuario
        //var entityCliente = NSEntityDescription.entityForName("Cliente", inManagedObjectContext: context)
        
        var error: NSError?
        
        let newDir = Direccion(entity: entityAddress!, insertIntoManagedObjectContext: context)
        
        newDir.setValue(cliente, forKey: "cliente")
        newDir.setValue(dir, forKey: "direccion")
        newDir.setValue(p, forKey: "principal")
        newDir.setValue(ref1, forKey: "referenciaUno")
        newDir.setValue(ref2, forKey: "referenciaDos")
        
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
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        context.deleteObject(dir)
        context.save(nil)
    }
    func updateAddressAt(object: Direccion, newDir: String, newRef1: String, newRef2: String, p: Bool){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        object.setValue(newDir, forKey: "direccion")
        object.setValue(newRef1, forKey: "referenciaUno")
        object.setValue(newRef2, forKey: "referenciaDos")
        object.setValue(p, forKey: "principal")
        
        context.save(nil)
    }
}