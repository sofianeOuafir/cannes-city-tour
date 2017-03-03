//
//  POI.swift
//  TD5
//
//  Created by GELE Axel on 20/02/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import Foundation

class POI{
    var id : String
    var name : String
    var image : String
    var latt : Float
    var long : Float
    var phone : String
    var email : String
    var url : String
    var description : String
    
    init(id : String, name : String, image : String, latt : Float, long : Float, phone : String, email : String, url : String, description : String) {
        self.id = id
        self.name = name
        self.image = image
        self.latt = latt
        self.long = long
        self.phone = phone
        self.email = email
        self.url = url
        self.description = description
    }
    
}
