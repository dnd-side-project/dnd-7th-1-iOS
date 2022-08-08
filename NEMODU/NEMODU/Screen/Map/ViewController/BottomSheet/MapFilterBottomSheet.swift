//
//  MapFilterBottomSheet.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/01.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import DynamicBottomSheet

class MapFilterBottomSheet: DynamicBottomSheetViewController {
    private let viewBar = UIView()
        .then {
            $0.backgroundColor = UIColor.lightGray
            $0.layer.cornerRadius = 2
        }
    
    private let sheetTitle = UILabel()
        .then {
            $0.text = "지도 필터"
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor.black
        }
    
    private let titleMessage = UILabel()
        .then {
            $0.text = "이번주의 기록만 보여집니다"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.lightGray
        }
    
    // TODO: - 여백값 디자인 확정 이후 수정
    let top = 36
    let leading = 24
    let trailing = -24
    
    override func configureView() {
        super.configureView()
        configureLayout()
    }
}

// MARK: - Layout

extension MapFilterBottomSheet {
    func configureLayout() {
        contentView.addSubviews([viewBar, sheetTitle, titleMessage])
        
        viewBar.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        sheetTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(top)
            $0.leading.equalToSuperview().offset(leading)
            $0.bottom.equalToSuperview().offset(-333)
        }
        
        titleMessage.snp.makeConstraints {
            $0.centerY.equalTo(sheetTitle.snp.centerY)
            $0.leading.equalTo(sheetTitle.snp.trailing).offset(20)
        }
    }
}
