//
//  ViewController.swift
//  Moi
//
//  Created by Eular on 15/7/26.
//  Copyright © 2015年 Eular. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appFile = NSBundle.mainBundle().URLForResource("app", withExtension: "html")
        let localRequest = NSURLRequest(URL: appFile!)
        self.webView.loadRequest(localRequest)
        self.webView.scalesPageToFit = false
        self.webView.scrollView.scrollEnabled = false
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // 获取地理位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.locationManager.stopUpdatingLocation()
            
            print("lat: \(latitude) lon: \(longitude)")
            // self.webView.stringByEvaluatingJavaScriptFromString("alert(1)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

