//
//  NuevoUsuario.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 11/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

class NuevoUsuario: UIViewController, UIPickerViewDelegate{

    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    //Llenar con la lista completa de paises
    @IBOutlet var pickerPais: [UIPickerView]!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordVer: UITextField!
    
    var paises:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var daoCount:daoPais = daoPais()
        paises = daoCount.getAllCountries()
    }

    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return paises.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return paises[row].valueForKey("nombrePais") as! String
    }
    
    @IBAction func crearTapped(sender: AnyObject) {
        if(verifyData()){
            var daoUser:daoUsuario = daoUsuario()
            daoUser.newUser(txtNombres.text, apellidos: txtApellidos.text, email: txtEmail.text, pais: "PE", username: txtUsername.text, pass: txtPassword.text)
            //Code for debugging
            daoUser.getAllUsers()
        }else{
            println("ERROR: Las contrasenas no coinciden")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trashTapped(sender: AnyObject) {
        txtNombres.text = ""
        txtApellidos.text = ""
        txtEmail.text = ""
        txtUsername.text = ""
        txtPassword.text = ""
        txtPasswordVer.text = ""
    }

    //Extend for checking everything
    func verifyData()->Bool{
        if(txtPassword.text == txtPasswordVer.text){
            return true
        }else{
            return false
        }
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
