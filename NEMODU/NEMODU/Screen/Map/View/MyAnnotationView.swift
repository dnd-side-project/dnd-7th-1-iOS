//
//  MyAnnotationView.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit
import Then
import SnapKit
import MapKit

class MyAnnotationView: MKAnnotationView {
    private lazy var pinImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 56, height: 74)))
        .then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "marker_me")
            $0.addShadow()
        }
    
    private lazy var profileImage = UIImageView()
        .then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    
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
        let size = pinImageView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
}

// MARK: Configure

extension MyAnnotationView {
    private func addViews() {
        addSubviews([profileImage, pinImageView])
    }
    
    private func configureContent() {
        if let annotation = annotation as? MyAnnotation,
           let image = annotation.profileImage {
            profileImage.image = image
        }
    }
}

// MARK: - Layout

extension MyAnnotationView {
    private func configureLayout() {
        pinImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(pinImageView.snp.top).offset(3)
            $0.leading.equalTo(pinImageView.snp.leading).offset(3)
            $0.trailing.equalTo(pinImageView.snp.trailing).offset(-3)
            $0.width.height.equalTo(50)
        }
        
        profileImage.layer.cornerRadius = 25
    }
    
    private func configureFrame() {
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
    }
}
