//
//  BaseTableViewCell.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/10.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    func configureView() {}
    
    func layoutView() {}
}
