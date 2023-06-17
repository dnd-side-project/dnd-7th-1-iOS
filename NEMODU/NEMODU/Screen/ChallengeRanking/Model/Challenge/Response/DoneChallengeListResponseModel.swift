//
//  DoneChallengeListResponseModel.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/06/14.
//

import Foundation

struct DoneChallengeListResponseModel: Codable {
    let infos: [ProgressAndDoneChallengeListElement]
    let size: Int
    let isLast: Bool
    let offset: Int?
}
