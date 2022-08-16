//
//  KakaoAPIManager.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

struct User {
    fileprivate let name = "고래밥" // 같은 스위프트 파일에서 다른 클래스, 구조체 사용가능. 다른 스위프트 파일은 X
    private let age = 11 // 같은 스위프트 파일 내에서 같은 타입
}

extension User {
    func example() {
        print(self.name, self.age)
    }
}

struct Person {
    
    func example () {
        let user = User()
        user.name
//        user.age // X
    }
}

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
