//
//  ClosureViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.posterImageView.backgroundColor = .red
        cardView.likeButtonView.backgroundColor = .yellow
        cardView.likeButtonView.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func likeButtonTapped() {
        
    }
    
    @IBAction func colorPickerButtonTapped(_ sender: UIButton) {
        showAlert(title: "ColerPicker?", message: nil, okTitle: "띄우기") {
            let colerPicker = UIColorPickerViewController()
            self.present(colerPicker, animated: true)
        }
    }
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기") {
            self.view.backgroundColor = .lightGray
        }
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            // 함수의 실제 동작 코드가 밖에서 구현되어 있기 때문에 @escaping 사용
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
