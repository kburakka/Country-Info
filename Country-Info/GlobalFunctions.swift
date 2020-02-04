//
//  GlobalFunctions.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
let container: UIView = UIView()
let loadingView: UIView = UIView()

func showActivityIndicator(selectedView: UIView){
    if #available(iOS 10.0, *) {
        var timeLeft = 60
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
func findBbox(coordinates : [CLLocationCoordinate2D]) -> [Double]{
    
    let maxLat = coordinates.map({$0.latitude}).max()
    let minLat = coordinates.map({$0.latitude}).min()
    
    let maxLng = coordinates.map({$0.longitude}).max()
    let minLng = coordinates.map({$0.longitude}).min()
    
    let bbox = [minLng,minLat,maxLng,maxLat]
    
    return bbox as! [Double]
}
 

func addFavorite(code:String){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let menagedContext = appDelegate.persistentContainer.viewContext
    let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorites", in: menagedContext)!

    let favorite = NSManagedObject(entity: favoriteEntity, insertInto: menagedContext)
    favorite.setValue(code, forKey: "code")
    do{
        try menagedContext.save()
    }catch{
        print("error")
    }
}


func deleteAllFavorites(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let menagedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")

    do{
        let objects = try menagedContext.fetch(fetchRequest)
        for index in 0..<objects.count{
            let objectToDelete = objects[index] as! NSManagedObject
            menagedContext.delete(objectToDelete)
        }
        try menagedContext.save()
    }catch{
        print("error")
    }
}

func deleteFavorite(code:String){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let menagedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")

    let predicate = NSPredicate(format: "code = %@", code)
    fetchRequest.predicate = predicate
    do{
        let objects = try menagedContext.fetch(fetchRequest)
        if objects.count > 0{
            let objectToDelete = objects[0] as! NSManagedObject
            menagedContext.delete(objectToDelete)
            try menagedContext.save()
        }
    }catch{
        print("error")
    }
}
func isCountryInFavoriteList(code:String)-> Bool{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let menagedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")

    do{
        let predicate = NSPredicate(format: "code = %@", code)
        fetchRequest.predicate = predicate
        
        let result = try menagedContext.fetch(fetchRequest)
        if result.count == 0 {
            return false
        }else{
            return true
        }
    }catch{
        print("error")
        return true
    }
}

func countriesInFavoriteList()-> [String]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let menagedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")

    do{
        var favorites = [String]()
        let result = try menagedContext.fetch(fetchRequest)
        for index in result as! [NSManagedObject]{
            favorites.append(index.value(forKey: "code") as! String)
        }
        return favorites
    }catch{
        print("error")
        return []
    }
}
