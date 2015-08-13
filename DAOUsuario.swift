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
        
        //Paso 1: Conseguir contexto y entidad destino
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityUsuario = NSEntityDescription.entityForName("Usuario",
            inManagedObjectContext:context)
        var entityPais = NSEntityDescription.entityForName("Pais", inManagedObjectContext: context)
        let request = NSFetchRequest()
        request.entity = entityPais
        let pred = NSPredicate(format: "(id = %@)", pais)
        request.predicate = pred
        
        var error: NSError?
        
        //Paso 2: Invocar un nuevo objeto subclase de la entidad destino
        
        let nuevo = Usuario(entity: entityUsuario!, insertIntoManagedObjectContext: context)

        //Paso 3: Llenar los datos del objeto
        
        nuevo.setValue(nombres, forKey: "nombres")
        nuevo.setValue(apellidos, forKey: "apellidos")
        nuevo.setValue(email, forKey: "email")
        nuevo.setValue(username, forKey: "username")
        nuevo.setValue(pass, forKey: "password")
        
        //Se consigue la fecha actual y se asigna al nuevo usuario 
        
        let fechaAlta = NSDate()
        
        nuevo.setValue(fechaAlta, forKey: "fechaAlta")
        
        //Se consigue el país seleccionado como parámetro
        
        var results = context.executeFetchRequest(request, error: &error)
        
        nuevo.setValue(results?.first as! Pais, forKey: "pais")
        nuevo.setValue(nil, forKey: "clientes")
        
        //Paso 4: Guardar el objeto en la entidad, controlando errores
        
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }else{
            //Descomentar para debugging
            //println(nuevo)
        }
    }
    
    func signInUser(username:String, password:String)->(Bool,String,NSManagedObjectID?){
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityUsuario = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        let pred = NSPredicate(format: "(username = %@)", username)
        var error: NSError?
        
        request.predicate = pred
        request.entity = entityUsuario
        
        var results = context.executeFetchRequest(request, error: &error)
        
        if results?.count > 0{
            if (results?.first as! Usuario).password == password{
                return (true,"Login success!",(results?.first as! Usuario).objectID)
            }else{
                return (false,"Contraseña incorrecta, por favor intente nuevamente",nil)
            }
        }else{
            return (false,"Usuario incorrecto, por favor ingreselo nuevamente",nil)
        }
    }
    
    func signOutUser()->Bool{
        
        return true
    }
    
    //Funciones para debugging
    
    func getAllUsers(){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var entityUsuario = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: context)
        
        let request = NSFetchRequest()
        request.entity = entityUsuario
        
        var error: NSError?
        
        var results = context.executeFetchRequest(request, error: &error)
        
        for result in results! as! [Usuario]{
            println("OBJ - USUARIO")
            println("- Nombre: " + result.nombres)
            println("- Apellidos: " + result.apellidos)
            println("- Email: " + result.email)
            println("- Pais: " + (result.pais).id)
            println("- Username: " + result.username)
            println("- Password: " + result.password)
        }
    }
}
