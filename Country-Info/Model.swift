//
//  Model.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation

struct Region {
    let name : String
    let image : UIImage
    
    init(name: String, image:UIImage) {
        self.name = name
        self.image = image
    }
}

struct Country {
    let Name : String?
    let Capital : String?
    let Region : String?
    let SubRegion : String?
    let Population : Int?
    let Languages : [String?]?
    let Currencies : [String?]?
    let flag : UIImageView?
    let alpha3Code : String?
    init(name: String?, capital: String?, region: String?, subRegion: String?, population: Int?, languages: [String?]?, currencies: [String?]?, flag: UIImageView?, alpha3Code:String?) {
        self.Name = name
        self.Capital = capital
        self.Region = region
        self.SubRegion = subRegion
        self.Population = population
        self.Currencies = currencies
        self.Languages = languages
        self.flag = flag
        self.alpha3Code = alpha3Code
    }
}

var countries = [Country]()
var selectedRegion = ""
var selectedCountry : Country?
