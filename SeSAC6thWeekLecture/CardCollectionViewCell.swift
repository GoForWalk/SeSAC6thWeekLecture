//
//  CardCollectionViewCell.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    // 변경되지 않는 UI을 재사용 메커니즘에서 구현할 필요는 없다.
    // 반복적으로 뷰를 그리지 않기 때문에, 효율적인 기기 동작 가능
    // 변경되지 않는 UI
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButtonView.tintColor = .systemPink
    }
}
