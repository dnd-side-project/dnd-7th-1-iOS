//
//  NemoduResponseTimeFomat.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/06.
//

import Foundation

/// Nemodu 서버에서 반환하는 시간 구조를 정의하는 구조체
struct NemoduResponseTimeFomat {
    // 현재 서버에서 반환되는 시간형태 yyyy-MM-ddTHH:ss:mm
    let year: String
    let month: String
    let day: String
    
    let hour: String
    let minute: String
    let second: String
}
