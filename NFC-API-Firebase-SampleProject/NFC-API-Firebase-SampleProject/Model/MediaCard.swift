//
//  MediaCard.swift
//  NFC-API-Firebase-SampleProject
//
//  Created by Burak Altunoluk on 09/09/2022.
//

import Foundation

struct MediaCard {
    var picture: [String]
    var name: [String]
    var audioLink: [String]
    var ledInfo: [[Int]]
    
    mutating func freshData () {
    picture = [String]()
    name = [String]()
    audioLink = [String]()
    ledInfo = [[Int]]()
    }
}

var myCards = MediaCard(picture: [String](), name: [String](), audioLink: [String](), ledInfo: [[Int]]())


var choosedRow = -1
