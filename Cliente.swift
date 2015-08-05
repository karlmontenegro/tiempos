//
//  Cliente.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation

class Cliente: NSObject{
    var name: String = ""
    var address: String = ""
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}