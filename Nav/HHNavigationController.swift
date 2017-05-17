//
//  HHNavigationController.swift
//  Nav
//
//  Created by boitx on 2017/5/15.
//  Copyright © 2017年 boitx. All rights reserved.
//

import UIKit

class HHNavigationController: UINavigationController, UIGestureRecognizerDelegate{
    
    let kDefaultAlpha = 0.6
    let kTargetTranslateScale = 0.75
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    var imageView:UIImageView? = nil
    var coverView:UIView? = nil
    var screenshotImgs:NSMutableArray? = nil
    var panGestureRec: UIScreenEdgePanGestureRecognizer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // 禁用默认滑动返回
        self.interactivePopGestureRecognizer?.isEnabled = false
        //添加返回手势
        panGestureRec = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(panGestureRec(panGestureRec:)))
        panGestureRec?.edges = UIRectEdge.left
        self.view .addGestureRecognizer(panGestureRec!)
        
        // 初始化
        imageView = UIImageView.init(frame: CGRect(x:0, y:0, width:screenW, height:screenH))
        coverView = UIView.init(frame: (imageView?.bounds)!)
        coverView?.backgroundColor = UIColor.black
        screenshotImgs = NSMutableArray()
    }
    
    
    func panGestureRec(panGestureRec:UIScreenEdgePanGestureRecognizer)  {
        if self.viewControllers.count == 1 {
            return
        }
        switch panGestureRec.state {
        case UIGestureRecognizerState.began:
            dragBegin()
        case UIGestureRecognizerState.ended:
            dragEnd()
        default:
            dragging(pan: panGestureRec)
        }
    }
    
    func dragBegin()  {
        self.view.window?.insertSubview(imageView!, at: 0)
        self.view.window?.insertSubview(coverView!, aboveSubview: imageView!)
        imageView?.image = screenshotImgs!.lastObject as? UIImage
    }
    
    func dragEnd()  {
        // 取出挪动的距离
        let translateX = self.view.transform.tx
        
        if translateX <= 40 {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform.identity
                self.imageView?.transform = CGAffineTransform.init(translationX: -self.screenW, y: 0)
                self.coverView?.alpha = CGFloat(self.kDefaultAlpha)
            }, completion: { (isFinished) in
                self.imageView?.removeFromSuperview()
                self.coverView?.removeFromSuperview()
            })
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform.init(translationX: self.screenW, y: 0)
                self.imageView?.transform = CGAffineTransform.init(translationX:0, y: 0)
                self.coverView?.alpha = 0
            }, completion: { (isFinished) in
                self.view.transform = CGAffineTransform.identity
                
                self.imageView?.removeFromSuperview()
                self.coverView?.removeFromSuperview()
                print(self.popViewController(animated: false) ?? "")
            })
        }
    }
    
    func dragging(pan:UIPanGestureRecognizer)  {

        let offsetX = pan.translation(in: self.view).x
        if offsetX > 0 {
            self.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0)
        }
        let currentTranslateScaleX = offsetX/screenW
        
            imageView?.transform = CGAffineTransform.init(translationX: (offsetX - screenW) * 0.6, y: 0)
        
        let alpha = CGFloat(kDefaultAlpha) - (CGFloat(currentTranslateScaleX)/CGFloat(kTargetTranslateScale) ) * CGFloat(kDefaultAlpha)
            coverView?.alpha = alpha
    }
    
    func screenShot()  {
        let rootVC = self.view.window?.rootViewController
        
        let size = rootVC?.view.frame.size
        
        UIGraphicsBeginImageContextWithOptions(size!, true, 0.0)
        
        let rect = CGRect(x:0, y:0, width:screenW, height:screenH)
        
        rootVC?.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        if (snapshot != nil) {
            screenshotImgs?.add(snapshot!)
        }
        UIGraphicsEndImageContext()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count != 0 {
            screenShot()
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        screenshotImgs?.removeLastObject()
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        screenshotImgs?.removeAllObjects()
        return  super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        for i in self.viewControllers.count - 1...0 {
            if self.viewControllers[i] == viewController {
                break
            }
            screenshotImgs?.removeLastObject()
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
}
