//
//  CreditsVC.swift
//  Aurora
//
//  Created by Domenico Nicoli on 23/04/2019.
//  Copyright © 2019 Domenico Nicoli. All rights reserved.
//

import UIKit

class CreditsVC: UIViewController {
    
    @IBOutlet var textViewCredits: UITextView!
    
    override func viewDidLoad() {
        
        textViewCredits.isEditable = false
        
        //carico e visualizzo il file con i crediti
        do {
            let path = Bundle.main.path(forResource: "License", ofType: "txt")
            textViewCredits.text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            print("errore file License non trovato")
        }
        
    }
    
}
