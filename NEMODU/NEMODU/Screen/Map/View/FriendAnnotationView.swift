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
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 4
        }
    
    private lazy var pinImageView = UIImageView(frame: CGRect(origin: .zero,
                                                              size: CGSize(width: 46, height: 62)))
        .then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "friend_none")
            $0.addShadow()
        }
    
    private lazy var nickname = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .caption1
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.preferredMaxLayoutWidth = 83
        }
    
    private lazy var profileImage = UIImageView()
        .then {
            $0.clipsToBounds = true
        }
    
    private lazy var challengeCntImageView = UIImageView()
    
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
        pinImageView.addSubview(profileImage)
    }
    
    private func configureContent() {
        if let annotation = annotation as? FriendAnnotation {
            nickname.text = annotation.title
            color = annotation.color
            
            if let image = annotation.profileImage {
                profileImage.image = image
            }
        }
    }
}

// MARK: - Layout

extension FriendAnnotationView {
    private func configureLayout() {
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
        
        profileImage.layer.cornerRadius = 21
    }
    
    private func configureFrame() {
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
    }
}
