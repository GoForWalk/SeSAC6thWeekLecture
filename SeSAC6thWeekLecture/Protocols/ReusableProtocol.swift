//
//  ReusableProtocol.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/09.
//

import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableProtocol { }

extension UICollectionViewCell: ReusableProtocol { }

extension UITableViewCell: ReusableProtocol { }

protocol Sample {
    
    var a: Int { get }
    var b: String { get set }
}

struct StuctSample: Sample {
   
    var a: Int
    
    var b: String
        
}

class Follow {
    
    var sampleArray: [Sample] = []
    
    func samplefunc() {
        
        sampleArray.append(StuctSample(a: 0, b: "aaaa"))
    }
    
    
    
}
