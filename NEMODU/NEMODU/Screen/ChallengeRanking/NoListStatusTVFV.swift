//
//  NoListStatusTVFV.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/09.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class NoListStatusTVFV : UITableViewHeaderFooterView {
    
    // MARK: - UI components
    
    let statusLabel = UILabel()
        .then {
            $0.text = NoChallengeStatusMessageType(rawValue: 3)?.message ?? ""
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureFV()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configureFV() {
        contentView.backgroundColor = .white
    }
    
    func layoutView() {
        contentView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
