//
//  RoutesModel.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 06/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import ObjectMapper
class RoutesResponse: Mappable {
    var routsModelList : [RoutesModel]?
    required init?(map: Map) {
        
    }    
    func mapping(map: Map) {
        routsModelList <- map["routes"]
    }
}
