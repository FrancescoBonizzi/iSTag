//
//  SettingsTVC.swift
//  isTag
//
//  Created by Domenico Nicoli on 22/04/2019.
//  Copyright © 2019 Domenico Nicoli. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    var arraySettings = ["credits","version"]
    
    override func viewDidLoad() {
        //rimuovo le righe extra alla fine della table
        tableView.tableFooterView = UIView()
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var itemCount = 0
        
        //sezione settings
        if section == 0 {
            itemCount = arraySettings.count
        }
        
        return itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        //sezione Settings
        if indexPath.section == 0 {
            if let cellOthers = tableView.dequeueReusableCell(withIdentifier: "settingCell") {
                
                switch arraySettings[indexPath.row] {
                case "credits":
                    cellOthers.textLabel?.text = "Crediti"
                    cellOthers.detailTextLabel?.text = ""
                    cellOthers.accessoryType = .disclosureIndicator
                case "version":
                    cellOthers.textLabel?.text = "Versione"
                    
                    let dictionary = Bundle.main.infoDictionary!
                    let version = dictionary["CFBundleShortVersionString"] as! String
                    let build = dictionary["CFBundleVersion"] as! String
                    
                    cellOthers.detailTextLabel?.text = "\(version) (\(build))"
                default:
                    break
                }
                
                cell = cellOthers
            }
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        // creo la view per la section
        case 0:
            return "Impostazioni"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deseleziono la riga
        tableView.deselectRow(at: indexPath, animated: true)
    
        if indexPath.section == 0 {
            switch arraySettings[indexPath.row] {
            case "credits":
                //lo passo alla pagina dei crediti
                self.performSegue(withIdentifier: "credits", sender: nil)
            case "version":
                print("version tapped")
            default:
                break
            }
        }
        
    }

    
}
