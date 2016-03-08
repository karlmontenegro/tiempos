//
//  EditarDireccionViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 2/09/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol refreshAddressTableAfterEdit{
    func refreshAddressesDelegate()
}
class EditarDireccionViewController: UIViewController,UITextFieldDelegate {

    var data:AnyObject = []
    var delegateAddress:refreshAddressTable? = nil
    
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtReferencia1: UITextField!
    @IBOutlet weak var txtReferencia2: UITextField!
    @IBOutlet weak var prinSwitch: UISwitch!
    @IBOutlet weak var modalView: UIView!
    
    var keyboardVisible:Bool = false
    var height:CGFloat? = nil
    
    @IBOutlet weak var heightToTop: NSLayoutConstraint!

    
    override func viewWillAppear(animated: Bool) {
        //Screen size
        
        let bounds = UIScreen.mainScreen().bounds
        self.height = bounds.size.height
        self.view.layoutIfNeeded()
        self.heightToTop.constant = self.height!/2 - self.modalView.frame.height/2
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtDireccion.delegate = self
        self.txtReferencia1.delegate = self
        self.txtReferencia2.delegate = self
        
        self.txtDireccion.text = (data as! Direccion).direccion!
        self.txtReferencia1.text = (data as! Direccion).referenciaUno!
        self.txtReferencia2.text = (data as! Direccion).referenciaDos!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        if (data as! Direccion).principal as! Bool {
            self.prinSwitch.setOn(true, animated:true)
        }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtDireccion.endEditing(true)
        self.txtReferencia1.endEditing(true)
        self.txtReferencia2.endEditing(true)
        return false
    }
    
    @IBAction func saveTapped(sender: UIBarButtonItem) {
        daoDireccion().updateAddressAt((self.data as! Direccion).valueForKey("cliente") as! Cliente,object: self.data as! Direccion, newDir: self.txtDireccion.text!, newRef1: self.txtReferencia1.text!, newRef2: self.txtReferencia2.text!, p: self.prinSwitch.on)
        
        //self.parentViewController?.childViewControllers[1].beginRefreshing()
        
        delegateAddress!.refreshAddressesDelegate()
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        delegateAddress!.refreshAddressesDelegate()
        dismissViewControllerAnimated(true, completion: nil)
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
