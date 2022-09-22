//
//  AddFriendsVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/09/12.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class AddFriendsVC: BaseViewController {
    private let titleLabel = UILabel()
        .then {
            $0.text = "네모두를 이용중인\n카카오톡 친구"
            $0.font = .title1
            $0.textColor = .gray900
            $0.setLineBreakMode()
        }
    
    private let messageLabel = UILabel()
        .then {
            $0.text = "친구가 되면 함께 챌린지를 할 수 있어요.\n친구 요청을 보내보세요!"
            $0.font = .body3
            $0.textColor = .gray700
            $0.setLineBreakMode()
        }
    
    private let subTitleLabel = UILabel()
        .then {
            $0.text = "카카오톡 친구"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let friendsCntLabel = UILabel()
        .then {
            $0.text = "(0/0)"
            $0.font = .body3
            $0.textColor = .gray400
            $0.textAlignment = .right
        }
    
    private let friendsTV = UITableView(frame: .zero)
        .then {
            $0.separatorStyle = .none
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension AddFriendsVC {
    private func configureContentView() {
        view.addSubviews([titleLabel,
                          messageLabel,
                          subTitleLabel,
                          friendsCntLabel,
                          friendsTV])
        
        friendsTV.register(AddFriendTVC.self, forCellReuseIdentifier: AddFriendTVC.className)
        friendsTV.delegate = self
    }
}

// MARK: - Layout

extension AddFriendsVC {
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        friendsCntLabel.snp.makeConstraints {
            $0.centerY.equalTo(subTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        friendsTV.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension AddFriendsVC {
    
}

// MARK: - Output

extension AddFriendsVC {
    
}

// MARK: - UITableViewDelegate

extension AddFriendsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.0
    }
}
