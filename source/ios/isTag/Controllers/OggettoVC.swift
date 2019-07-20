//
//  OggettoVC.swift
//  isTag
//
//  Created by Domo on 19/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import AZDialogView
import JGProgressHUD

class OggettoVC: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    
    var objectType = ""
    var isTest = 0
    var accessToken = String()
    var qrCode = ""
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var oggettoImageVIew: UIImageView!
    
    @IBOutlet weak var oggettoNameLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var inUseLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var prendiButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    var originalEmail = "d.nicoli@isolutions.it"
    var email = "d.nicoli@isolutions.it"
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.isTest = appDelegate.isTest
        
        DispatchQueue.main.async {
            self.historyButton.isHidden = true
            self.roundView(viewToRound: self.bottomView)
        }
    
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func showHud() {
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
    }
    
    private func hideHud() {
        self.hud.dismiss()
    }
    
    func roundView(viewToRound: UIView) {
        viewToRound.clipsToBounds = true
        viewToRound.layer.cornerRadius = 35
        viewToRound.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func loadData() {
        
        self.showHud()
        
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
                
                if response == nil {
                    self.hideHud()
                    return
                }
                
                DispatchQueue.main.async {
                    self.hideHud()
                    
                    self.historyButton.isHidden = false
                    self.oggettoNameLabel.text = response!.name
                    self.descriptionTextView.text = response?.warehouseDescription
                    
                    let url = URL(string: Constants.azureEndpoint + response!.picture)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.oggettoImageVIew.image = image
                    }
                    
                    if let currentOwner = response?.currentOwner {
                        self.ownerLabel.text = currentOwner.name
                        
                        // se sono io cambio il testo
                        if self.email == currentOwner.email {
                            self.prendiButton.setTitle("Lascia", for: .normal)
                        }
                        // setto la variabile globale
                        self.email = currentOwner.email
                        
                    } else {
                        self.ownerLabel.text = "Disponibile"
                    }
                }
            }
            break
        case "Consumable":
            let objNetworkManager = NetworkManager(shared: source)
            objNetworkManager.shared.consumablesGetData(token: self.accessToken, qRCode: self.qrCode) { (response) in
                
                if response == nil {
                    self.hideHud()
                    return
                }
                
                DispatchQueue.main.async {
                    self.hideHud()
                    
                    self.historyButton.isHidden = true
                    self.oggettoNameLabel.text = response?.name
                    self.descriptionTextView.text = response?.consumablesDescription
                    
                    let url = URL(string: Constants.azureEndpoint + response!.image)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        self.oggettoImageVIew.image = image
                    }
                    
                    if let isMissing = response?.isMissing {
                        if isMissing {
                            self.prendiButton.setTitle("In arrivo", for: .normal)
                            self.prendiButton.isEnabled = false
                        } else {
                            self.prendiButton.setTitle("E' finito", for: .normal)
                            self.prendiButton.isEnabled = true
                        }
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
                objNetworkManager.shared.warehouseGive(token: self.accessToken, qRCode: self.qrCode, who: self.email) { (resultString) in
                    
                    DispatchQueue.main.async {
                        
                        if self.originalEmail == resultString {
                            self.showMessage(title: "Successo", message: "Oggetto preso in carico!")
                            self.prendiButton.setTitle("Lascia", for: .normal)
                            self.ownerLabel.text = resultString
                        } else {
                            self.showMessage(title: "Successo", message: "Oggetto lasciato in magazzino!")
                            self.prendiButton.setTitle("Prendi", for: .normal)
                            self.ownerLabel.text = "Disponibile"
                        }
                        /*if resultBool {
                            self.showMessage(title: "Successo", message: "Oggetto preso in carico!")
                        } else {
                            self.showMessage(title: "Error", message: "Errore durante la richiesta!")
                        }*/
                    }
                    
                }
            break
        case "Consumable":
                let objNetworkManager = NetworkManager(shared: source)
                objNetworkManager.shared.consumablesGetMissingNotMissing(token: self.accessToken, qRCode: self.qrCode) { (resultString) in
                    
                    DispatchQueue.main.async {
                        if resultString == "Missing" {
                            self.showMessage(title: "Successo", message: "Richiesta oggetto mancante inserita con successo!")
                            self.prendiButton.setTitle("In arrivo", for: .normal)
                            self.prendiButton.isEnabled = false
                        } else if resultString == "NotMissing" {
                            self.showMessage(title: "Ripristinato", message: "Oggetto ora disponibile!")
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
    
    //Azione performata quando viene effettuato il segue tra i view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showHistory":
            let historyTVC = segue.destination as! HistoryTVC
            historyTVC.qrCode = self.qrCode
        default:
            break
        }
        
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showHistory", sender: nil)
    }
    
    
}

