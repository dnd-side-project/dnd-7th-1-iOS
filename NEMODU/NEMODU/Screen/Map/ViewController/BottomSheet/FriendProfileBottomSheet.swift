//
//  FriendProfileBottomSheet.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import DynamicBottomSheet

class FriendProfileBottomSheet: DynamicBottomSheetViewController {
    private let baseView = UIView()
        .then {
            $0.backgroundColor = .gray50
            $0.roundCorners(radius: 16)
        }
    
    private let profileView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
            $0.roundCorners(radius: 16)
        }
    
    private let challengeListView = UIView()
        .then {
            $0.backgroundColor = UIColor.systemBackground
        }
    
    private let profileImgBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "defaultThumbnail"), for: .normal)
            $0.layer.cornerRadius = 48
            $0.clipsToBounds = true
        }
    
    private let nickname = UILabel()
        .then {
            $0.font = .title3SB
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.text = "-"
        }
    
    private let lastAccessTime = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray500
            $0.textAlignment = .center
            $0.text = "최근 활동: -분 전"
        }
    
    private let profileMessage = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.text = "-"
        }
    
    private let addFriendBtn = UIButton()
        .then {
            $0.setTitle("친구 추가", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)

            $0.setTitle("친구중", for: .selected)
            $0.setTitleColor(.main, for: .selected)
            $0.setBackgroundColor(.white, for: .selected)
            
            $0.toggleButtonImage(defaultImage: UIImage(named: "add")!.withTintColor(.white, renderingMode: .alwaysOriginal),
                                 selectedImage: UIImage(named: "check")!.withTintColor(.main, renderingMode: .alwaysOriginal))
            $0.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
            $0.layer.borderColor = UIColor.main.cgColor
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .body3
            $0.sizeToFit()
            $0.semanticContentAttribute = .forceRightToLeft
            $0.layer.cornerRadius = 17
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8)
        }
    
    private let recordStackView = ProfileRecordStackView()
        .then {
            $0.firstView.recordTitle.text = "이번주 영역"
            $0.firstView.valueUnit.text = "칸"
            $0.secondView.recordTitle.text = "역대 누적 칸 수"
            $0.thirdView.recordTitle.text = "랭킹"
            $0.thirdView.valueUnit.text = "위"
        }
    
    private let listTitle = UILabel()
        .then {
            $0.text = "함께 진행중인 챌린지"
            $0.textColor = .gray900
            $0.font = .body1
        }
    
    private let noneMessage = UILabel()
        .then {
            $0.text = "함께 진행중인 챌린지가 없습니다.\n일주일 챌린지, 실시간 챌린지를 신청해 함께 시작해보세요!"
            $0.font = .caption1
            $0.textColor = .gray500
            $0.setLineBreakMode()
            $0.textAlignment = .center
        }
    
    private let proceedingChallengeTV = UITableView(frame: .zero)
        .then {
            $0.isScrollEnabled = false
            $0.separatorStyle = .singleLine
            $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.backgroundColor = .white
        }
    
    private let bag = DisposeBag()
    var challengeCnt: Int?
    
    override func configureView() {
        super.configureView()
        configureBottomSheet()
        configureLayout()
        bindBtn()
    }
}

// MARK: - Configure

extension FriendProfileBottomSheet {
    private func configureBottomSheet() {
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(baseView)
        baseView.addSubviews([profileView,
                              challengeListView])
        profileView.addSubviews([nickname,
                                 profileImgBtn,
                                 lastAccessTime,
                                 profileMessage,
                                 addFriendBtn,
                                 recordStackView])
        challengeListView.addSubview(listTitle)
        
        
        challengeCnt == 0 || challengeCnt == nil
        ? configureNoneData() : configureChallengeListTV()
        
        // TODO: - 서버 연결 후 수정
        recordStackView.setRecordData(value1: 9,
                                      value2: 1030,
                                      value3: 1)
        recordStackView.secondView.recordValue.insertComma()
    }
    
    private func configureNoneData() {
        challengeListView.addSubview(noneMessage)
        
        noneMessage.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func configureChallengeListTV() {
        challengeListView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        proceedingChallengeTV.dataSource = self
        proceedingChallengeTV.delegate = self
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(69 * (challengeCnt ?? 0))
        }
    }
    
    func setProfile() {
        // TODO: - friend Model 생성 후 연결
    }
}

// MARK: - Layout

extension FriendProfileBottomSheet {
    private func configureLayout() {
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        profileImgBtn.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.top).offset(-48)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(96)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalTo(profileImgBtn.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        lastAccessTime.snp.makeConstraints {
            $0.top.equalTo(nickname.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        profileMessage.snp.makeConstraints {
            $0.top.equalTo(lastAccessTime.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        addFriendBtn.snp.makeConstraints {
            $0.top.equalTo(profileMessage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        recordStackView.snp.makeConstraints {
            $0.top.equalTo(addFriendBtn.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(89)
        }
        
        challengeListView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        listTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(51)
        }
    }
}

// MARK: - Input

extension FriendProfileBottomSheet {
    private func bindBtn() {
        addFriendBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.addFriendBtn.isSelected.toggle()
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDataSource
extension FriendProfileBottomSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        challengeCnt ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProceedingChallengeTVC.className, for: indexPath)
                as? ProceedingChallengeTVC else { fatalError() }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendProfileBottomSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        69.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
