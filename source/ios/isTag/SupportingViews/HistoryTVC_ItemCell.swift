//
//  HistoryTVC_ItemCell.swift
//  isTag
//
//  Created by Domo on 20/07/2019.
//  Copyright © 2019 Domo. All rights reserved.
//

import UIKit

class HistoryTVC_ItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var changeDateLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func layoutSubviews() {
        // Set the width of the cell
        super.layoutSubviews()
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 30, height: self.bounds.size.height - 10)
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
    }

    
}
