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
    
    func getData(link:String) {
        AF.request(link).responseData { datam in
            switch datam.result {
            case .success(let value):
                let json = JSON(value)
                DispatchQueue.main.async {
                    downloadedData.name = json["name"].rawValue as! String
                    downloadedData.audioLink = json["audioLink"].rawValue as! String
                    downloadedData.ledInfo = json["ledInfo"].rawValue as! [Int]
                }
            case .failure(_):
                print("nill")
            }
        }
    }
    
}
