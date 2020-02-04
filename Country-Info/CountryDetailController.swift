//
//  CountryDetailController.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
import MarqueeLabel

class CountryDetailController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var seperator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlagImageView()
        setDetails()
    }
    
    func setFlagImageView(){
        flagImageView.image = selectedCountry?.flag?.image
        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOpacity = 0.77
        flagImageView.layer.shadowOffset = .zero
        flagImageView.layer.shadowRadius = 8
        
        seperator.layer.shadowColor = UIColor.black.cgColor
        seperator.layer.shadowOpacity = 0.77
        seperator.layer.shadowOffset = CGSize(width: 3, height: 3)
        seperator.layer.shadowRadius = 10
    }
    
    func setDetails(){
        let mirror = Mirror(reflecting: selectedCountry ?? "")
        for index in mirror.children{
            let key = index.label ?? ""
            var value = index.value
            if (value as? String) != nil{
                value = value as! String
            }else if (value as? Int) != nil{
                value = value as! Int
            }else if (value as? [String]) != nil{
                value = (value as! [String]).joined(separator: ", ")
            }else if (value as? [Int]) != nil{
                value = (value as! [Int])
            }
            if index.label != "flag" && index.label != "alpha3Code"{
                let stackViewHorizontal   = UIStackView()
                stackViewHorizontal.axis  = .horizontal
                stackViewHorizontal.distribution  = .fillProportionally
                stackViewHorizontal.spacing   = 16.0
                stackViewHorizontal.heightAnchor.constraint(equalToConstant: 50).isActive = true

                let labelKey = MarqueeLabel()
                labelKey.textAlignment = .left
                labelKey.text = "\(key)"
                labelKey.lineBreakMode = .byWordWrapping
                labelKey.numberOfLines = 0
                labelKey.widthAnchor.constraint(equalToConstant: 100).isActive = true
                labelKey.font = UIFont(name: "HelveticaNeue", size: 20)
                
                let labelValue = MarqueeLabel()
                labelValue.textAlignment = .left
                labelValue.text = ":  \(value)"
                labelValue.lineBreakMode = .byWordWrapping
                labelValue.numberOfLines = 0
                labelValue.font = UIFont(name: "HelveticaNeue", size: 20)

                stackViewHorizontal.addArrangedSubview(labelKey)
                stackViewHorizontal.addArrangedSubview(labelValue)
                stackView.distribution = .fillEqually
                stackView.addArrangedSubview(stackViewHorizontal)
            }
        }
        let stackViewHorizontal   = UIStackView()
        stackViewHorizontal.axis  = .horizontal
        stackViewHorizontal.distribution  = .fillProportionally
        stackViewHorizontal.spacing   = 16.0
        stackViewHorizontal.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let button = UIButton()
        button.setTitle("Show on Map", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.backgroundColor = UIColor.darkGray
        button.addTarget(self, action:#selector(showOnMap) , for: .touchUpInside)

        stackViewHorizontal.addArrangedSubview(button)
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(stackViewHorizontal)
    }
    @objc func showOnMap(){
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
