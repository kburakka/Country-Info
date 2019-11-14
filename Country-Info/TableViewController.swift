//
//  TableViewController.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCountries()
        
        let favButton : UIBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(showFavorites))

        self.navigationItem.rightBarButtonItem = favButton
    }
    
    @objc func showFavorites(){
        countries.removeAll()
        let list = countriesInFavoriteList()
        if list.count>1{
            showActivityIndicator(selectedView: view)
        }else{
            print("no favorites")
        }
        for index in 0..<list.count{
            let url = "https://restcountries.eu/rest/v2/alpha/\(list[index])"
            Alamofire.request(url, method: .get).responseJSON{ response in
                if response.result.isSuccess
                {
                    let json : JSON = JSON(response.result.value!)
                        let name = json["name"].string
                        let capital = json["capital"].string
                        let region = json["region"].string
                        let subregion = json["subregion"].string
                        let population = json["population"].int
                        let languagesJson = json["languages"]
                        let alpha3Code = json["alpha3Code"].string
                        var languages = [String?]()
                        for index in 0..<languagesJson.count{
                            let language = languagesJson[index]["name"].string
                            languages.append(language)
                        }
                        let currenciesJson = json["currencies"]
                        var currencies = [String?]()
                        for index in 0..<currenciesJson.count{
                            let currency = currenciesJson[index]["name"].string
                            currencies.append(currency)
                        }
                        let code = json["alpha2Code"].string ?? ""
                        let url = URL(string: "https://www.countryflags.io/\(code)/shiny/64.png")
                        let flag = UIImageView()
                        flag.sd_setImage(with: url) { (_, _, _, _) in
                            self.tableView.reloadData()
                        }
                        countries.append(Country(name: name, capital: capital, region: region, subRegion: subregion, population: population, languages: languages, currencies: currencies, flag: flag, alpha3Code: alpha3Code))
                        
                    if index+1 == list.count{
                        stopActivityIndicator()
                        self.animateTable()
                    }
                }
            }

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
    
    func setCountries(){
        showActivityIndicator(selectedView: view)
        countries.removeAll()
        let url = "https://restcountries.eu/rest/v2/region/\(selectedRegion)"
        Alamofire.request(url, method: .get).responseJSON{ response in
            if response.result.isSuccess
            {
                let json : JSON = JSON(response.result.value!)
                for index in 0..<json.count{
                    let name = json[index]["name"].string
                    let capital = json[index]["capital"].string
                    let region = json[index]["region"].string
                    let subregion = json[index]["subregion"].string
                    let population = json[index]["population"].int
                    let languagesJson = json[index]["languages"]
                    let alpha3Code = json[index]["alpha3Code"].string
                    var languages = [String?]()
                    for index in 0..<languagesJson.count{
                        let language = languagesJson[index]["name"].string
                        languages.append(language)
                    }
                    let currenciesJson = json[index]["currencies"]
                    var currencies = [String?]()
                    for index in 0..<currenciesJson.count{
                        let currency = currenciesJson[index]["name"].string
                        currencies.append(currency)
                    }
                    let code = json[index]["alpha2Code"].string ?? ""
                    let url = URL(string: "https://www.countryflags.io/\(code)/shiny/64.png")
                    let flag = UIImageView()
                    flag.sd_setImage(with: url) { (_, _, _, _) in
                        self.tableView.reloadData()
                    }
                    countries.append(Country(name: name, capital: capital, region: region, subRegion: subregion, population: population, languages: languages, currencies: currencies, flag: flag, alpha3Code: alpha3Code))
                    
                    if index+1 == json.count{
                        stopActivityIndicator()
                        self.animateTable()
                    }
                }
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CountryTableViewCell", owner: self, options: nil)?.first as! CountryTableViewCell
        cell.configure(with: countries[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countries[indexPath.row]
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "countryDetail") as! CountryDetailController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
