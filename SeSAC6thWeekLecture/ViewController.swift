//
//  ViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/08.
//

import UIKit

import SwiftyJSON

/*
  문자열 대체 메서드
 */

class ViewController: UIViewController {

    let kakaoAPIManager = KakaoAPIManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    var cafeList: [String] = []
    var blogList: [String] = []
    
    var isExpended = false // false 2줄, true 0줄
    
    var str = "Fans<B>".replacingOccurrences(of: "<B>", with: "<v>")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(str)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        print(#function, "START")
//        requestBlog()
        print(#function, "END")
    }

    // Alamofire + SwiftyJSON
    func requestBlog() {
        kakaoAPIManager.fetchKaKaoAPI(searchWord: "고래밥", dateType: .blog) { json in
            
            print(json)
            
            let tempArr = json["documents"].arrayValue.map {
                return $0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            }
            
            self.blogList.append(contentsOf: tempArr)
            self.searchCafe()
        }
    }//: requestBlog

    func searchCafe() {
        
        kakaoAPIManager.fetchKaKaoAPI(searchWord: "고래밥", dateType: .cafe) { json in
            print(json)
            
            let tempArr = json["documents"].arrayValue.map {
                return $0["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            }
            
            self.cafeList.append(contentsOf: tempArr)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
        
    }
    
    @IBAction func itemTapped(_ sender: UIBarButtonItem) {
        
        isExpended = !isExpended
        tableView.reloadData()
        
    }
    
    
    
}//: ViewController


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KakaoCell.identifier , for: indexPath) as? KakaoCell else { return UITableViewCell()}
        
        cell.testLabel.numberOfLines = isExpended ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그" : "카페"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class KakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    
}
