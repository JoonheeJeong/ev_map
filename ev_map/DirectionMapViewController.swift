//
//  DirectionMapViewController.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import Foundation
import UIKit
import GoogleMaps

let INIT_CAMERA = GMSCameraPosition.camera(withLatitude: 35.554539999999, longitude: 129.3081599999, zoom: 15.0)

let CHARGERS_PATH = String(#file[...#file.index(#file.lastIndex(of: "/")!, offsetBy: -7)] + "allchargers.json")

//let MARKER_LIST = makeMarkerList()

func makeMarkerList() -> [GMSMarker] {
    var markerList: [GMSMarker] = [] //마커들을 저장할 배열 생성
    
    if let contents = try? String(contentsOfFile: CHARGERS_PATH) {
        
        let chargerData = contents.data(using: .utf8)!
        do {
            let chargerArray = try JSONDecoder().decode(Chargers.self, from: chargerData)
            for charger in chargerArray.chargers! {
                markerList.append(makeGMS(charger)!)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    return markerList
}


class DirectionMapViewController: UIViewController {
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: INIT_CAMERA)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true;
        mapView.camera = INIT_CAMERA
        self.view.addSubview(mapView)
        
        if GMS_PATH != nil {
            let direction = GMSPolyline(path: GMS_PATH)
            direction.strokeWidth = 5.0 // 선 굵기
            direction.map = mapView
        }
        
//        for mark in MARKER_LIST {
//            mark.map = mapView
//        }
        
    }
}
