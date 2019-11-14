//
//  GlobalFunctions.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation
import UIKit
var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
let container: UIView = UIView()
let loadingView: UIView = UIView()

func showActivityIndicator(selectedView: UIView){
    if #available(iOS 10.0, *) {
        var timeLeft = 20
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            timeLeft -= 1
            if timeLeft <= 0 {
                timer.invalidate()
                stopActivityIndicator()
            }
        })
    }
    container.frame = UIScreen.main.bounds
    container.backgroundColor = UIColorFromRGB(rgbValue: 0xffffff).withAlphaComponent(CGFloat(0.3))
    
    loadingView.frame.size.width = 80
    loadingView.frame.size.height = 80
    loadingView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    loadingView.backgroundColor = UIColorFromRGB(rgbValue: 0x444444).withAlphaComponent(CGFloat(0.7))
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame.size.width = 40
    activityIndicator.frame.size.height = 40
    activityIndicator.style = .whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    activityIndicator.startAnimating()
    selectedView.addSubview(container)
    UIApplication.shared.beginIgnoringInteractionEvents()
}
func stopActivityIndicator(){
    UIApplication.shared.endIgnoringInteractionEvents()
    container.removeFromSuperview()
    loadingView.removeFromSuperview()
    activityIndicator.stopAnimating()
}
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
