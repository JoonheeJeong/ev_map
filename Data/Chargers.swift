//
//  Chargers.swift
//  ev_map
//
//  Created by cse on 2020/11/03.
//

import Foundation
import GoogleMaps


struct Chargers : Codable{
    var chargers: [Charger]?
    
    enum CKeys : String, CodingKey {
        case chargers = "chargers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CKeys.self)
        chargers = try values.decodeIfPresent([Charger].self, forKey: .chargers)
    }
}

struct Charger : Codable
{
    var statNm : String?
    var statId : String?
    var chgerId : String?
    var chgerType : String?
    var addr : String?
    var lat : String?
    var lng : String?
    var useTime : String?
    var busiId : String?
    var busiNm : String?
    var busiCall : String?
    var stat : String?
    var statUpdDt : String?
    var powerType : String?
 
    enum Keys: String,CodingKey{
        case statNm
        case statId
        case chgerId
        case chgerType
        case addr
        case lat
        case lng
        case useTime
        case busiId
        case busiNm
        case busiCall
        case stat
        case statUpdDt
        case powerType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        statNm = try values.decodeIfPresent(String.self, forKey: .statNm)
        statId = try values.decodeIfPresent(String.self, forKey: .statId)
        chgerId = try values.decodeIfPresent(String.self, forKey: .chgerId)
        chgerType = try values.decodeIfPresent(String.self, forKey: .chgerType)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        useTime = try values.decodeIfPresent(String.self, forKey: .useTime)
        busiId = try values.decodeIfPresent(String.self, forKey: .busiId)
        busiNm = try values.decodeIfPresent(String.self, forKey: .busiNm)
        busiCall = try values.decodeIfPresent(String.self, forKey: .busiCall)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
        statUpdDt = try values.decodeIfPresent(String.self, forKey: .statUpdDt)
        powerType = try values.decodeIfPresent(String.self, forKey: .powerType)
    }
}


// Creates a marker in the center of the map.
func makeGMS(_ charger: Charger) -> GMSMarker?{
    let maker = GMSMarker()
    
    if (charger.lat != nil && charger.lng != nil) {
        print("lat: \(charger.lat ?? "0.0")")
        print("lng: \(charger.lng ?? "0.0")")
        let latitude = Double(charger.lat!)!
        let longitude = Double(charger.lng!)!
        print("good")
        maker.position = CLLocationCoordinate2DMake(latitude,longitude)
        maker.title = charger.statId!
        maker.snippet = charger.addr!
        return maker
    }
    print("for debug")
        return nil
}


func convertStatus(intValue : String) -> String {
    var status = ""
    
    switch intValue{
    case "1" :
        status = "통신이상"
    case "2" :
        status = "충전대기(이용가능)"
    case "3" :
        status = "충전중"
    case "4" :
        status = "운영준비"
    case "5" :
        status = "점검중"
    default :
        status = "상태 미확인"
    }
        return status
}


func convertType(intValue : String) -> String {
    
    var type = ""
    switch intValue {
    case "01" :
        type = "DC차데모"
    case "02" :
        type = "AC완속"
    case "03" :
        type = "DC차데모+AC상"
    case "04" :
        type = "DC콤보"
    case "05" :
        type = "DC차데모+DC콤보"
    case "06" :
        type = "DC차데모+AC상+DC콤보"
    case "07" :
        type = "AC상"
    default :
        type = "타입 미확인"
    }
    
    return type
}


func convertPowerType(intValue : String?) -> String {
    if intValue == nil {
        return "완속충전"
    } else{
        return "고속충전"
    }
}

