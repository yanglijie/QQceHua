//
//  ViewController.swift
//  QQCeHua
//
//  Created by famesmart on 16/9/1.
//  Copyright © 2016年 famesmart. All rights reserved.
//

import UIKit

struct Common {
    static let screenWidth = UIScreen.mainScreen().applicationFrame.maxX
    static let screenHeight = UIScreen.mainScreen().applicationFrame.maxY
}

class ViewController: UIViewController {

    var homeViewController : HomeViewController!
    var distance : CGFloat = 0
    let FullDistance : CGFloat = 0.78
    let Proportion : CGFloat = 0.77
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageView = UIImageView(image: UIImage(named: "140919103I7-12"))
        imageView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(imageView)
        
        //通过StoryBoard取出HomeViewController 的View，放在背景视图上
        homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.view.addSubview(homeViewController.view)
        
        //绑定 UIPanGestureRecognizer
        homeViewController.panGesture.addTarget(self, action: Selector("pan:"))
        
        
    }
    func pan(recongnizer:UIPanGestureRecognizer){
        
        let x = recongnizer.translationInView(self.view).x
        print("33333====\(x)")
        let trueDistance = distance + x
        
        //如果UIPanGesture 结束，则激活自动停靠
        if recongnizer.state == UIGestureRecognizerState.Ended{
            if trueDistance > Common.screenWidth * (Proportion / 3){
                showLeft()
            }else if trueDistance < Common.screenWidth * -(Proportion / 3){
                showRight()
            }
            else{
                showHome()
            }
            return
        }
        
        
        var proportion:CGFloat = recongnizer.view!.frame.origin.x >= 0 ? -1 : 1
        proportion *= trueDistance / Common.screenWidth
        proportion *= 1 - Proportion
        proportion /= 0.6
        proportion += 1
        if proportion <= Proportion{//如果比例已经达到最小，则不再继续动画
            return
        }
        //执行平移和缩放动画
        recongnizer.view!.center = CGPointMake(self.view.center.x + trueDistance, self.view.center.y )
        recongnizer.view!.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
        
    }
    
    //展示左视图
    func showLeft(){
        distance = self.view.center.x * (FullDistance + Proportion / 2)
        doTheAnimate(self.Proportion)
    }
    //展示主视图
    func showHome(){
        distance = 0
        doTheAnimate(1)
    }
    //展示右视图
    func showRight(){
        distance = self.view.center.x * -(FullDistance + Proportion / 2)
        doTheAnimate(self.Proportion)
    }
    
    //执行三种动画
    func doTheAnimate(proportion:CGFloat){
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.homeViewController.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y)
            self.homeViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion)
            }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
class HomeViewController: UIViewController {
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

