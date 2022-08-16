//
//  CameraViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker

class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!

    // UIImagePickerController1.
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ImagePickerController 2.
        picker.delegate = self
    }
    
    // openSource
    // 권한 허용!
    // 권한 문구등도 내부적으로 구련! 실제로 카메라를 쓸때 권한을 요청
    @IBAction func YPImagePickerClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    // UIImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용 불가 + 사용자에게 Alert")
            return }
        
        // 속성 변경
        picker.sourceType = .camera
        picker.allowsEditing = true // 촬영 뒤 편집
        
        present(picker, animated: true)
    }
    
    
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용 불가 + 사용자에게 Alert")
            return }
        
        // 속성 변경
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false // 촬영 뒤 편집
        
        present(picker, animated: true)

    }
    
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    // 이미지 뷰 전송
    // 문자열이 아닌 파일 이미지, pdf 파일 자체가 그래도 전송되지 않는다. => 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서버에게 전달이 되는지 명시 -> Content-Type
    @IBAction func clovaFaceButtonTapped(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "X-Naver-Client-Id" : APIKey.NAVER_Client_ID,
            "X-Naver-Client-Secret" : APIKey.NAVER_Client_Secert
        ]
        
        // UIImage를 텍스트 형태를 바이너리 타입으로 변환
//        guard let imageData = resultImageView.image?.pngData() else { return }
        
        // 이미지를 압축해서 보낸다.
        guard let imageData = resultImageView.image?.jpegData(compressionQuality: 0.3) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print("error: ", error)
            }
        }
        
        
    }
}
// ImagePickerController 3.
// 네비게이션 컨트롤러를 상속받고 있다.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ImagePickerController 4.
    // 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function, info.description)
        
        // 원본, 편집, 메타 데이터 등...
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resultImageView.image = image
            
            dismiss(animated: true)
        }
        
    }
    
    // ImagePickerController 5.
    // 취소버튼 눌렀을 때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        
        dismiss(animated: true)
    }
}
