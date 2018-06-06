//
//  DurationModel.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 06/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import ObjectMapper
class DurationModel : Mappable {
    var text : String?
    var value : Int?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}
