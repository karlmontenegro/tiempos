//
//  HomeVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 10/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import EventKit
import AddressBook
import AddressBookUI


class HomeVC: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lblwelcome: UILabel!
    
    let eventStore = EKEventStore()
    var addressBookRef: ABAddressBook? = nil
    var defaultCalendar: EKCalendar? = nil
    var dateSync:DateBatchImport? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblwelcome.text = "Hola"
        
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
        checkAccessForCalendar()
        checkAccessForAddressBook()
        
        self.defaultCalendar = daoCalendar().getCalendar("Freelo Calendar", store: self.eventStore)
        self.dateSync = DateBatchImport.init(eS: eventStore, c: defaultCalendar)
        self.dateSync!.importCalendarDatesToDataBase(-1, endDate: NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calendar Auth
    
    func checkAccessForCalendar(){
        
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
            
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            self.eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error: NSError?) in
                if accessGranted == true {
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.dateTableView.reloadData()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                }
            }
            
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            break
        
        case EKAuthorizationStatus.Denied:
            self.goToSettingsWindow()
            break
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            // We need to help them give us permission
            break
        }
    }
    
    //Address Book Auth
    
    func checkAccessForAddressBook(){
    
        let status = ABAddressBookGetAuthorizationStatus()
        
        switch (status) {
            
            case ABAuthorizationStatus.Authorized:
                //print("Authorized")
                //Ready to go!
                break
        
            case ABAuthorizationStatus.Denied:
                self.goToSettingsWindow()
                break
            
            case ABAuthorizationStatus.NotDetermined:
                //First run
                ABAddressBookRequestAccessWithCompletion(self.addressBookRef, {
                    (granted : Bool, error: CFError!) -> Void in
                    if granted == true
                    {
                        self.addressBookRef = ABAddressBookCreateWithOptions(nil , nil).takeRetainedValue()
                        
                    }else {
                        
                    }
                })

                break
            
            case ABAuthorizationStatus.Restricted:
                print("Restricted")
                break
        }
    }

    func goToSettingsWindow() {
        print("Go to settings window here!")
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
