//
//  BaseCollectionViewCell.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/07/28.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        layoutView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Function
    
    func configureView() {}
    
    func layoutView() {}
}
