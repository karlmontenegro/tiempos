//
//  TextInputTableViewCell.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 18/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

protocol textInputOp {
    func returnTextValue(text:String, placeholder:String)
}

class TextInputTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    var delegateAddress:textInputOp? = nil
    
    func configure(text text: String?, placeholder: String) {
        txtName.text = text
        txtName.placeholder = placeholder
        
        txtName.accessibilityValue = text
        txtName.accessibilityLabel = placeholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtName.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func textEditChanged(sender: UITextField) {
        self.delegateAddress?.returnTextValue(self.txtName.text!, placeholder: self.txtName.placeholder!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtName.endEditing(true)
        return false
    }
}
