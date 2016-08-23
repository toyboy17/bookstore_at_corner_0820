//
//  CellDetailViewController.swift
//  BookstorePin
//
//  Created by toyboy17 on 2016/8/17.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit

class CellDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bookstoreImageView: UIImageView!
    
    var detailPageStoresInfo:BookstoresInfo!
    //!代表有效解析  不會是空值
    
    //自己增加viewDidLoad方法
    //viewDidLoad方法在CellDetailViewController載入記憶體時會被呼叫
    //在storyboard編輯器選擇sugue，identifier設showBookstoreDetail
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //載入書店的Json圖片，若無圖片則使用自定義圖片
        if detailPageStoresInfo.image == "" {
            bookstoreImageView.image = UIImage(named: "alisa.jpg")
        } else {
            let imgURL = NSURL(string: detailPageStoresInfo.image)
            if let imageData = NSData(contentsOfURL: imgURL!) {
                bookstoreImageView.image = UIImage(data: imageData)
            }
        }
      
        //設定DetailViewController頁面的標題文字
        title = detailPageStoresInfo.name
    }
    
    //建立viewWillAppear方法  將DetailViewController頁導覽列標題更換
    //viewWillAppear  一個view準備要顯示時，將會被呼叫(will appear)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        //false代表DetailViewController頁的導覽列不會上下滑動，免得<鍵消失於螢幕範圍
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //重要！row最適化高度的方法 關鍵字estimatedHeightForRowAtIndexPath
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        return 60.0
    }
    
    //設定Cell的row數
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BookstoreDetailTableViewCell
        
        //設定cell
        switch indexPath.row {
        case 0:
            Cell.fieldLabel.text = "Name"
            Cell.valueLabel.text = detailPageStoresInfo.name
        case 1:
            Cell.fieldLabel.text = "Phone"
            Cell.valueLabel.text = detailPageStoresInfo.phone
        case 2:
            Cell.fieldLabel.text = "Address"
            Cell.valueLabel.text = detailPageStoresInfo.address
        case 3:
            Cell.fieldLabel.text = "Been Here"
            Cell.valueLabel.text = (detailPageStoresInfo.beChecked) ? "been here before" : "No"
        default:
            Cell.fieldLabel.text = ""
            Cell.valueLabel.text = ""
            
        }
        
        return Cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as! MapViewController
            destinationController.detailPageStoresInfo = detailPageStoresInfo
        }
    }

}