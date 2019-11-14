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

    @IBOutlet weak var flagImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        flagImageView.image = selectedCountry?.flag?.image
    }
}
