//
//  Map.swift
//  NEMODU
//
//  Created by 황윤경 on 2023/04/06.
//

import Foundation

enum Map {
    // 실제 한 칸의 크기
    static let latitudeBlockSize: Double = 0.0003040
    static let longitudeBlockSize: Double = 0.0003740
    
    // 화면의 Zoom 비율
    static let defalutZoomScale = 0.003
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
}
