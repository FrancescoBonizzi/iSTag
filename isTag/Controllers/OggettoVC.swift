//
//  OggettoVC.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import AZDialogView

class OggettoVC: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    
    var objectType = ""
    var isTest = 0
    var accessToken = String()
    var qrCode = ""
    
    @IBOutlet weak var oggettoImageVIew: UIImageView!
    
    @IBOutlet weak var oggettoNameLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var inUseLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var prendiButton: UIButton!
    
    var email = ""
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.isTest = appDelegate.isTest
        
        DispatchQueue.main.async {
            self.roundView(viewToRound: self.bottomView)
        }
    
        loadData()
        
    }
    
    func roundView(viewToRound: UIView) {
        viewToRound.clipsToBounds = true
        viewToRound.layer.cornerRadius = 35
        viewToRound.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func loadData() {
        
        var source: RequestProtocol
        if (self.isTest == 0) {
            source = Requests()
        } else {
            source = TestMockup()
        }
        
        switch self.objectType {
        case "Warehouse":
            let objNetworkManager = NetworkManager(shared: source)
            objNetworkManager.shared.warehouseGetData(token: self.accessToken, qRCode: self.qrCode) { (response) in
                
                if response == nil { return }
                
                DispatchQueue.main.async {
                    self.oggettoNameLabel.text = response?.name
                    self.descriptionTextView.text = response?.warehouseDescription
                    
                    let url = URL(string: Constants.azureEndpoint + response!.picture)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.oggettoImageVIew.image = image
                    }
                    
                    if let currentOwner = response?.currentOwner {
                        //self.ownerView.isHidden = false
                        //self.inUseLabel.isHidden = false
                        self.ownerLabel.text = currentOwner.name
                        self.email = currentOwner.email
                    }
                }
            }
            break
        case "Consumable":
            let objNetworkManager = NetworkManager(shared: source)
            objNetworkManager.shared.consumablesGetData(token: self.accessToken, qRCode: self.qrCode) { (response) in
                
                if response == nil { return }
                
                DispatchQueue.main.async {
                    self.oggettoNameLabel.text = response?.name
                    self.descriptionTextView.text = response?.consumablesDescription
                    
                    let url = URL(string: Constants.azureEndpoint + response!.image)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.oggettoImageVIew.image = image
                    }
                    
                    self.ownerView.isHidden = true

                }
            }
            break
        default:
            break
        }
        
        
                
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func prendiButton(_ sender: Any) {
        
        if self.qrCode == "" {return}
        if self.email == "" && self.objectType == "Warehouse" {return}
        
        var source: RequestProtocol
        if (self.isTest == 0) {
            source = Requests()
        } else {
            source = TestMockup()
        }
        
        switch self.objectType {
        case "Warehouse":
                let objNetworkManager = NetworkManager(shared: source)
                objNetworkManager.shared.warehouseGive(token: self.accessToken, qRCode: self.qrCode, who: self.email) { (resultBool) in
                    
                    DispatchQueue.main.async {
                        if resultBool {
                            self.showMessage(title: "Successo", message: "Oggetto preso in carico!")
                        } else {
                            self.showMessage(title: "Error", message: "Errore durante la richiesta!")
                        }
                    }
                    
                }
            break
        case "Consumable":
                let objNetworkManager = NetworkManager(shared: source)
                objNetworkManager.shared.consumablesGetMissingNotMissing(token: self.accessToken, qRCode: self.qrCode) { (resultString) in
                    
                    DispatchQueue.main.async {
                        if resultString == "Missing" {
                            self.showMessage(title: "Successo", message: "Richiesta oggetto mancante inserita con successo!")
                            self.prendiButton.setTitle("Ora c'è", for: .normal)
                        } else if resultString == "NotMissing" {
                            self.showMessage(title: "Ripristinato", message: "Oggetto ora disponibile!")
                            self.prendiButton.setTitle("Prendi", for: .normal)
                        } else {
                            self.showMessage(title: "Error", message: "Errore durante la richiesta!")
                        }
                    }
                }
                
            break
        default:
            break
        }
        
        
        
    }
    
    private func showMessage(title: String, message: String) {
        
        let dialog = AZDialogViewController(title: title, message: message, verticalSpacing: -1, buttonSpacing: 10, sideSpacing: 20, titleFontSize: 25, messageFontSize: 17, buttonsHeight: 0, cancelButtonHeight: 0, fontName: "AvenirNext-Medium", boldFontName: "AvenirNext-DemiBold")
        //set the title color
        dialog.titleColor = UIColor.blue
        //set the message color
        dialog.messageColor = .black
        
        //enable/disable drag
        dialog.allowDragGesture = true
        
        //allow dismiss by touching the background
        dialog.dismissWithOutsideTouch = false
        
        //enable rubber (bounce) effect
        dialog.rubberEnabled = true
        
        dialog.addAction(AZDialogAction(title: "OK") { (dialog) -> (Void) in
            
            dialog.dismiss()
            
        })
        self.present(dialog, animated: false, completion: nil)
        //dialog.show(in: )
        
    }
    
}

