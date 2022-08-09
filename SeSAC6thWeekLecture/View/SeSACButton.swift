//
//  SeSACButton.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

/*
 Swift Attribute(속성)
 @IBDesignable, @IBInspectable, @escaping, @objc
 */

@IBDesignable
class SeSACButton: UIButton {
    
    // 인터페이스 빌더 인스텍터 영역 show
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!)}
        set {layer.borderColor = newValue.cgColor}
    }
    
}
