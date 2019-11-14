//
//  ViewController.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

var selectedRegion = ""

struct Region {
    let name : String
    let image : UIImage
    
    init(name: String, image:UIImage) {
        self.name = name
        self.image = image
    }
}

class ViewController: UIViewController{
    var regionList = [Region]()

    @IBOutlet weak var regionCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRegions()
        regionCollectionView.register(UINib.init(nibName: "RegionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegionCollectionViewCell")
    }
    
    func setRegions(){
        regionList.removeAll()
        regionList.append(Region(name: "Africa", image: UIImage(named: "africa")!))
        regionList.append(Region(name: "Americas", image: UIImage(named: "americas")!))
        regionList.append(Region(name: "Asia", image:  UIImage(named: "asia")!))
        regionList.append(Region(name: "Europe", image:  UIImage(named: "europe")!))
        regionList.append(Region(name: "Oceania", image: UIImage(named: "oceania")!))
        
        regionCollectionView.reloadData()
    }
}

