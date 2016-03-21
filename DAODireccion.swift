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
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let entityAddress = NSEntityDescription.entityForName("Direccion", inManagedObjectContext: context)
        
        //Para uso de usuarios:usuario: Usuario
        //var entityCliente = NSEntityDescription.entityForName("Cliente", inManagedObjectContext: context)
        
        let newDir = Direccion(entity: entityAddress!, insertIntoManagedObjectContext: context)
        
        newDir.setValue(cliente, forKey: "cliente")
        newDir.setValue(dir, forKey: "direccion")
        newDir.setValue(p, forKey: "principal")
        newDir.setValue(ref1, forKey: "referenciaUno")
        newDir.setValue(ref2, forKey: "referenciaDos")
        
        cliente.addAddress(newDir)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        if cliente.direccion!.count == 1 {
            self.setMainAddress(cliente, dir: newDir)
        }
        
    }
    
    func setMainAddress(obj: Cliente, dir:Direccion){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        for direccion in (obj.direccion?.allObjects)! {
            (direccion as! Direccion).principal = false
        }

        dir.principal = true

        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func deleteAddressAt(dir:Direccion){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        context.deleteObject(dir)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    func updateAddressAt(cli: Cliente, object: Direccion, newDir: String, newRef1: String, newRef2: String, p: Bool){
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        object.setValue(newDir, forKey: "direccion")
        object.setValue(newRef1, forKey: "referenciaUno")
        object.setValue(newRef2, forKey: "referenciaDos")
        object.setValue(p, forKey: "principal")
        
        self.setMainAddress(cli, dir: object)
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
}