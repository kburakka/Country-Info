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

struct Country {
    let Name : String?
    let Capital : String?
    let Region : String?
    let SubRegion : String?
    let Population : Int?
    let Languages : [String?]?
    let Currencies : [String?]?
    let flag : UIImageView?
    
    init(name: String?, capital: String?, region: String?, subRegion: String?, population: Int?, languages: [String?]?, currencies: [String?]?, flag: UIImageView?) {
        self.Name = name
        self.Capital = capital
        self.Region = region
        self.SubRegion = subRegion
        self.Population = population
        self.Currencies = currencies
        self.Languages = languages
        self.flag = flag
    }
}

var countries = [Country]()
class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCountries()
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
                    countries.append(Country(name: name, capital: capital, region: region, subRegion: subregion, population: population, languages: languages, currencies: currencies, flag: flag))
                    
                    if index+1 == json.count{
                        stopActivityIndicator()
                        self.animateTable()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
