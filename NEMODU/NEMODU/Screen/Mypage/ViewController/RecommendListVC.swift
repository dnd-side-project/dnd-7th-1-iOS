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
import RxDataSources

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
            $0.rowHeight = RecommendListVC.friendCellHeight
        }
    
    private let viewMoreKakaoFriendBtn = ViewMoreBtn()
        .then {
            $0.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
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
    
    static let friendCellHeight = 64.0
    
    private let viewModel = RecommendListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getKakaoFriendList()
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
        bindKakaoRecommendTV()
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
                               kakaoRecommendTV,
                               viewMoreKakaoFriendBtn])
        nemoduView.addSubviews([nemoduTitleLabel,
                                nemoduRecommendTV])
        
        kakaoRecommendTV.register(FriendAddTVC.self, forCellReuseIdentifier: FriendAddTVC.className)
        kakaoRecommendTV.register(ViewMoreTVC.self, forCellReuseIdentifier: ViewMoreTVC.className)
        
        nemoduRecommendTV.register(FriendAddTVC.self, forCellReuseIdentifier: FriendAddTVC.className)
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(viewMoreKakaoFriendBtn.snp.top)
        }
        
        viewMoreKakaoFriendBtn.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(40)
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
    private func bindKakaoRecommendTV() {
        viewModel.output.kakaoFriendsList.dataSource
            .bind(to: kakaoRecommendTV.rx.items(dataSource: kakaoTableViewDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.output.kakaoFriendsList.friendsInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.kakaoRecommendTV.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension RecommendListVC {
    /// 내 친구 목록 tableView DataSource
    func kakaoTableViewDataSource() -> RxTableViewSectionedReloadDataSource<FriendListDataSource<KakaoFriendInfo>> {
        RxTableViewSectionedReloadDataSource<FriendListDataSource<KakaoFriendInfo>>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: FriendAddTVC.className,
                        for: indexPath
                      ) as? FriendAddTVC
                else {
                    return UITableViewCell()
                }
                return cell
            })
    }
}

// MARK: - UITableViewDataSource

extension RecommendListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendAddTVC.className) as? FriendAddTVC,
              let viewMoreCell = tableView.dequeueReusableCell(withIdentifier: ViewMoreTVC.className) as? ViewMoreTVC
        else { return UITableViewCell() }
        
        if indexPath.row == 3 {
            return viewMoreCell
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
