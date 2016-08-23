//
//  ListTableViewController.swift
//  BookstorePin
//
//  Created by toyboy17 on 2016/8/17.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import UIKit

//定義一個反向回傳值的closure
typealias completion = (youWantToSave:NSArray) -> Void

//接收解析Json資料的暫時陣列
var temp:[BookstoresInfo] = []

//獨立書店公開資料網址
let url = "http://cloud.culture.tw/frontsite/trans/emapOpenDataAction.do?method=exportEmapJson&typeId=M"

//圖片背景執行緒下載變數宣告
//使用BookstorePin-Bridging-Header所import的AdvancedImageView.h
var advance: AdvancedImageView!


class ListTableViewController: UITableViewController {
    //宣告變數storeInfoArray去接反向傳回的值
    var storeInfoArray:[BookstoresInfo] = []

    // 宣告一個變數searchController是UISearchController型別
    var searchController:UISearchController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        //此行是右上角edit按鈕，預設會被註解起來
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //DetailViewController頁返回鍵文字消去只留<符號，title: "" 代表空值
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",style: .Plain, target: nil, action: nil)
        navigationController?.hidesBarsOnSwipe = true
        
        
        //search bar實作
        //建立UISearchController的實體 nil代表會顯示於你正在搜尋的view之中
        searchController = UISearchController(searchResultsController: nil)
        
        //在tableView的HeaderView加上搜尋欄
        tableView.tableHeaderView = searchController.searchBar
        
        //搜尋結果更新器  未完成
        //searchController.searchResultsUpdater = self
        //呈現在相同的view 設定為false
        searchController.dimsBackgroundDuringPresentation = false
        
        //placeholder 搜尋欄位預設顯示文字
        searchController.searchBar.placeholder = " 📚 Search Bookstore @ your demand. "
        
        //tintColor 修改搜尋欄cancel字顏色 whiteColor blackColor
        searchController.searchBar.tintColor = UIColor.whiteColor()
        
        //barTintColor 搜尋欄背景色
        searchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255, blue: 30.0/255.0, alpha: 1.0)
        
        //searchController.searchBar.prompt = "我是搜尋欄"
        searchController.searchBar.searchBarStyle = .Prominent
        //.Prominent正常  .Minimal半透明背景
        
        
        //呼叫Connection方法去抓Json
        Connection(url) { (youWantToSave) in
            
            self.storeInfoArray =  youWantToSave as! [BookstoresInfo]
            
            //重要！重新整理cell是改變UI，必須要在主執行緒動作
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
                
            })
        }
        
    }//我是viewDidLoad結束大括號
    
    
    //建立viewWillAppear方法  將DetailViewController頁導覽列標題更換
    //viewWillAppear  一個view準備要顯示時，將會被呼叫(will appear)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        //true代表導覽列會隨螢幕上下捲動而隱藏  DetailViewController也要加
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //重要！抓取opendata的方法Connection實作
    func Connection(url:String,Completion:completion){
        let url = NSURL(string:url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in//先判斷網址是否為nil
            
            if error == nil {
                do{
                    let jsonObj =
                        try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
                    
                    for i in 0..<jsonObj.count  {
                        
                        //有幾筆資料就創造幾個自定義的書店常數
                        let jsonStoreInfo = BookstoresInfo()
                        
                        //將需要的資料分別解析出來，並存入相對應變數
                        jsonStoreInfo.name = jsonObj[i]["name"] as! String
                        jsonStoreInfo.address = jsonObj[i]["address"] as! String
                        jsonStoreInfo.phone = jsonObj[i]["phone"] as! String
                        jsonStoreInfo.image = jsonObj[i]["representImage"] as! String
                        //json圖片以網址列顯示，為字串格式，使用as! String解析
                        
                        //將存好的每筆資料依序存入暫存陣列
                        temp.append(jsonStoreInfo)
                    }

                    //將存好的暫存陣列放入反向傳值的closure
                    Completion(youWantToSave: temp)

                }
                catch{
                    print(error)}//如果有錯就印到偵錯區
            }
        }
        
        task.resume()//必加
    }

    

    // MARK: - Table view data source
    // 實作順序 section>row>cell

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        //0修改為1，代表一個Section
    }
    
    //處理section的row
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storeInfoArray.count
        //原為allStoresInfo.count，下載json版本修改為storeInfoArray
    }

    //原先被註解，先解開此段註解，處理tableView的cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "listCell"
        //宣告一個變數cellIdentifier，連結storyboard設定的Cell，給下一行的變數listCell
        
        let listCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListTableViewCell
        //原例"reuseIdentifier"改為剛宣告的cellIdentifier，兩個""刪除
        //增加as! ListTableViewCell強制轉型，用來確認dequeueReusableCellWithIdentifier回傳的是ListTableViewCell型別
        

        //開始設定listCell
        listCell.mainPageNameLabel.text = storeInfoArray[indexPath.row].name
        listCell.mainPageAddressLabel.text = "地址：\(storeInfoArray[indexPath.row].address)"
        listCell.mainPagePhoneLabel.text = "電話：\(storeInfoArray[indexPath.row].phone)"
        //"XX：\(陣列名[indexPath.row])"  增加前綴字  XX：
        
        //重要！背景執行緒下載圖片
        listCell.storeInfoArray = storeInfoArray[indexPath.row]
        listCell.setimageFromURL()
        
        //以下註解，未使用背景執行緒，直接下載圖片
        //listCell.mainPageImageLabel.image = UIImage(contentsOfFile: storeInfoArray[indexPath.row].image)
        //let imgURL = NSURL(string: storeInfoArray[indexPath.row].image)
        //listCell.setimageFromURL(imgURL!)
        
        //if let imageData = NSData(contentsOfURL: imgURL!) {
        //  listCell.mainPageImageLabel.image = UIImage(data: imageData)
        //}
        
        listCell.mainPageImageLabel.layer.cornerRadius = 10.0//邊角的圓角程度
        listCell.mainPageImageLabel.clipsToBounds = true//設為true才會顯示圓角
        //屬性選擇器view>mode>Aspect fill 圖片最適填滿 建議使用
        
        listCell.accessoryType =
            storeInfoArray[indexPath.row].beChecked ? .Checkmark : .None
        // ? 代表if else簡化寫法 使用 : 分隔兩種動作  不是第一種則換第二種

        return listCell
    }
    

    
    //手指由右往左滑動刪除表格列的預設方法實作 關鍵字tableView commitEditingStyle
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
        //從datasource刪除列
            storeInfoArray.removeAtIndex(indexPath.row)
       
        }
        
        //通知viewController更新表格內容，將已刪除表格消去
        //tableView.reloadData()  直接刪除無動畫  或可用下一行有動畫的寫法
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //動畫參數  .Fade  .Top  .Right  .Left
        
    }//commitEditingStyle結束大括號
    

    
    //滑動帶出社群分享按鈕 關鍵字tableView editActions rowaction
    //自建刪除按鈕，不使用預設刪除按鈕
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //社群分享按鈕  分享連結功能未完成
        let shareBtn = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action,indexPath) -> Void in
            
            let defaultText = " Let's See " + self.storeInfoArray[indexPath.row].name
            let imgURL = NSURL(string: self.storeInfoArray[indexPath.row].image)
            
            //if let imageToShare = UIImage(named: self.storeInfoArray[indexPath.row].image)報錯，因為圖片為網址字串，修改如下
            
            if let imageData = NSData(contentsOfURL: imgURL!) {
                
                let imageToShare = UIImage(data: imageData)!
                
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                
                //隱藏分享選單的功能 excluded代表排除
                activityController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard]
                //UIActivityTypeMail,UIActivityTypeAssignToContact
                
                //呈現選單 presentView
                self.presentViewController(activityController, animated: true, completion: nil)
            }
        })
            
        
        //自建刪除按鈕(非預設)
//        let deleteBtn = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action, indexPath) -> Void in
//            
//            //從datasource刪除列
//            self.storeInfoArray.removeAtIndex(indexPath.row)
//            
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            //動畫參數  .Fade  .Top  .Right  .Left
//            
//        })
        
        //設定分享與刪除按鈕的顏色
        shareBtn.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
//        deleteBtn.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        return [/*deleteBtn, */shareBtn]
    }
    
    //點cell後跳轉下一頁  關鍵字prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showBookstoreDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let destinationController = segue.destinationViewController as! CellDetailViewController
                destinationController.detailPageStoresInfo = storeInfoArray[indexPath.row]
                
            }
        }
    }
    
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
