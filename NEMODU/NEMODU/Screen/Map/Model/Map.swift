//
//  Map.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/04/06.
//

import UIKit

enum Map {
    // 실제 한 칸의 크기
    static let latitudeBlockSize: Double = 0.0003040
    static let longitudeBlockSize: Double = 0.0003740
    
    // 화면의 Zoom 비율
    static let defaultZoomScale = 0.003
    static let cameraZoomRange: Double = 60000
    
    // 단위 배수 값
    static let mul: Double = 100000000
    
    // 나누기 처리를 위한 실제 크기 * 단위 배수 값
    static var latitudeBlockMultipleSize: Int {
        return Int(latitudeBlockSize * mul)
    }
    static var longitudeBlockMultipleSize: Int {
        return Int(longitudeBlockSize * mul)
    }
    
    /// 앱이 백그라운드 상태에 있을 때 자동차/자전거 경고 로컬 알림 푸시
    static func alertVehicleWarningLocalNotification() {
        if UIApplication.shared.applicationState == .background {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "혹시 자동차나 자전거를 타고 계신가요?"
            content.body = "속도가 너무 빠른 경우 기록이 일시정지됩니다. 앱을 켜서 확인해주세요."
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
