//
//  HistoryTVC.swift
//  isTag
//
//  Created by Domo on 20/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit
import JGProgressHUD

class HistoryTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var qrCode = ""
    var userEmail = ""
    var isTest = 0
    var accessToken = String()
    var historyItemList = WarehouseHistoryObject()
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        //rimuovo le righe extra alla fine della table
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.isTest = appDelegate.isTest
        
        loadData()
        
        historyTableView.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        historyTableView.layer.cornerRadius = 10.0
        historyTableView.tableFooterView = UIView()
    }
    
    private func showHud() {
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
    }
    
    private func hideHud() {
        self.hud.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: false)
        //navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: true)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    private func loadData() {
        
        self.showHud()
        
        var source: RequestProtocol
        if (self.isTest == 0) {
            source = Requests()
        } else {
            source = TestMockup()
        }
        
        if self.qrCode != "" {
            
            let objNetworkManager = NetworkManager(shared: source)
            objNetworkManager.shared.warehouseGetHistoryByOBject(token: self.accessToken, qRCode: self.qrCode) { (objectList) in
                
                if objectList == nil {
                    self.hideHud()
                    return
                }
                
                DispatchQueue.main.async {
                    self.hideHud()
                    self.historyItemList = objectList!
                    self.historyTableView.reloadData()
                }
                
            }
            
        }
        
        if self.userEmail != "" {
            
            let objNetworkManager = NetworkManager(shared: source)
            objNetworkManager.shared.warehouseGetHistoryByUser(token: self.accessToken, email: self.userEmail) { (objectList) in
                if objectList == nil {
                    self.hideHud()
                    return
                }
                
                DispatchQueue.main.async {
                    self.hideHud()
                    self.historyItemList = objectList!
                    self.historyTableView.reloadData()
                }
            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historyItemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyObject", for: indexPath) as! HistoryTVC_ItemCell
        
        if let owner = self.historyItemList[indexPath.row].owner {
            cell.nameLabel.text = self.historyItemList[indexPath.row].objectName//owner.name
            cell.emailLabel.text = "Preso"
            cell.iconImageView.image = UIImage(named: "get")
        } else {
            cell.nameLabel.text = self.historyItemList[indexPath.row].objectName //"Magazzino"
            cell.emailLabel.text = "Lasciato"
            cell.iconImageView.image = UIImage(named: "drop")
        }

        cell.changeDateLabel.text = self.historyItemList[indexPath.row].changeDate

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deseleziono la riga
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
