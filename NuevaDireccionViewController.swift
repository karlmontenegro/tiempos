//
//  NuevaDireccionViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import CoreData

protocol refreshAddressTable{
    func refreshAddressesDelegate()
}

class NuevaDireccionViewController: UIViewController,UITextFieldDelegate {

    var data:AnyObject = []    
    var delegateAddress:refreshAddressTable? = nil
    var keyboardVisible:Bool = false
    
    var height:CGFloat? = nil
    
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var refUno: UITextField!
    @IBOutlet weak var refDos: UITextField!
    @IBOutlet weak var prinSwitch: UISwitch!
    @IBOutlet weak var modalContentView: UIView!
    
    @IBOutlet weak var heightToTop: NSLayoutConstraint!

    override func viewWillAppear(animated: Bool) {
        //Screen size
        
        let bounds = UIScreen.mainScreen().bounds
        self.height = bounds.size.height
        self.view.layoutIfNeeded()
        self.heightToTop.constant = self.height!/2 - self.modalContentView.frame.height/2
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.direccion.delegate = self
        self.refUno.delegate = self
        self.refDos.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NuevaDireccionViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NuevaDireccionViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.direccion.endEditing(true)
        self.refUno.endEditing(true)
        self.refDos.endEditing(true)
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
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButton(sender: UIBarButtonItem) {
       
        daoDireccion().newAddress(data as! Cliente, dir: self.direccion.text!,ref1: self.refUno.text!,ref2: self.refDos.text!, p: prinSwitch.on)
    
        delegateAddress!.refreshAddressesDelegate()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
