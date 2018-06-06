//
//  ViewModel.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 06/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
class ViewModel {
    var manager = Managers.shared
    var routesList  : [RoutesModel] = Array()
    func getRoutes(parameters : [String: AnyObject], complete: @escaping DowloadComplete){
            self.manager.loadRouts(parameters: parameters){
                self.routesList = self.manager.routsList
                 complete()
        }
        
    }
    func numberOfRoutes ()->Int{
        return routesList.count
    }
}
