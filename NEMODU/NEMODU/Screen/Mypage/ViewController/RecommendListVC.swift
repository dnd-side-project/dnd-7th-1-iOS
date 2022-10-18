//
//  RecommendListVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/16.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class RecommendListVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let contentView = UIView()
    
    private let kakaoView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let kakaoTitleLabel = UILabel()
        .then {
            $0.text = "카카오톡 추천 친구"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let kakaoRecommendTV = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    
    private let separatorView = UIView()
        .then {
            $0.backgroundColor = .gray50
        }
    
    private let nemoduView = UIView()
        .then {
            $0.backgroundColor = .systemBackground
        }
    
    private let nemoduTitleLabel = UILabel()
        .then {
            $0.text = "카카오톡 추천 친구"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let nemoduRecommendTV = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension RecommendListVC {
    private func configureContentView() {
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([kakaoView,
                                 separatorView,
                                 nemoduView])
        kakaoView.addSubviews([kakaoTitleLabel,
                               kakaoRecommendTV])
        nemoduView.addSubviews([nemoduTitleLabel,
                                nemoduRecommendTV])
        
        kakaoRecommendTV.register(RecommendFriendTVC.self, forCellReuseIdentifier: RecommendFriendTVC.className)
        kakaoRecommendTV.register(ViewMoreTVC.self, forCellReuseIdentifier: ViewMoreTVC.className)
        kakaoRecommendTV.dataSource = self
        kakaoRecommendTV.delegate = self
        
        nemoduRecommendTV.register(RecommendFriendTVC.self, forCellReuseIdentifier: RecommendFriendTVC.className)
        nemoduRecommendTV.register(ViewMoreTVC.self, forCellReuseIdentifier: ViewMoreTVC.className)
        nemoduRecommendTV.dataSource = self
        nemoduRecommendTV.delegate = self
    }
}

// MARK: - Layout

extension RecommendListVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        kakaoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(288)
        }
        
        kakaoTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        kakaoRecommendTV.snp.makeConstraints {
            $0.top.equalTo(kakaoTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(kakaoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        nemoduView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(288)
        }
        
        nemoduTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(56)
        }
        
        nemoduRecommendTV.snp.makeConstraints {
            $0.top.equalTo(nemoduTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Input

extension RecommendListVC {
    
}

// MARK: - Output

extension RecommendListVC {
    
}

// MARK: - UITableViewDataSource

extension RecommendListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendFriendTVC.className) as? RecommendFriendTVC,
              let viewMoreCell = tableView.dequeueReusableCell(withIdentifier: ViewMoreTVC.className) as? ViewMoreTVC
        else { return UITableViewCell() }
        
        if indexPath.row == 3 {
            return viewMoreCell
        }
        
        if tableView == kakaoRecommendTV {
            cell.configureCell("카카오 저장 이름")
        } else {
            cell.configureCell()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecommendListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: - 인덱스 수정
        if indexPath.row == 3 {
            return 40
        } else {
            return 64
        }
    }
}
