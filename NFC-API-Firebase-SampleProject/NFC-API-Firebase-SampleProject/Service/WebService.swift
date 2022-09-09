//
//  WebService.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 05/09/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

struct WebService {
    
    func myCardsList() {
        DispatchQueue.main.async {
            AF.request("https://raw.githubusercontent.com/BurakAltunoluk/NFC-API-Alamofire/main/Api/MainAPI.json").responseData { datam in
                switch datam.result {
                case .success(let value):
                    let json = JSON(value)
                    myCards.picture = json["pictures"].rawValue as! [String]
                    myCards.name = json["name"].rawValue as! [String]
                    myCards.audioLink = json["audioLink"].rawValue as! [String]
                    myCards.ledInfo = json["ledInfo"].rawValue as! [[Int]]
                    
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
    func cancelRequestAll () {
        AF.cancelAllRequests()
    }

}
