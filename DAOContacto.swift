//
//  DAOContacto.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 14/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import Foundation
import CoreData
import AddressBook

class daoContacto{
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    func newContact(){
        
    }
    
    func getAllContacts()->NSArray{
        var contactArray:NSArray = ABAddressBookCopyArrayOfAllPeople(self.addressBookRef).takeRetainedValue()
        return contactArray
    }
}