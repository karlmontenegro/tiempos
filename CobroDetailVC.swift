//
//  CobroDetailVC.swift
//  Tiempos
//
//  Created by Isabel Dunin Borkowski on 28/01/16.
//  Copyright © 2016 Isabel Dunin-Borkowski. All rights reserved.
//

import UIKit

class CobroDetailVC: UIViewController{

    @IBOutlet weak var lblFechaEmision: UILabel!
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblContrato: UILabel!
    @IBOutlet weak var lblTipoFact: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var lblMontoTotal: UILabel!
    
    var rec:Recibo? = nil
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblFechaEmision.text = self.dateFormatter.stringFromDate((self.rec?.fechaEmision!)!)
        self.lblCliente.text = self.rec?.cliente?.nombre
        self.lblContrato.text = self.rec?.contrato?.nombreContrato
        
        if self.rec?.contrato?.tipoFacturacion == "HRS" {
            self.lblTipoFact.text = "Por Horas"
        } else {
            self.lblTipoFact.text = "Por Entregables"
        }
        
        self.txtDescripcion.text = self.rec?.descripcion
        self.lblMontoTotal.text = Double((self.rec?.valor)!).description
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
