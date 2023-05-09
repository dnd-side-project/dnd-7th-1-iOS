//
//  SelectFriendsTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/26.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class SelectFriendsTVC : BaseTableViewCell {
    
    // MARK: - UI components
    
    private let selectFriendsView = SelectFriendsView()
    
    // MARK: - Variables and Properties
    
    private var isSelectCheck: Bool = false
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Function
    
    /// 친구목록 셀 선택/해제 시 체크 이미지 토글 함수
    func didTapCheck() {
        isSelectCheck.toggle()
        selectFriendsView.checkImageView.image = UIImage(named: isSelectCheck ? "checkCircle" : "uncheck")?.withRenderingMode(.alwaysTemplate)
        selectFriendsView.checkImageView.tintColor = isSelectCheck ? .secondary : .gray300
    }
    
}

// MARK: - Configure

extension SelectFriendsTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
    /// SelectFriendsTVC 내부 컴포넌트 표시 값 초기화 함수
    func configureSelectFriendsTVC(friendInfo: Info) {
        selectFriendsView.configureSelectFriendsView(friendInfo: friendInfo)
    }
    
}

// MARK: - Layout

extension SelectFriendsTVC {
    
    private func configureLayout() {
        contentView.addSubview(selectFriendsView)
        
        selectFriendsView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
}
