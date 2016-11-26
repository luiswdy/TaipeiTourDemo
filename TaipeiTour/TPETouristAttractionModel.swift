//
//  TPETouristAttractionModel.swift
//  TaipeiTour
//
//  Created by Luis Wu on 11/25/16.
//  Copyright © 2016 Luis Wu. All rights reserved.
//
import ObjectMapper

class TPETouristAttractionModel: Mappable {
    
    private struct Consts {
        static let dateFormatString = "yyyy/mm/dd"
    }
    /* NOTE: properties commented as those are not used */
    
//    var id: Int?
//    var rowNumber: Int?
//    var refWP: Int?
//    var category: String?
    var subCategory: String?
//    var serialNumber: String?
//    var memoTime: String?
    var sTitle: String?
    var xBody: String?
//    var avBegin: Date?
//    var avEnd: Date?
//    var idpt: String?
//    var address: String?
//    var xPostDate: Date?
    var file: [String]?
//    var langInfo: Int?
//    var poi: Bool?
//    var info: String?
//    var longitude: Double?
//    var latitude: Double?
//    var mrt: String?
    var isExpanded: Bool = false // used to track collapse/expand state of a tourist attraction
    
    required init? (map: Map) {
        
    }
    
    func mapping(map: Map) {
//        id              <- (map["_id"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }) )
//        rowNumber       <- (map["RowNumber"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }) )
//        refWP           <- (map["REF_WP"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }) )
//        category        <- map["CAT1"]
        subCategory     <- map["CAT2"]
//        serialNumber    <- map["SERIAL_NO"]
//        memoTime        <- map["MEMO_TIME"]
        sTitle          <- map["stitle"]
        xBody           <- map["xbody"]
//        avBegin         <- (map["avBegin"], CustomDateFormatTransform(formatString:Consts.dateFormatString))
//        avEnd           <- (map["avEnd"], CustomDateFormatTransform(formatString:Consts.dateFormatString))
//        idpt            <- map["idpt"]
//        address         <- map["address"]
//        xPostDate       <- (map["xpostDate"], CustomDateFormatTransform(formatString:Consts.dateFormatString))
        file            <- (map["file"], FileSplitterTransform())
//        langInfo        <- map["langInfo"]
//        poi             <- map["POI"]
//        info            <- map["info"]
//        longitude       <- (map["longitude"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }) )
//        latitude        <- (map["latitude"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }) )
//        mrt             <- map["MRT"]
    }
}

class FileSplitterTransform: TransformType {
    typealias Object = [String]
    typealias JSON = String
    
    struct Consts {
        static let splitPattern = "http://"
        static let joinSeparator = ""
    }
    
    func transformFromJSON(_ value: Any?) -> [String]? {
        if let file = value as? String {
            return file.components(separatedBy: Consts.splitPattern).filter({ (split) -> Bool in
                return !split.isEmpty
            }).map({ (nonEmptySplit) -> String in
                return Consts.splitPattern + nonEmptySplit
            })
        }
        return nil
    }
    
    func transformToJSON(_ value: [String]?) -> String? {
        if let file = value {
            return file.joined(separator: Consts.joinSeparator)
        }
        return nil
    }
}
