//
//  RecibosVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/12/15.
//  Copyright © 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit
import Foundation

class RecibosVC: UIViewController, classifierOp,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var txtClassifier: UITextField!
    @IBOutlet weak var txtClassifierItem: UITextField!
    @IBOutlet weak var lblClassifier: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var classifierItemsDetailTV: UITableView!
    
    var classifierItemArray:Array<AnyObject>? = nil
    var origin:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.txtClassifier.enabled = false
        self.txtClassifierItem.enabled = false
        self.lblClassifier.text = "..."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("classifierItemCell", forIndexPath: indexPath)
        
        return cell
    }
    
    func returnSelectedOption(selectedObject: AnyObject?, origin: String) {
        if origin == "Classifier" {
            self.txtClassifier.text = selectedObject as? String
            self.lblClassifier.text = selectedObject as? String
        } else {
            
        }
    }
    
    @IBAction func addClassifierTapped(sender: AnyObject) {
        self.origin = "Classifier"
        self.performSegueWithIdentifier("classifierPickerSegue", sender: self)
    }

    @IBAction func addClassifierItemTapped(sender: AnyObject) {
        self.origin = "ClassifierItem"
        self.performSegueWithIdentifier("classifierPickerSegue", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classifierPickerSegue" {
            let vc:ClassifierPickerModal = segue.destinationViewController as! ClassifierPickerModal
            vc.delegateAddress = self
            vc.origin = self.origin
        }
    }
}
