//
//  NotaAudio.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation

class NotaAudio: NSObject{
    var filename: String = ""
    var duration: String = ""
    
    init(filename: String, duration: String) {
        self.filename = filename
        self.duration = duration
    }
}