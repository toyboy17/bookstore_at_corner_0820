//
//  BookstoreDetailTableViewCell.swift
//  BookstorePin
//
//  Created by toyboy17 on 2016/8/18.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit

class BookstoreDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
