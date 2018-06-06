//
//  RoutsModel.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 06/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import ObjectMapper
class RoutesModel : Mappable{
    var legs : [LegsModel]?
    var overViewPolyline : OverViewPolylineModel?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        legs <- map["legs"]
        overViewPolyline <- map["overview_polyline"]
    }
    
    
}
