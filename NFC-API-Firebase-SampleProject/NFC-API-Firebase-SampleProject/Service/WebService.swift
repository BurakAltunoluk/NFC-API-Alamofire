//
//  WebService.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 05/09/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct WebService {
    func myCardsList() {
        DispatchQueue.main.async {
            AF.request("https://raw.githubusercontent.com/BurakAltunoluk/NFC-API-Alamofire/main/Api/MainAPI.json").responseData {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    DispatchQueue.main.async {
                    myCards.picture = json["pictures"].rawValue as! [String]
                    myCards.name = json["name"].rawValue as! [String]
                    myCards.audioLink = json["audioLink"].rawValue as! [String]
                    myCards.ledInfo = json["ledInfo"].rawValue as! [[Int]]
                    loadImageReady()
                    }
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
    func deleteAllData () {
        myCards.name = [String]()
        myCards.audioLink = [String]()
        myCards.picture = [String]()
        myCards.ledInfo = [[Int]]()
    }
    
    func cancelRequestAll () {
        AF.cancelAllRequests()
            }
    
    func loadImageReady() {
        if Reachability.isConnectedToNetwork(){
        for i in myCards.picture
        {    let imageData = try! Data(contentsOf:URL(string: i)!)
            myCards.imageDatam.append(imageData)
        }
    }
  }
}
