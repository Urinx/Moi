//
//  AboutViewController.swift
//  Waither
//
//  Created by Eular on 15/7/25.
//  Copyright © 2015年 Eular. All rights reserved.
//

import UIKit
import Social

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func share(forServiceType shareMethod: String){
        let controller: SLComposeViewController = SLComposeViewController(forServiceType: shareMethod)
        controller.setInitialText("我在使用 Moi 天気予報，不给人生留遗憾，不再错过每一天。http://urinx.github.io/app/moi/")
        controller.addImage(UIImage(named: "shareImg"))
        self.presentViewController(controller, animated: true, completion: nil)
    }
    func sendLinkContent(_scene: Int32, title: String){
        let message =  WXMediaMessage()
        
        message.title = title
        message.description = "不给人生留遗憾，不想错过每一天"
        message.setThumbImage(UIImage(named:"shareImg"))
        
        let ext =  WXWebpageObject()
        ext.webpageUrl = "http://urinx.github.io/app/moi/"
        message.mediaObject = ext
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = _scene
        WXApi.sendReq(req)
    }
    
    @IBAction func twitterTapped(sender: AnyObject) {
        share(forServiceType: SLServiceTypeTwitter)
    }
    @IBAction func sinaTapped(sender: AnyObject) {
        share(forServiceType: SLServiceTypeSinaWeibo)
    }
    @IBAction func wechatTapped(sender: AnyObject) {
        sendLinkContent(WXSceneSession.rawValue, title: "Moi - 天気予報")
    }
    @IBAction func wechatCircleTapped(sender: AnyObject) {
        sendLinkContent(WXSceneTimeline.rawValue, title: "不给人生留遗憾，不想错过每一天")
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
