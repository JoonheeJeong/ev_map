//
//  DirectionSearchViewController.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import UIKit
import GooglePlaces
import GoogleMaps


class DirectionSearchViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var locationSearchBar: UITextField!
    @IBOutlet weak var srcSearchBar: UITextField!
    @IBOutlet weak var dstSearchBar: UITextField!
    var tappedSearchBar: UITextField!
    var origin: GMSPlace!
    var destination: GMSPlace!
    
    @IBAction func searchBarTappedHandler(_ sender: Any) {
        let button = sender as! UIButton
        switch (button.tag) {
        case 0:
            tappedSearchBar = locationSearchBar
        case 1:
            tappedSearchBar = srcSearchBar
        case 2:
            tappedSearchBar = dstSearchBar
        default:
            tappedSearchBar = nil
        }
        tappedSearchBar.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    @IBAction func searchDirectionHandler(_ sender: Any) {
        directionRequest()
    }
    
    func directionRequest() {
        let origin_lng = String(format: "%lf", Double(origin.coordinate.longitude))
        let origin_lat = String(format: "%lf", Double(origin.coordinate.latitude))
        let destination_lng = String(format: "%lf", Double(destination.coordinate.longitude))
        let destination_lat = String(format: "%lf", Double(destination.coordinate.latitude))
//        let option: String
        let parameters = "start=" + origin_lng + "," + origin_lat
                 + "&" + "goal=" + destination_lng + "," + destination_lat
//                 + "&" + "option=" + option
        
        let baseUrl: String = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving"

        let completeUrl = URL(string: baseUrl + "?" + parameters)
        var request = URLRequest(url: completeUrl!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(naverClientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(naverClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
            var str = String(data: data, encoding: .utf8)!
//            print(str)
            
            let beg = str.range(of: "\"path\":")!
            str.removeSubrange(str.startIndex..<beg.upperBound)
            let end = str.range(of: ",\"section\"")!
            str.removeSubrange(end.lowerBound...)
            // str -> [[lng,lat],[lng, lat] ... [lng,lat]]
//            print(str)
            
            let directionPath = try! JSONDecoder().decode(DirectionPath.self, from: str.data(using: .utf8)!)
            DispatchQueue.main.async {
                self.drawPath(directionPath)
            }
        }
        task.resume()
    }
    
    func drawPath(_ directionPath: DirectionPath) {
        let path = GMSMutablePath()
        for lnglat in directionPath.list! {
            path.add(CLLocationCoordinate2D(latitude: lnglat[1], longitude: lnglat[0]))
        }
        let direction = GMSPolyline(path: path)
        direction.strokeWidth = 10.0 // 선 굵기
        //direction.map = mapView
    }
    
}

     extension DirectionSearchViewController: GMSAutocompleteViewControllerDelegate {
         func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
              print("Place name: \(String(describing: place.name))")
              dismiss(animated: true, completion: nil)
            
            switch (tappedSearchBar.tag) {
            case 1:
                origin = place
            case 2:
                destination = place
            default:
                break
            }
            
            tappedSearchBar.text = place.name
            let lat = String(format: "%lf", Double(place.coordinate.latitude))
            let lng = String(format: "%lf", Double(place.coordinate.longitude))
            print("lat: \(lat)")
            print("lng: \(lng)")
            
/*
            mapView camera setting exmaple
            let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
            self.mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
*/

            
         }
         
         func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
             print(error.localizedDescription)
         }
         
         func wasCancelled(_ viewController: GMSAutocompleteViewController) {
             dismiss(animated: true, completion: nil)
         }
         
         
     }
