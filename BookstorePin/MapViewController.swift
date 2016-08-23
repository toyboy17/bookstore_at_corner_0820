//
//  MapViewController.swift
//  BookstorePin
//
//  Created by toyboy17 on 2016/8/19.
//  Copyright © 2016年 @ demand;. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var detailPageStoresInfo:BookstoresInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //定義IBoutlet拉入的mapview代理為self(MapViewController)
        mapView.delegate = self
        
        //將地址轉換成座標 標註在地圖上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(detailPageStoresInfo.address, completionHandler: { Placemarks, error in
            
            if error != nil {
                print(error)
                return
            }
            if let Placemarks = Placemarks {
                //取得第一個地標
                let placemark = Placemarks[0]
                
                //加上標注
                let annotation = MKPointAnnotation()
                annotation.title = self.detailPageStoresInfo.name
                annotation.subtitle = self.detailPageStoresInfo.phone
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //顯示標注
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        
        mapView.showsCompass = true//顯示指南針？？
        
    }//viewdidload結束
    
    
    //修改annotation view(大頭針)，需實作viewForAnnotation方法
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        //如果可以的話回收使用這個annotation 關鍵字dequeueReusableAnnotationViewWithIdentifier
        var  annotationView:MKPinAnnotationView? =
            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        leftIconView.image = UIImage(named: detailPageStoresInfo.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
