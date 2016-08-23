//
//  ListTableViewCell.swift
//  BookstorePin
//
//  Created by toyboy17 on 2016/8/17.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mainPageImageLabel: AdvancedImageView!

    @IBOutlet weak var mainPageNameLabel: UILabel!
    
    @IBOutlet weak var mainPagePhoneLabel: UILabel!
    
    @IBOutlet weak var mainPageAddressLabel: UILabel!
    
    var storeInfoArray:BookstoresInfo?
    
    //重要！json無圖片時使用自定義圖片
    func setimageFromURL() {
        if storeInfoArray?.image == "" {
            mainPageImageLabel.image = UIImage(named: "alisa.jpg")
        } else {
            let url:NSURL = NSURL(string: (storeInfoArray?.image)!)!
            mainPageImageLabel?.loadImageWithURL(url)
        }
    }//class結束括號
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


