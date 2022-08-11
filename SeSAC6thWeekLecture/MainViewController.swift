//
//  MainViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

import Kingfisher

class MainViewController: UIViewController {

    // MARK: Property
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .cyan, .yellow, .orange]
    
//    let numberList: [[Int]] = [
//        [Int](100...110),
//        [Int](55...75),
//        [Int](10...25),
//        [Int](0...4),
//        [Int](1000...1026)
//    ]

    var episodeList: [[String]] = []
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerCollectionView.backgroundColor = .clear
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        
        // 화면 쫀쫀하게~~ 
        bannerCollectionView.isPagingEnabled = true // device width 만큼만 움직인다. => cell의 사이즈가 device의 width와 다르면, 짤린다
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = .clear
        mainTableView.allowsSelection = false
        
        self.view.backgroundColor = .lightGray
        
        TMDBAPIManager.shared.requestEpisodeImage { value in
            dump(value)
            // 1. network connection 2. array 생성, 3. 배열 담기
            // 4. 뷰 등에 표현
            // 5. 뷰 갱신
            self.episodeList = value
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    }
    

}

// MARK: UICollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    // 내부 매개변수 위치에 bannerCollectionView or mainCollectionView가 들어올 수 있다.
    // 내무 매개변수가 아닌 명확한 아웃렛을 사용하는 경우, 셀이 재사용되면 특정 collectionView 셀을 재사용하게 될 수 있음.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("**********", String(describing: self), #function, indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        
        
        
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            
            cell.cardView.posterImageView.kf.setImage(with: url)

        }
//            cell.cardView.posterImageView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .orange : .cyan
//
//            if indexPath.item < 2 {
//                cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//
//            }
//        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}

// MARK: UITableView Protocol
// 하나의 프로토콜, 메서드에서 여러 컬렉션뷰의 delegate, dataSource 구현해야 함.
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 내부 매개변수 tableview를 통해 데이블뷰를 특정
    // 테이블 뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지 않아도 된다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        print("====", String(describing: self), #function, indexPath)
        
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.contentColletionView.delegate = self
        cell.contentColletionView.dataSource = self
        cell.contentColletionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        cell.contentColletionView.tag = indexPath.section // 각 셀 구분짓기
        
        cell.backgroundColor = .lightGray
        
        cell.contentColletionView.reloadData() // Index Out of Range 해결
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    
}
