//
//  BaseCollectionViewCell.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {}
}
