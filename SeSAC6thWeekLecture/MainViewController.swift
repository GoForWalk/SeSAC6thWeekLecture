//
//  MainViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .cyan, .yellow, .orange]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](10...25),
        [Int](0...4),
        [Int](1000...1026)
    ]
    
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
        
        self.view.backgroundColor = .lightGray
    }
    

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.posterImageView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .orange : .cyan
            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
        }
        
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

// 하나의 프로토콜, 메서드에서 여러 컬렉션뷰의 delegate, dataSource 구현해야 함.
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        cell.contentColletionView.delegate = self
        cell.contentColletionView.dataSource = self
        cell.contentColletionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        cell.contentColletionView.tag = indexPath.section // 각 셀 구분짓기
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 + 8 + 8 + 28 + 8
    }
    
    
}
