//
//  TMDBAPIManager.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]

    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> Void) {
        
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.TMDB_KEY)&language=ko-KR"
        
        AF.request(url, method: .get).validate().responseData(queue: .global(qos: .default)) { response in

            switch response.result {
            case .success(let result):
                let json = JSON(result)

                let result = json["episodes"].arrayValue.map {
                    return $0["still_path"].stringValue
                }
                
                dump(result)
                
                completionHandler(result)
                
            case .failure(let error):
                print(error)
            }
        }
    } //: fetchBlogAPI

    func requestEpisodeImage(completionHandler: @escaping ([[String]]) -> Void) {
                
        // 반복문 X
        // 1. 순서 보장 X, 2. 언제 끝날지 모름 3. Limit(ex. 1초 동안 5번 오면 Block)
//        for item in tvList {
//            TMDBAPIManager.shared.fetchTVSeason(tvID: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
        
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        print(#function, " done")
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    }
    
}
