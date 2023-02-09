//
//  FriendColoredAnnotationView.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/25.
//

import UIKit
import Then
import SnapKit
import MapKit

class FriendColoredAnnotationView: MKAnnotationView {
    
    // MARK: - UI components
    
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
    
    // MARK: - Variables and Properties
    
    var color: UIColor!
    
    // MARK: - Life Cycle
    
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
    
    // MARK: - Functions
}

// MARK: - Configure

extension FriendColoredAnnotationView {
    
    private func addViews() {
        addSubview(stackView)
        [nickname, pinImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        pinImageView.addSubviews([profileImage])//, challengeCntImageView])
    }
    
    private func configureContent() {
        if let annotation = annotation as? FriendColoredAnnotation {
            nickname.text = annotation.title
            color = annotation.color
            if let image = annotation.profileImage {
                profileImage.image = image
            }
            
            // annotation에 색깔 추가
            pinImageView.image = pinImageView.image?.withTintColor(color.withAlphaComponent(1.0), renderingMode: .alwaysOriginal)
        }
    }
    
}

// MARK: - Layout

extension FriendColoredAnnotationView {
    
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
        profileImage.layer.cornerRadius = 21
    }
    
    private func configureFrame() {
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
    
}
