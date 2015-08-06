//
//  Contratos.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation

class Contrato: NSObject{
    var name: String = ""
    var cliente: String = ""
    var tipo: String = ""
    
    init(name: String, cliente: String, tipo: String) {
        self.name = name
        self.cliente = cliente
        self.tipo = tipo
    }
}