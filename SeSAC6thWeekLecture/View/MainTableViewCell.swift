//
//  MainTableViewCell.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    // ViewController에 delegate를 위임한다. -> CellForRowAt
    @IBOutlet weak var contentColletionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("====", String(describing: self), #function)
        setupUI()
    }

    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "넷플릭스 인기 컨텐츠"
        titleLabel.backgroundColor = .clear
        
        contentColletionView.backgroundColor = .clear
        contentColletionView.collectionViewLayout = collectionViewLayout()
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return layout
    }

    
}
