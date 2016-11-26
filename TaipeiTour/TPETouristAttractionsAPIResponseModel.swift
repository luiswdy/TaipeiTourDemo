//
//  TPETouristAttractionsAPIResponseModel.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//
import ObjectMapper

class TPETouristAttractionsAPIResponseModel : Mappable {
    var result: TPETouristAttractionsResultModel?
    
    required init? (map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}
