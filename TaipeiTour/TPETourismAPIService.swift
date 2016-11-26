//
//  TPETourismAPIService.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/26/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class TPETourismAPIService {
    
    private struct Consts {
        static let defaultContentTypes = ["application/json"]
        static let defaultScope = "resourceAquire"
        static let defaultRID = "36847f3f-deff-4183-a5bb-800737591de5"
    }
    
    func getCategorizedTouristAttractions(scope: String = Consts.defaultScope,
                                          rid: String = Consts.defaultRID,
                                          success: @escaping ([ String :[TPETouristAttractionModel] ]?) -> Void,
                                          failure: @escaping (Error) -> Void) {
        let params: Parameters = ["scope": scope,
                                  "rid" : rid]
        GET(URL(string:"http://data.taipei/opendata/datalist/apiAccess")!, params: params, headers: nil, success: { (apiResponse: TPETouristAttractionsAPIResponseModel?) in
            if let categoriedAttractions = self.getCategorizedTouristAttractions(attractions: apiResponse?.result?.results) {
                success(categoriedAttractions)
            } else {
                success(nil)
            }
        }, failure: failure)
    }
    
    // MARK - HTTP methods (private)
    
    private func GET<Value: BaseMappable>(_ url: URLConvertible, params: Parameters?, headers: HTTPHeaders?,
                     success: @escaping (Value?) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(url,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: headers)
            .validate(contentType: Consts.defaultContentTypes)
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<Value>) -> Void in
                switch response.result {
                case .success:
                    success(response.result.value)
                    break
                case .failure(let error):
                    failure(error)
                    break
                }
        }
    }
    
    // MARK - Private
    
    private func getCategorizedTouristAttractions(attractions: [TPETouristAttractionModel]?) -> [String : [TPETouristAttractionModel]]? {
        guard attractions != nil else {
            return nil
        }
        
        var categoriedAttractions: [String : [TPETouristAttractionModel]] = [:]
        for attraction in attractions! {
            if categoriedAttractions[(attraction.subCategory)!] != nil {
                categoriedAttractions[(attraction.subCategory)!]!.append(attraction)
            } else {
                categoriedAttractions[attraction.subCategory!] = [attraction]
            }
        }
        return categoriedAttractions
    }
}
