//
//  MapFilterBottomSheet.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/01.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import DynamicBottomSheet

class MapFilterBottomSheet: DynamicBottomSheetViewController {
    private let viewBar = UIView()
        .then {
            $0.backgroundColor = UIColor.systemGray4
            $0.layer.cornerRadius = 2
        }
    
    private let sheetTitle = UILabel()
        .then {
            $0.text = "지도 필터"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let titleMessage = UILabel()
        .then {
            $0.text = "이번주(월~일)의 기록만 보여집니다."
            $0.font = .body4
            $0.textColor = .gray400
        }
    
    private let btnStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 56
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
    
    private let showMyBlocksBtn = UIButton()
        .then {
            $0.setTitle("나의 기록 보기", for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .body3
            $0.toggleButtonImage(defaultImage: UIImage(named: "hideBlocks")!,
                                 selectedImage: UIImage(named: "showBlocks")!)
            $0.centerVertically(spacing: 8)
        }
    
    private let showFriendsBtn = UIButton()
        .then {
            $0.setTitle("친구 보기", for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .body3
            $0.toggleButtonImage(defaultImage: UIImage(named: "hideFriends")!,
                                 selectedImage: UIImage(named: "showFriends")!)
            $0.centerVertically(spacing: 8)
        }
    
    private let separatorLine = UIView()
        .then {
            $0.backgroundColor = .gray200
        }
    
    private let locationPermissionTitle = UILabel()
        .then {
            $0.text = "내 위치 공개"
            $0.font = UIFont.PretendardMedium(size: 16)
            $0.textColor = .gray900
        }
    
    private let locationPermissionMessage = UILabel()
        .then {
            $0.text = "친구들에게 보이기"
            $0.font = .body3
            $0.textColor = .gray900
        }
    
    private let locationPermissionToggleBtn = UISwitch()
        .then {
            $0.onTintColor = .main
        }
    
    private let viewModel = MapFilterVM()
    private let bag = DisposeBag()
    
    override func configureView() {
        super.configureView()
        configureLayout()
        bindBtn()
    }
}

// MARK: - Configure

extension MapFilterBottomSheet {
    func configureBtnStatus(myBlocks: Bool, friends: Bool, myLocation: Bool) {
        showMyBlocksBtn.isSelected = myBlocks
        showFriendsBtn.isSelected = friends
        locationPermissionToggleBtn.isOn = myLocation
    }
}

// MARK: - Layout

extension MapFilterBottomSheet {
    func configureLayout() {
        contentView.addSubviews([viewBar,
                                 sheetTitle,
                                 titleMessage,
                                 btnStackView,
                                 separatorLine,
                                 locationPermissionTitle,
                                 locationPermissionMessage,
                                 locationPermissionToggleBtn])
        btnStackView.addArrangedSubview(showMyBlocksBtn)
        btnStackView.addArrangedSubview(showFriendsBtn)
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(340)
        }
        
        viewBar.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        sheetTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(viewBar.snp.bottom).offset(8)
        }
        
        titleMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sheetTitle.snp.bottom).offset(8)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(titleMessage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(55)
            $0.trailing.equalToSuperview().offset(-55)
            $0.height.equalTo(88)
        }
        
        separatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(btnStackView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        locationPermissionTitle.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        locationPermissionMessage.snp.makeConstraints {
            $0.top.equalTo(locationPermissionTitle.snp.bottom).offset(16)
            $0.leading.equalTo(locationPermissionTitle)
        }
        
        locationPermissionToggleBtn.snp.makeConstraints {
            $0.centerY.equalTo(locationPermissionMessage)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - bind

extension MapFilterBottomSheet {
    func bindBtn() {
        // 나의 기록 보기 버튼
        showMyBlocksBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showMyBlocksBtn.isSelected.toggle()
                // TODO: - 지도 UI 변경
                self.viewModel.postMyAreaVisibleToggle()
            })
            .disposed(by: bag)

        // 친구 보기 버튼
        showFriendsBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showFriendsBtn.isSelected.toggle()
                // TODO: - 지도 UI 변경
                self.viewModel.postFriendVisibleToggle()
            })
            .disposed(by: bag)
        
        // 내 위치 공개 버튼
        locationPermissionToggleBtn.rx.isOn
            .changed
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                owner.viewModel.postMyLocationVisibleToggle()
            })
            .disposed(by: bag)
    }
}
