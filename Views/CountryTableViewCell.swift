//
//  CountryTableViewCell.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var flag: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    public func configure(with model: Country) {
        flag.image = model.flag?.image
        name.text = model.Name
        guard let code = model.alpha3Code else {return}
        favorite.accessibilityHint = code
        if isCountryInFavoriteList(code: code){
            favorite.setImage(UIImage(named: "starFill"), for: .normal)
        }else{
            favorite.setImage(UIImage(named: "starEmpty"), for: .normal)
        }
    }
    @IBAction func setFavoriteCountry(_ sender: Any) {
        guard let code = favorite.accessibilityHint else {return}
        
        if isCountryInFavoriteList(code: code){
            favorite.setImage(UIImage(named: "starEmpty"), for: .normal)
            deleteFavorite(code: code)
        }else{
            addFavorite(code: code)
            favorite.setImage(UIImage(named: "starFill"), for: .normal)
        }
    }
}
