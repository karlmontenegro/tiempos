//
//  TextInputTableViewCell.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 18/02/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {

    @IBOutlet weak var txtName: UITextField!
    
    func configure(text text: String?, placeholder: String) {
        txtName.text = text
        txtName.placeholder = placeholder
        
        txtName.accessibilityValue = text
        txtName.accessibilityLabel = placeholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
