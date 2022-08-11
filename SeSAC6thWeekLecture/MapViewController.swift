//
//  MapViewController.swift
//  SeSAC6thWeekLecture
//
//  Created by sae hun chung on 2022/08/11.
//

import UIKit
import MapKit

// Location1. import
import CoreLocation

/*
 MapView
    - 지도와 위치권한은 상관이 없다.
    - 만약, 지도에 현재 위치등을 표현하고 싶다면, 위치 권한을 등록해야 한다.
    - Framework import
    - 중심과 범위를 지정할 수 있다.
    
    - 핀 : annotation
 */

// 권한: 반영이 조금씩 느릴 수 있음. 지웠다가 실행한다 해도... ㅜㅜ
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        // Location3. 프로토콜 연결
        locationManager.delegate = self
        
//        checkUserDeviceLocationServiceAuthorization() // 제거 가능한 이유!!
        let center = CLLocationCoordinate2D(latitude: 35.890408, longitude: 128.612017)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
}

// 위치 관련 User Defined 메서드
extension MapViewController {
    
    // Location 7. ios 버젼에 따른 분기 처리 및 ios 위치 기반 서비스 활성화 여부 확인
    // 위치 서비스가 켜져있다면, 권한을 요청하고, 꺼져있다면 커스텀 알럿으로 상황 알려주기
    // CLAuthorizationStatus
    // - deined: 허용 안함 / 설정에서 추후에 거부 / 위치서비스 중지 / 비행기 모드
    // - restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은것으로 아예 제한
    // - notDetermined: 아직 권한 설정이 되지 않음.
    // -
    func checkUserDeviceLocationServiceAuthorization() {
        print(#function)
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            // 인스턴스를 통해 locationManager가 가지고 있는 상태를 가져온다.
            authorizationStatus = locationManager.authorizationStatus
            
        } else {
            // 타입 메서드를 통해서 locationManager가 가지고 있는 상태를 가져온다.
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크: LocationServiceEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // 위치서비스가 활성화 되어 있으므로, 위치 권한 요청 가능 -> 위치 권한을 요청한다.
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
        
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인 ( 단, 사전에 iOS 위치 서비스 활성화 꼭 확인!!)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 사용자가 사용하는 기기에 맞는 위치 정확도로 설정
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안만 위치 권한을 요청 ( 요청 알럿 띄우기 )
            // plist WhenInUse -> request 메서드 OK
            // plist에 먼저 작성하지 않으면 앱이 종료된다.
            
//            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해, didUpdateLocations 메서드가 실행된다.
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          // 설정창으로 이동하는 코드
          // 설정까지 이동하거나 설정 세부화면까지 이동
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나...
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}

// Location 4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    // Location 5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
    
        dump(locations)

        // ex. 위도, 경도 기반으로 날씨 정보를 조회
        // ex. 지도를 다시 셋팅
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        
        
        
        // 위치 업데이트 멈춰!!
        // 실시간 성이 중요하지 않은 코드에서는 이 코드를 위치 업데이트를 멈춘다.
        locationManager.stopUpdatingLocation()
    }
    
    
    
    // Location 6. 사용자의 위치를 가져오는데 실패한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // Location 9. 사용자의 권한 상태가 바뀔때를 알려주는 메서드
    // 거부했다가 설정에서 변경했거나, 혹은 notDetermined에서 허용을 했거나 등...
    // 허용을 했어서 위치를 가지고 오는 중에, 설정에서 거부하고 돌아온다면??
    
    // LocationManager가 초기화 될때 이 메서드가 한 번 실행된다.
    //     let locationManager = CLLocationManager() <<- 이 코드
    // ios14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // ios14 이하
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
}


extension MapViewController: MKMapViewDelegate {
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 설정: 애플맵 활용해서 좌표 복사
//        let center = CLLocationCoordinate2D(latitude: 35.890408, longitude: 128.612017)
        print(#function)
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        // 맵뷰에 중심 적용
        mapView.setRegion(region, animated: true)
        
        
        // 핀 찍어주기 ( 따로 설정해야 한다.)
        // annotation 추가
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = center
        annotation.title = "내가 갈곳!"
        
        mapView.addAnnotation(annotation)
    }

    
//    // custom pin을 추가하는 방법
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
//
//    // 지도의 위치가 바뀌면 호출
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        <#code#>
//    }
}
