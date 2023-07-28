//
//  placeModel.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 27.07.2023.
//

import Foundation

import UIKit
class PlaceModel { // singelton
    
    static let sharedInstance = PlaceModel() // kim kullanırsa kullansın bunu elde edicek
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    
    private init() {} // başka hiçbir yerden initialize yapılamıyor
    
    
}
