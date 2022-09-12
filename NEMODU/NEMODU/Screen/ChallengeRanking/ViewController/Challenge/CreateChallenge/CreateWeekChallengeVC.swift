//
//  CreateWeekChallengeVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2022/08/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CreateWeekChallengeVC: CreateChallengeVC {
    
    // MARK: - UI components
    
    let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false

            $0.backgroundColor = .white
        }
    let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.alignment = .fill
            
            $0.backgroundColor = .gray100
        }
    
    lazy var challengeTypeTitleButtonView = CreateChallengeListButtonView()
        .then {
            $0.titleLabel.text = "영역 넓히기 챌린지"
            $0.statusImageView.image = UIImage(named: "check")
        }
    
    // insert Challenge Name
    let insertChallengeNameView = UIView()
        .then {
            $0.backgroundColor = .white
        }
    let insertChallengeNameLabel = UILabel()
        .then {
            $0.text = "챌린지 이름"
            $0.font = .body1
            $0.textColor = .gray900
        }
    let insertChallengeNameTextField = UITextField()
        .then {
            $0.attributedPlaceholder = NSAttributedString(string: "챌린지 이름을 작성해주세요.",
                                                          attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray600,
                                                                       NSAttributedString.Key.font: UIFont.caption1])
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
            $0.leftViewMode = .always
            
            $0.tintColor = .main
            $0.backgroundColor = .gray50
            
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
        }
    let limitedAlertChallengeNameCountImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "alert_red")
            $0.isHidden = true
        }
    let limitedAlertChallengeNameCountLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .red100
            $0.text = "챌린지 이름은 8자 이하로 작성해주세요."
            
            $0.isHidden = true
        }
    let limitedChallengeNameCountLabel = UILabel()
        .then {
            $0.font = .caption1
            $0.textColor = .gray600
            
            $0.text = "0 / 8"
        }
    
    lazy var challengePeriodButtonView = CreateChallengeListButtonView()
        .then {
            $0.titleLabel.text = "챌린지 기간"
            
            $0.actionButton.addTarget(self, action: #selector(didTapChallengePeriod), for: .touchUpInside)
        }
    
    let selectFriendsButtonViewContainer = UIView()
    lazy var selectFriendsButtonView = CreateChallengeListButtonView()
        .then {
            let attributedText = NSMutableAttributedString(string: "함께할 친구", attributes: [NSAttributedString.Key.font: UIFont.body1,
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.gray900])
            attributedText.append(NSAttributedString(string: "   "))
            attributedText.append(NSAttributedString(string: "(0 / 3)", attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                   NSAttributedString.Key.foregroundColor: UIColor.gray600]))
            $0.titleLabel.attributedText = attributedText
            
            $0.actionButton.addTarget(self, action: #selector(didTapSelectFriends), for: .touchUpInside)
        }
    
    // insert Challenge Message
    let insertChallengeMessageView = UIView()
        .then {
            $0.backgroundColor = .white
        }
    let insertChallengeMessageLabel = UILabel()
        .then {
            $0.text = "신청 메세지"
            $0.font = .body1
            $0.textColor = .gray900
        }
    let insertChallengeMessageTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "신청 메세지를 작성해주세요."
            $0.maxTextCnt = 30
            $0.configureView()
            
            $0.tintColor = .main
        }
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    var friends: [String] = []
    var message, name, nickname, started, ended: String?
    var type: String = ""
    
    var confirmButtonBottomConstraint: Constraint?
    
    var confirmButtonHight: CGFloat = 48
    var confirmButtonTop: CGFloat = 16
    var confirmButtonBottom: CGFloat = 20
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if started != nil {
            challengePeriodButtonView.statusImageView.image = UIImage(named: "check")
            
            challengePeriodButtonView.dateLabel.isHidden = false
            guard let startDate = started?.split(separator: " ") else { return }
            guard let endDate = ended?.split(separator: " ") else { return }
            challengePeriodButtonView.dateLabel.text = "\(startDate[1]) \(startDate[2]) - \(endDate[1]) \(endDate[2])"
        }
        
        if friends.count > 0 {
            _ = selectFriendsButtonView
                .then {
                    $0.statusImageView.image = UIImage(named: "check")
                    
                    let attributedText = NSMutableAttributedString(string: "함께할 친구", attributes: [NSAttributedString.Key.font: UIFont.body1,
                                                                                                  NSAttributedString.Key.foregroundColor: UIColor.gray900])
                    attributedText.append(NSAttributedString(string: "   "))
                    attributedText.append(NSAttributedString(string: "(\(friends.count) / 3)", attributes: [NSAttributedString.Key.font: UIFont.body2,
                                                                                           NSAttributedString.Key.foregroundColor: UIColor.gray600]))
                    $0.titleLabel.attributedText = attributedText
                }
            
            let stackView = UIStackView()
                .then {
                    $0.axis = .vertical
                    $0.alignment = .fill
                    
                }

            
            for i in 0..<friends.count {
                let tableViewCell = SelectFriendsTVC()
                    .then {
                        $0.userNicknameLabel.text = friends[i]
                        $0.checkImageView.isHidden = true
                    }
                
                tableViewCell.snp.makeConstraints {
                    $0.height.equalTo(64)
                }
                
                stackView.addArrangedSubview(tableViewCell)
            }
            
            selectFriendsButtonView.snp.remakeConstraints {
                $0.top.equalTo(selectFriendsButtonViewContainer.snp.top)
                $0.horizontalEdges.equalTo(selectFriendsButtonViewContainer)
            }
            
            selectFriendsButtonView.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.equalTo(selectFriendsButtonView.snp.bottom)
                $0.horizontalEdges.equalTo(selectFriendsButtonView)
                $0.bottom.equalTo(selectFriendsButtonViewContainer.snp.bottom)
            }
        }
    }
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        _ = navigationBar
            .then {
                $0.configureNaviBar(targetVC: self, title: "주간 챌린지 만들기")
                $0.configureBackBtn(targetVC: self)
            }
        
        _ = confirmButton
            .then {
                $0.isEnabled = true
            }
        
        [challengeTypeTitleButtonView, insertChallengeNameView, challengePeriodButtonView, selectFriendsButtonViewContainer, insertChallengeMessageView].forEach({
            baseStackView.addArrangedSubview($0)
        })
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(baseStackView)
        
        selectFriendsButtonViewContainer.addSubview(selectFriendsButtonView)
        insertChallengeNameView.addSubviews([insertChallengeNameLabel,
                                             insertChallengeNameTextField,
                                             limitedAlertChallengeNameCountImageView, limitedAlertChallengeNameCountLabel, limitedChallengeNameCountLabel])
        insertChallengeMessageView.addSubviews([insertChallengeMessageLabel, insertChallengeMessageTextView])
        
        
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-(confirmButtonTop+confirmButtonHight+confirmButtonBottom))
        }
        baseStackView.snp.makeConstraints {
            $0.width.equalTo(baseScrollView.snp.width)
            
            $0.edges.equalTo(baseScrollView)
        }

        insertChallengeNameView.snp.makeConstraints {
            $0.top.equalTo(challengeTypeTitleButtonView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        insertChallengeNameLabel.snp.makeConstraints {
            $0.top.equalTo(insertChallengeNameView.snp.top).offset(18.5)
            $0.horizontalEdges.equalTo(insertChallengeNameView).inset(16)
        }
        insertChallengeNameTextField.snp.makeConstraints {
            $0.height.equalTo(38)

            $0.top.equalTo(insertChallengeNameLabel.snp.bottom).offset(18.5)
            $0.horizontalEdges.equalTo(insertChallengeNameLabel)
        }
        
        limitedAlertChallengeNameCountImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            
            $0.top.equalTo(insertChallengeNameTextField.snp.bottom).offset(8)
            $0.left.equalTo(insertChallengeNameTextField.snp.left)
            $0.right.lessThanOrEqualTo(limitedChallengeNameCountLabel.snp.left)
            $0.bottom.equalTo(insertChallengeNameView.snp.bottom).inset(13)
        }
        limitedAlertChallengeNameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(limitedAlertChallengeNameCountImageView)
            $0.left.equalTo(limitedAlertChallengeNameCountImageView.snp.right).offset(4)
            $0.right.lessThanOrEqualTo(limitedChallengeNameCountLabel.snp.left)
        }
        limitedChallengeNameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(limitedAlertChallengeNameCountLabel)
            $0.right.equalTo(insertChallengeNameTextField.snp.right)
        }

        challengePeriodButtonView.snp.makeConstraints {
            $0.top.equalTo(insertChallengeNameView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        selectFriendsButtonViewContainer.snp.makeConstraints {
            $0.top.equalTo(challengePeriodButtonView.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        selectFriendsButtonView.snp.makeConstraints {
            $0.top.equalTo(selectFriendsButtonViewContainer.snp.top)
            $0.horizontalEdges.equalTo(selectFriendsButtonViewContainer)
            $0.bottom.equalTo(selectFriendsButtonViewContainer.snp.bottom)
        }

        insertChallengeMessageView.snp.makeConstraints {
            $0.top.equalTo(selectFriendsButtonViewContainer.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()
        }
        insertChallengeMessageLabel.snp.makeConstraints {
            $0.top.equalTo(insertChallengeMessageView.snp.top).offset(18.5)
            $0.horizontalEdges.equalTo(insertChallengeMessageView).inset(16)
        }
        insertChallengeMessageTextView.snp.makeConstraints {
            $0.top.equalTo(insertChallengeMessageLabel.snp.bottom).offset(18.5)
            $0.horizontalEdges.equalTo(insertChallengeMessageView).inset(16)

            $0.bottom.equalTo(insertChallengeMessageView.snp.bottom)
        }
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindChallengeNameTextField()
        bindInsertChallengeMessageTextView()
    }
    
    @objc
    func didTapChallengePeriod() {
        let challengePeriodVC = ChallengePeriodVC()
        challengePeriodVC.createWeekChallengeVC = self
        
        challengePeriodVC.modalPresentationStyle = .fullScreen
        
        present(challengePeriodVC, animated: true)
    }
    
    @objc
    func didTapSelectFriends() {
        let selectFriendsVC = SelectFriendsVC()
        selectFriendsVC.createWeekChallengeVC = self
        selectFriendsVC.modalPresentationStyle = .fullScreen
        
        present(selectFriendsVC, animated: true)
    }
    
    override func didTapConfirmButton() {
        let createChallengeSuccuessVC = CreateChallengeSuccuessVC()
        createChallengeSuccuessVC.createWeekChallengeVC = self
        
        createChallengeSuccuessVC.modalPresentationStyle = .fullScreen
        
        present(createChallengeSuccuessVC, animated: true)
    }
    
}

// MARK: - Input

extension CreateWeekChallengeVC {
    
    private func bindChallengeNameTextField() {
        insertChallengeNameTextField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [self] in
                UIView.animate(withDuration: 0.2, delay: 0, animations: { [self] in
                    insertChallengeNameTextField.layer.borderColor = UIColor.secondary.cgColor
                })
                
            })
            .disposed(by: bag)
        
        insertChallengeNameTextField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [self] in
                UIView.animate(withDuration: 0.2, delay: 0, animations: { [self] in
                    insertChallengeNameTextField.layer.borderColor = UIColor.clear.cgColor
                    
                    limitedAlertChallengeNameCountImageView.isHidden = true
                    limitedAlertChallengeNameCountLabel.isHidden = true
                })
            })
            .disposed(by: bag)
        
        insertChallengeNameTextField.rx.controlEvent([.editingChanged])
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let challengeName = self.insertChallengeNameTextField.text else { return }
                
                if challengeName.count > 8 {
                    self.insertChallengeNameTextField.layer.borderColor = UIColor.red.cgColor
                    self.limitedAlertChallengeNameCountImageView.isHidden = false
                    self.limitedAlertChallengeNameCountLabel.isHidden = false
                    
                    self.insertChallengeNameTextField.text?.removeLast()
                } else {
                    self.insertChallengeNameTextField.layer.borderColor = UIColor.secondary.cgColor
                    self.limitedAlertChallengeNameCountImageView.isHidden = true
                    self.limitedAlertChallengeNameCountLabel.isHidden = true
                    
                    self.limitedChallengeNameCountLabel.text = "\(challengeName.count) / 8"
                }
            })
            .disposed(by: bag)
    }
    
    private func bindInsertChallengeMessageTextView() {
        
        insertChallengeMessageTextView.tv.rx.didBeginEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                    
                    self.baseScrollView.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset(-self.confirmButtonTop)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        self.baseScrollView.scrollToBottom(animated: true)
                    }
                    
                    self.view.layoutIfNeeded()
                })
                
            })
            .disposed(by: bag)
        
        insertChallengeMessageTextView.tv.rx.didEndEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0.0, delay: 0, animations: {
                    
                    self.baseScrollView.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).inset(-(self.confirmButtonTop+self.confirmButtonHight+self.confirmButtonBottom))
                    }
                    
                    self.view.layoutIfNeeded()
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.baseScrollView.scrollToBottom(animated: true)
                }

                self.confirmButton.isSelected = true
            })
            .disposed(by: bag)
    }
    
}
