//
//  FriendListView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/09/08.
//

import UIKit
import Then
import SnapKit

class FriendListView: BaseView {
    
    // MARK: - UI components
    
    let containerView = UIView()
    let profileImage = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.layer.cornerRadius = 36
            $0.layer.masksToBounds = true
        }
    lazy var cancelButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .secondary
            $0.backgroundColor = .white
            
            $0.layer.cornerRadius = 10
        }
    let nicknameLabel = PaddingLabel()
        .then {
            $0.text = "아무개"
            $0.font = .body4
            $0.textColor = .gray900
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        addSubview(containerView)
        containerView.addSubviews([profileImage, cancelButton, nicknameLabel])
        
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        profileImage.snp.makeConstraints {
            $0.width.height.equalTo(profileImage.layer.cornerRadius * 2)

            $0.centerX.equalTo(containerView)
            $0.top.equalTo(containerView.snp.top)
            $0.horizontalEdges.equalTo(containerView)
        }
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(cancelButton.layer.cornerRadius * 2)
            
            $0.top.right.equalTo(profileImage)
        }
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalTo(profileImage)

            $0.top.equalTo(profileImage.snp.bottom).offset(8)
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
}
