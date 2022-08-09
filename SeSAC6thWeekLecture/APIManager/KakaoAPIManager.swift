//
//  KakaoAPIManager.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }

    func fetchKaKaoAPI(searchWord: String, dateType: EndPoint, completionHandler: @escaping (JSON) -> Void) {
        
        let url = dateType.requestURL
        
        let param: Parameters = [EndPoint.searchQuery: //searchWord.addingPercentEncoding(withAllowedCharacters:  .urlQueryAllowed)!]
        searchWord]
        
        let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: "KakaoAK \(APIKey.KAKAO_REST_API_KEY)")])
        
        AF.request(url, method: .get, parameters: param, headers: header).validate().responseData(queue: .global(qos: .default)) { response in
            print(response.request?.description)
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
                
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    } //: fetchBlogAPI

    
}//: KakaoAPIManager
