//
//  CountryDetailController.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
var selectedCountry : Country?

class CountryDetailController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var flagImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        flagImageView.image = selectedCountry?.flag?.image

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
            if index.label != "flag"{
                let stackViewHorizontal   = UIStackView()
                stackViewHorizontal.axis  = .horizontal
                stackViewHorizontal.distribution  = .fillProportionally
                stackViewHorizontal.spacing   = 16.0
                stackViewHorizontal.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                let labelKey = UILabel()
                labelKey.textAlignment = .left
                labelKey.text = "\(key)    "
                labelKey.lineBreakMode = .byWordWrapping
                labelKey.numberOfLines = 0
                labelKey.widthAnchor.constraint(equalToConstant: 100).isActive = true
                labelKey.font = UIFont(name: "Helvetica Neue Bold", size: 25)
                
                let labelValue = UILabel()
                labelValue.textAlignment = .left
                labelValue.text = ":  \(value)"
                labelValue.lineBreakMode = .byWordWrapping
                labelValue.numberOfLines = 0
                labelValue.font = UIFont(name: "Helvetica Neue Bold", size: 25)

                stackViewHorizontal.addArrangedSubview(labelKey)
                stackViewHorizontal.addArrangedSubview(labelValue)
                stackView.distribution = .fillEqually
                stackView.addArrangedSubview(stackViewHorizontal)
            }
        }
    }
}
