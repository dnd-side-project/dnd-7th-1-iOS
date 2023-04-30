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
import RxDataSources
import DynamicBottomSheet
import Kingfisher

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
    
    private let profileImageBtn = UIButton()
        .then {
            $0.setImage(.defaultThumbnail, for: .normal)
            $0.layer.cornerRadius = 48
            $0.clipsToBounds = true
            $0.imageView?.contentMode = .scaleAspectFill
        }
    
    private let nicknameLabel = UILabel()
        .then {
            $0.font = .title3SB
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.text = "-"
        }
    
    private let lastAccessTime = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray600
            $0.textAlignment = .center
            $0.text = "최근 활동: -분 전"
        }
    
    private let profileMessage = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.text = "-"
        }
    
    private let addFriendBtn = UIButton()
        .then {
            $0.imageView?.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .body3
            $0.sizeToFit()
            $0.semanticContentAttribute = .forceRightToLeft
            $0.layer.cornerRadius = 17
            $0.contentEdgeInsets = UIEdgeInsets(top: 0,
                                                left: 12,
                                                bottom: 0,
                                                right: 8)
            
            $0.setTitle(FriendStatusType.noFriend.title, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.main, for: .normal)

            $0.setTitle(FriendStatusType.requesting.title, for: .selected)
            $0.setTitleColor(.gray700, for: .selected)
            $0.setBackgroundColor(.white, for: .selected)
            
            $0.layer.borderColor = FriendStatusType.noFriend.borderColor
            $0.toggleButtonImage(defaultImage: FriendStatusType.noFriend.image,
                                 selectedImage: FriendStatusType.requesting.image)
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
            $0.separatorInset = UIEdgeInsets(top: 0,
                                             left: 16,
                                             bottom: 0,
                                             right: 16)
            $0.backgroundColor = .white
        }
    
    var nickname: String?
    weak var delegate: DeselectAnnotation?
    private let viewModel = FriendProfileVM()
    private let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriendProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.deselectAnnotation()
    }
    
    override func configureView() {
        super.configureView()
        configureBottomSheet()
        configureLayout()
        bindBtn()
        bindProfile()
        bindTableView()
        bindFriendRequest()
    }
}

// MARK: - Configure

extension FriendProfileBottomSheet {
    private func getFriendProfile() {
        guard let nickname = nickname else {
            // TODO: - 오류 Popup 띄우기
            dismiss(animated: false)
            return
        }
        viewModel.getFriendProfile(friendNickname: nickname)
    }
    
    private func configureBottomSheet() {
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(baseView)
        baseView.addSubviews([profileView,
                              challengeListView])
        profileView.addSubviews([nicknameLabel,
                                 profileImageBtn,
                                 lastAccessTime,
                                 profileMessage,
                                 addFriendBtn,
                                 recordStackView])
        challengeListView.addSubview(listTitle)
    }
    
    private func configureNoneData() {
        challengeListView.addSubview(noneMessage)
        
        noneMessage.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func configureChallengeListTV(challengeCnt: Int) {
        challengeListView.addSubview(proceedingChallengeTV)
        
        proceedingChallengeTV.register(ProceedingChallengeTVC.self,
                                       forCellReuseIdentifier: ProceedingChallengeTVC.className)
        proceedingChallengeTV.delegate = self
        
        proceedingChallengeTV.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(69 * challengeCnt)
        }
    }
    
    private func setProfile(_ profile: ProfileResponseModel) {
        guard let friendType = FriendStatusType(rawValue: profile.isFriend) else { return }
        profileImageBtn.kf.setImage(with: profile.profileImageURL,
                                    for: .normal,
                                    placeholder: .defaultThumbnail)
        nicknameLabel.text = profile.nickname
        lastAccessTime.text = "최근 활동 : \(profile.lasted.relativeDateTime(.withTime))"
        profileMessage.text = profile.intro
        configureAddFriendBtn(friendType)
        recordStackView.setRecordData(value1: profile.areas.insertComma,
                                      value2: profile.allMatrixNumber.insertComma,
                                      value3: "\(profile.rank)")
        recordStackView.secondView.recordValue.insertComma()
    }
    
    private func configureAddFriendBtn(_ friendType: FriendStatusType) {
        addFriendBtn.isUserInteractionEnabled = friendType.isUserInteractionEnabled
        addFriendBtn.isSelected = friendType.isSelected ?? false
        addFriendBtn.layer.borderColor = friendType.borderColor
        
        if !friendType.isUserInteractionEnabled {
            addFriendBtn.setTitle(friendType.title, for: .normal)
            addFriendBtn.setTitleColor(friendType.textColor, for: .normal)
            addFriendBtn.setBackgroundColor(friendType.backgroundColor, for: .normal)
            addFriendBtn.setImage(friendType.image, for: .normal)
        }
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
        
        profileImageBtn.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.top).offset(-48)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(96)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageBtn.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        lastAccessTime.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
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
        profileImageBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showProfileImage(with: self.profileImageBtn.currentImage!)
            })
            .disposed(by: bag)
        
        addFriendBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let friendNickname = self.nicknameLabel.text else { return }
                let friend = FriendRequestModel(friendNickname: friendNickname)
                self.addFriendBtn.isSelected.toggle()
                
                if self.addFriendBtn.isSelected {
                    self.viewModel.requestFriend(to: friend)
                    self.addFriendBtn.layer.borderColor = UIColor.gray700.cgColor
                } else {
                    self.viewModel.deleteFriend(to: friend)
                    self.addFriendBtn.layer.borderColor = UIColor.main.cgColor
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension FriendProfileBottomSheet {
    func bindProfile() {
        viewModel.output.profileData
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.setProfile(item)
            })
            .disposed(by: bag)
    }
    
    func bindTableView() {
        viewModel.output.dataSource
            .bind(to: proceedingChallengeTV.rx.items(dataSource: tableViewDataSource()))
            .disposed(by: bag)
        
        viewModel.output.challengeList
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                item.count == 0
                ? owner.configureNoneData()
                : owner.configureChallengeListTV(challengeCnt: item.count)
                owner.proceedingChallengeTV.reloadData()
            })
            .disposed(by: bag)
    }
}

// MARK: - DataSource

extension FriendProfileBottomSheet {
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource> {
        RxTableViewSectionedReloadDataSource<ProceedingChallengeDataSource>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProceedingChallengeTVC.className,
                    for: indexPath
                ) as? ProceedingChallengeTVC else {
                    fatalError()
                }
                // 등록
                cell.configureCell(with: item, isMyList: false)
                
                return cell
            })
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

// MARK: - DeselectAnnotation Protocol
protocol DeselectAnnotation: AnyObject {
    func deselectAnnotation()
}
