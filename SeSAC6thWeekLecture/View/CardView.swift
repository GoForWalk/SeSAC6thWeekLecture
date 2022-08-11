//
//  CardView.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit


/*
  Xml Interface Builder
 
 재사용성 good
 1. UIView Custom Class => 여려 파일을 하나의 뷰에서 관리할 수 있다.
 2. File's owner => 활용도 / 여러 View 사용 제약
 */

/*
 View: 인터페이스 빌더 UI 초기화 구문
        - 프로토콜 초기화 구문: required > 초기화 구문이 프로토콜로 명세되어 있음
 
 코드 UI 초기화 구문: //    override init(frame: CGRect) { }
 
 */

protocol A {
    func example()
    init()
}

class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButtonView: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    // 인터페이스 빌더 UI 초기화 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // 코드 베이스로 가지고 오는 형식.
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .lightGray
        contentLabel.textColor = .white
        
        self.addSubview(view)
        
        // 카드뷰를 인터페이스 빌더 기반으로 만들고, 에이아웃도 설정했는데, false가 아닌 true가 나온다.
        // true 오토레이아웃 적용이 되는 관점보다, 오토이사이징이 내부적으로 constraints 처리가 된다.
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
    // 코드 UI 초기화 구문
//    override init(frame: CGRect) {
//        <#code#>
//    }
    
    
}
