//
//  MyRecordListTVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/22.
//

import UIKit
import SnapKit
import Then

class MyRecordListTVC: UITableViewCell {
    private let dateLabel = UILabel()
        .then {
            $0.font = .body4
            $0.textColor = .gray600
        }
    
    private let recordDataLabel = UILabel()
        .then {
            $0.font = .body1
            $0.textColor = .gray800
        }
    
    private let arrow = UIImageView(image: UIImage(named: "arrow_right")?
        .withTintColor(.gray300, renderingMode: .alwaysOriginal))
    
    var recordID: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recordID = nil
        dateLabel.text = "-월 -일 -요일 --:--"
        recordDataLabel.text = "-칸, -보, -M, -분"
    }
}

// MARK: - Configure

extension MyRecordListTVC {
    private func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubviews([dateLabel,
                     recordDataLabel,
                     arrow])
        contentView.layer.borderColor = UIColor.gray200.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
    }
    
    private func configureLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        recordDataLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
    }
    
    func configureCell(with element: ActivityRecord) {
        recordID = element.recordID
        dateLabel.text = element.started
        recordDataLabel.text = "\(element.matrixNumber)칸, \(element.stepCount)보, \(element.distance)M, \(element.exerciseTime)"
    }
}
