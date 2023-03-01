//
//  Matrix.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import Foundation

struct Matrix: Codable, Equatable {
    let latitude, longitude: Double
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
