//
//  EndPoint.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/08.
//

import Foundation

enum EndPoint {
    
    static let searchQuery = "query"
    
    case blog
    case cafe
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog")
        case .cafe:
            return URL.makeEndPointString("cafe")
        }
    }
}

