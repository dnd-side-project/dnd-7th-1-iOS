//
//  FriendAnnotationView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit
import Then
import SnapKit
import MapKit

class FriendAnnotationView: MKAnnotationView {
    private lazy var stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 4
        }
    
    private lazy var pinImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "friend_none")
            $0.addShadow()
        }
    
    lazy var nickname = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .caption1
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.preferredMaxLayoutWidth = 83
        }
    
    private lazy var profileImage = UIImageView()
        .then {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    
    private lazy var challengeCntImageView = UIImageView()
        .then {
            $0.layer.cornerRadius = 7.5
            $0.backgroundColor = .white
        }
    
    var color: UIColor!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        nickname.text = nil
        challengeCntImageView.image = nil
        challengeCntImageView.isHidden = true
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        configureContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFrame()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        pinImageView.image = selected
        ? pinImageView.image?.drawOutlie(color: color)
        : UIImage(named: "friend_none")
    }
    
    override var intrinsicContentSize: CGSize {
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
}

// MARK: Configure

extension FriendAnnotationView {
    private func addViews() {
        addSubview(stackView)
        [nickname, pinImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        pinImageView.addSubviews([profileImage, challengeCntImageView])
    }
    
    private func configureContent() {
        if let annotation = annotation as? FriendAnnotation {
            nickname.text = annotation.title
            color = annotation.color
            isEnabled = annotation.isEnabled ?? false
            
            challengeCntImageView.image
            = annotation.challengeCnt == 0
            ? nil
            : UIImage(named: "challengeCnt\(annotation.challengeCnt!)")?
                .withTintColor(annotation.color!, renderingMode: .alwaysOriginal)
            
            challengeCntImageView.isHidden = annotation.challengeCnt == 0
            
            if let image = annotation.profileImage {
                profileImage.image = image
            }
        }
    }
}

// MARK: - Layout

extension FriendAnnotationView {
    private func configureLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pinImageView.snp.makeConstraints {
            $0.width.equalTo(46)
            $0.height.equalTo(62)
        }
        
        nickname.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.height.width.equalTo(42)
        }
        
        challengeCntImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(15)
        }
        
        profileImage.layer.cornerRadius = 21
    }
    
    private func configureFrame() {
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
}
