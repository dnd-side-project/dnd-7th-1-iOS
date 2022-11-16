//
//  ProgressAndDoneChallengeListResponseModel.swift
//  NEMODU
//
//  Created by Kime Heejae on 2022/10/31.
//

import Foundation

struct ProgressAndDoneChallengeListElement: Codable {
    let color, ended, name: String
    let rank: Int
    let started, uuid: String
    let picturePaths: [String]
}

typealias ProgressAndDoneChallengeListResponseModel = [ProgressAndDoneChallengeListElement]
