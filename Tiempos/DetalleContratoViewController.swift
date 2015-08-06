//
//  DetalleContratoViewController.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 5/08/15.
//  Copyright (c) 2015 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class DetalleContratoViewController: UIViewController {

    var datas = Contrato(name: "", cliente: "", tipo: "")
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var cliente: UILabel!
    @IBOutlet weak var tipo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombre.text = datas.name
        cliente.text = datas.cliente
        tipo.text = datas.tipo

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
