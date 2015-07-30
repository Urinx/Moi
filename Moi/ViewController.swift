//
//  ViewController.swift
//  Moi
//
//  Created by Eular on 15/7/26.
//  Copyright © 2015年 Eular. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var jumpImg: UIButton!
    
    let locationManager:CLLocationManager = CLLocationManager()
    var avPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.jumpImg.transform = CGAffineTransformMakeScale(0, 0)
        
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
            
            getWeatherData(latitude, lon: longitude)
            // self.webView.stringByEvaluatingJavaScriptFromString("alert(1)")
        }
    }
    
    func getWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let yahoo_api = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.placefinder%20where%20text%3D%22\(lat)%2C\(lon)%22%20and%20gflags%20%3D%20%22R%22)%20and%20u=%22c%22&format=json&diagnostics="
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: yahoo_api)!), queue: NSOperationQueue(), completionHandler: {
            (resp: NSURLResponse?, data: NSData?, err: NSError?) -> Void in
            if let e = err {
                print(e)
            } else if let yahooData = data {
                let yahooJson = try! NSJSONSerialization.JSONObjectWithData(yahooData, options: NSJSONReadingOptions.AllowFragments)
                let channel = yahooJson.objectForKey("query")?.objectForKey("results")?.objectForKey("channel")
                let location = channel?.objectForKey("location")
                let wind = channel?.objectForKey("wind")
                let condition = channel?.objectForKey("item")?.objectForKey("condition")
                
                let city = location?.objectForKey("city")
                let country = location?.objectForKey("country")
                let w_direc = wind?.objectForKey("direction")
                let w_speed = wind?.objectForKey("speed")
                let humidity = channel?.objectForKey("atmosphere")?.objectForKey("humidity")
                let temp = condition?.objectForKey("temp")
                let weatherText = condition?.objectForKey("text")
                
                // 在主线程操作
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.webView.stringByEvaluatingJavaScriptFromString("setCity('\(city!)','\(country!)')")
                    self.webView.stringByEvaluatingJavaScriptFromString("setWeather('\(temp!)','\(weatherText!)','\(w_direc!)','\(w_speed!)','\(humidity!)')")
                    
                    self.soundPlay(weatherText as! String)
                })
                
            }
        })
    }
    
    func soundPlay(weatherText: String){
        
        var condition: String?
        
        let today:NSDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH" //“HH"大写强制24小时制
        let hour = NSInteger(dateFormatter.stringFromDate(today))
        
        if weatherText.hasSuffix("Rain") || weatherText.hasSuffix("Showers") {
            condition = "rain"
        }
        else if weatherText.hasSuffix("Cloudy") || weatherText.hasSuffix("Fog"){
            condition = "wind"
        }
        else if weatherText.hasSuffix("Thunderstorms"){
            condition = "thunder"
        }
        else {
            // ['Fair','Clear','Sunny'] or default
            if hour > 19 || hour < 5 {
                condition = "night"
            }
            else {
                condition = "day"
            }
        }
        
        if let cond = condition {
            self.avPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound/sound_\(cond)", ofType: "mp3")!))
            self.avPlayer.play()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, delay: 0.8, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.jumpImg.transform = CGAffineTransformScale(self.jumpImg.transform, 0.5, 0.5)
            self.jumpImg.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }, completion: {
                _ in
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.jumpImg.transform = CGAffineTransformScale(self.jumpImg.transform, 1, 1)
                    self.jumpImg.transform = CGAffineTransformRotate(self.jumpImg.transform, CGFloat(M_PI))
                    }, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

