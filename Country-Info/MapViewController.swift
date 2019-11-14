//
//  MapViewController.swift
//  Country-Info
//
//  Created by burak kaya on 14/11/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedCountry?.Name
        mapView.delegate = self
        showOnMap()
    }
    
    func showOnMap(){
        guard let code = selectedCountry?.alpha3Code else {
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "countryDetail") as! CountryDetailController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        let url = "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
        Alamofire.request(url, method: .get).responseJSON{ response in
            if response.result.isSuccess
            {
                let json : JSON = JSON(response.result.value!)
                if let array = json["features"].arrayObject as? [[String:Any]],
                    let foundItem = array.first(where: { $0["id"] as! String == "\(code)"}) {
                    let itemJson = JSON(foundItem)
                    let geometry = itemJson["geometry"]
                    let type = geometry["type"].string
                    let coordinates = geometry["coordinates"]
                    var allCoords = [CLLocationCoordinate2D]()
                    if type == "MultiPolygon"{
                        for index in 0..<coordinates.count{
                            for index2 in 0..<coordinates[index].count{
                                var coords = [CLLocationCoordinate2D]()
                                for index3 in 0..<coordinates[index][index2].count{
                                    let point = CLLocationCoordinate2D(latitude: coordinates[index][index2][index3][1].double!, longitude: coordinates[index][index2][index3][0].double!)
                                    coords.append(point)
                                    allCoords.append(point)
                                }
                                let polyline = MKPolygon(coordinates: &coords, count: coords.count)
                                self.mapView?.addOverlay(polyline)
                            }
                        }
                    }else if type == "Polygon"{
                        for index in 0..<coordinates.count{
                            var coords = [CLLocationCoordinate2D]()
                            for index2 in 0..<coordinates[index].count{
                                let point = CLLocationCoordinate2D(latitude: coordinates[index][index2][1].double!, longitude: coordinates[index][index2][0].double!)
                                allCoords.append(point)
                                coords.append(point)
                            }
                            let polygon = MKPolygon(coordinates: &coords, count: coords.count)
                            self.mapView?.addOverlay(polygon)
                        }
                    }
                    let bbox = findBbox(coordinates: allCoords)
                    self.setCenter(bbox: bbox)
                }
            }
        }
    }
    
    func setCenter(bbox:[Double]){
        var span = MKCoordinateSpan()
        span.latitudeDelta = fabs(bbox[3] - bbox[1])
        span.longitudeDelta = fabs(bbox[2] - bbox[0])
        
        var center = CLLocationCoordinate2D()
        center.latitude = fmax(bbox[3], bbox[1]) - (span.latitudeDelta / 2.0)
        center.longitude = fmax(bbox[2], bbox[0]) - (span.longitudeDelta / 2.0)
        
        var region = MKCoordinateRegion()
        region.center = center
        region.span = span
        self.mapView.setRegion( region, animated: false )

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = .brown
            polygonView.fillColor = .blue
            polygonView.alpha = 0.5
            return polygonView
        }
        return MKOverlayRenderer()
    }
}


