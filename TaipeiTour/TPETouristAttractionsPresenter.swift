//
//  TPETouristAttractionsPresenter.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//

import Foundation
import Alamofire

class TPETouristAttractionsPresenter {
    
    private struct Consts {
    }
    let apiRequestService: TPETourismAPIService
    
    required init() {
        apiRequestService = TPETourismAPIService()
    }
    
    func getCategorizedTouristAttractions(success: @escaping ([ String :[TPETouristAttractionModel] ]?) -> Void,
                                          failure: @escaping (Error) -> Void) {
        apiRequestService.getCategorizedTouristAttractions(success: success, failure: failure)
    }


}
