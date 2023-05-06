//
//  NotificationListTVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/05/04.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NotificationListTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 16.0
            $0.distribution = .fill
            $0.alignment = .center
        }
    private let iconImageView = UIImageView()
        .then {
            $0.image = .defaultThumbnail
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 50 / 2
            $0.clipsToBounds = true
        }
    
    private let contentStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
        }
    private let titleLabel = UILabel()
        .then {
            $0.text = "----"
            $0.setLineBreakMode()
            $0.font = .body3
            $0.textColor = .gray900
        }
    private let bodyLabel = UILabel()
        .then {
            $0.text = "----"
            $0.setLineBreakMode()
            $0.font = .caption1
            $0.textColor = .gray500
        }
    
    private let timeAgoLabel = UILabel()
        .then {
            $0.text = "- 전"
            $0.font = .caption1
            $0.textColor = .gray500
            $0.textAlignment = .right
        }
    
    private let seperatorView = UIView()
        .then {
            $0.backgroundColor = .gray100
        }
    
    // MARK: - Variables and Properties
    
    // TODO: dummyData Type 삭제
    typealias NotificationListType = ((iconType: String, title: String, body: String, time:String, isRead: Bool))
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureTVC()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        iconImageView.clipsToBounds = true
        titleLabel.text = nil
        bodyLabel.text = nil
        timeAgoLabel.text = nil
    }
}

// MARK: - Configure

extension NotificationListTVC {
    
    private func configureTVC() {
        selectionStyle = .none
    }
    
    func configureNotificationListTVC(dummyData: NotificationListType) {
        // TODO: 서버연결 후 dummyData 타입 변경
        iconImageView.image = UIImage(named: (NotificationListIcon(rawValue: dummyData.iconType.lowercased())?.getNotificationIconImageNamed(isRead: dummyData.isRead)) ?? "defaultThumbnail")
        iconImageView.clipsToBounds = dummyData.isRead
        titleLabel.text = dummyData.title
        bodyLabel.text = dummyData.body
        timeAgoLabel.text = dummyData.time.relativeDateTime(.withTime)
        timeAgoLabel.snp.updateConstraints {
            $0.width.equalTo(timeAgoLabel.intrinsicContentSize.width)
        }
    }
}

// MARK: - Layout

extension NotificationListTVC {
    
    private func configureLayout() {
        contentView.addSubviews([baseStackView,
                                timeAgoLabel,
                                seperatorView])
        [iconImageView, contentStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        [titleLabel, bodyLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(16.0)
            $0.left.equalTo(contentView.snp.left).offset(20.0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(iconImageView.layer.cornerRadius * 2)
        }
        
        timeAgoLabel.snp.makeConstraints {
            $0.width.equalTo(timeAgoLabel.intrinsicContentSize.width)
            
            $0.top.equalTo(titleLabel.snp.top)
            $0.left.equalTo(baseStackView.snp.right).offset(12.0)
            $0.right.equalTo(contentView.snp.right).offset(-20.0)
        }
        
        seperatorView.snp.makeConstraints {
            $0.height.equalTo(1.0)

            $0.bottom.horizontalEdges.equalTo(contentView)
        }
    }
    
}
