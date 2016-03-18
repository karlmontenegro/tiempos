//
//  EntregableVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 20/10/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol entregableEditionOperations{
    func refreshTableViewForEntregables()
}

class EntregableVC: UIViewController, UITextFieldDelegate {

    var data:AnyObject? = [] //Entregable
    var moneda:Moneda? = nil
    var nro:Int = 0
    var mode:String = ""
    var delegateAddress:entregableEditionOperations? = nil
    var dueDate:NSDate? = nil
    
    @IBOutlet weak var txtEntregable: UILabel!
    @IBOutlet weak var txtNomEntregable: UITextField!
    @IBOutlet weak var txtTarifa: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var keyboardVisible:Bool = false
    var height:CGFloat? = nil
    @IBOutlet weak var heightToTop: NSLayoutConstraint!
    @IBOutlet weak var modalView: UIView!
    
    @IBAction func cancelTapped(sender: UIButton) {
        if self.mode == "NEW" {
           daoEntregable().deleteEntregableAt(self.data as! Entregable)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dateTimePickerChanged(sender: UIDatePicker) {
        self.dueDate = self.datePicker.date
    }
    
    @IBAction func saveTapped(sender: UIButton) {
        if self.txtNomEntregable.text == "" {
            self.alertMessage("El entregable debe tener un nombre.", winTitle: "Error")
        } else {
            if self.txtTarifa.text == "" {
                self.alertMessage("El entregable debe tener una tarifa.", winTitle: "Error")
            }else {
                daoEntregable().updateEntregable(txtNomEntregable.text as String!, tarifa: txtTarifa.text as String!, moneda: self.moneda!, object: self.data as! Entregable, entrega: self.dueDate)
                self.delegateAddress!.refreshTableViewForEntregables()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.enabled = false
        
        let bounds = UIScreen.mainScreen().bounds
        self.height = bounds.size.height
        self.view.layoutIfNeeded()
        self.heightToTop.constant = self.height!/2 - self.modalView.frame.height/2
        self.view.layoutIfNeeded()
        
        self.txtNomEntregable.delegate = self
        self.txtTarifa.delegate = self
        
        if mode == "NEW" {
            self.txtEntregable.text = "Nuevo Entregable"
        }else{
            self.txtEntregable.text = "Editar Entregable"
            
            if self.dueDate != nil {
                self.datePicker.date = self.dueDate!
            }
            
        }
        // Do any additional setup after loading the view.
        
        self.txtNomEntregable.text = (data as! Entregable).nombreEntreg
        
        if mode != "NEW" {
            self.txtTarifa.text = Double((data as! Entregable).tarifa!).description
        }
        
        if (self.data as! Entregable).contrato?.moneda != nil {
            self.lblCurrency.text = ((data as! Entregable).contrato?.moneda?.id)! + ((data as! Entregable).contrato?.moneda?.descripcion)!
        } else {
            self.lblCurrency.text = (self.moneda!.id)! + (self.moneda!.descripcion)!
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtNomEntregable.endEditing(true)
        self.txtTarifa.endEditing(true)
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.keyboardVisible == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(1, animations: {
                    self.heightToTop.constant -= keyboardSize.height/2
                    self.view.layoutIfNeeded()
                })
            }
            self.keyboardVisible = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.keyboardVisible == true {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(1, animations: {
                    self.heightToTop.constant += keyboardSize.height/2
                    self.view.layoutIfNeeded()
                })
            }
            self.keyboardVisible = false
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nomChanged(sender: AnyObject) {
        self.saveButton.enabled = true
    }
    
    @IBAction func tarifaChanged(sender: UITextField) {
        self.saveButton.enabled = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func alertMessage(winMessage: String, winTitle: String){
        let alertController = UIAlertController(title: winTitle, message: winMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertController) -> Void in
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
