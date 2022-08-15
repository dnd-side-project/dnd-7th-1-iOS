//
//  CustomAnnotationView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit
import Then
import SnapKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
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
            $0.image = UIImage(named: "friend_none")
            $0.addShadow()
        }
    
    private lazy var title = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .caption1
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.preferredMaxLayoutWidth = 83
        }
    
    private lazy var imageView = UIImageView()
        .then {
            $0.clipsToBounds = true
        }
    
    private lazy var challengeCntImageView = UIImageView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureAnnotation()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        title.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        configureContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFrame()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
}

// MARK: Configure

extension CustomAnnotationView {
    private func configureAnnotation() {
        addSubview(stackView)
        [title, pinImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        pinImageView.addSubview(imageView)
    }
    
    private func configureContent() {
        if let annotation = annotation as? CustomAnnotation {
            title.text = annotation.title
            
            if let imageName = annotation.imageName,
               let image = UIImage(named: imageName) {
                imageView.image = image
            }
        }
    }
}

// MARK: - Layout

extension CustomAnnotationView {
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().offset(-2)
            $0.height.width.equalTo(42)
        }
        
        imageView.layer.cornerRadius = 21
    }
    
    private func configureFrame() {
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
    }
}
