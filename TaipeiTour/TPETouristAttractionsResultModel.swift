//
//  TPETouristAttractionsResultModel.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//
import ObjectMapper

class TPETouristAttractionsResultModel : Mappable {
//    var offset: Int?
//    var limit: Int?
//    var count: Int?
//    var sort: String?
    var results: [TPETouristAttractionModel]?
    
    required init? (map: Map) {
        
    }
    
    func mapping(map: Map) {
//        offset  <- map["offset"]      // commented as the field is not used in the app
//        limit   <- map["limit"]      // commented as the field is not used in the app
//        count   <- map["count"]      // commented as the field is not used in the app
//        sort    <- map["sort"]      // commented as the field is not used in the app
        results <- map["results"]
    }
}
