//
//  SetAuthorityVC.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/04/08.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

import SafariServices

class SetAuthorityVC: BaseViewController {
    
    // MARK: - UI components
    
    private let titleLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .title2
            $0.text = "앱 권한 설정 안내"
            $0.textColor = .gray900
            $0.textAlignment = .left
        }
    private let explainLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .body3
            $0.text = "네모두에서 사용하는 권한에 대해 안내드립니다."
            $0.textColor = .gray700
            $0.textAlignment = .left
        }
    
    private let authorityListStackView = UIStackView()
        .then {
            $0.spacing = 20.0
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .leading
        }

    private let informLabel = UILabel()
        .then {
            $0.setLineBreakMode()
            $0.font = .caption1
            $0.text = "정보통신망 이용촉진 및 정보보호 등에 관한 법률 시행령 개정에 따른 안내입니다. 선택적 접근권한의 경우 허용에 동의하지 않으셔도 네모두를 사용하실 수 있습니다."
            $0.textColor = .gray500
            $0.textAlignment = .left
        }

    private let confirmButton = UIButton()
        .then {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .headline1
            $0.tintColor = .secondary
            $0.setTitleColor(.secondary, for: .normal)

            $0.backgroundColor = .main

            $0.layer.cornerRadius = 48 / 2
            $0.addShadow()
        }
    
    private let viewModel = EnterVM()
    
    var userDataModel: UserDataModel?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        
        configureAuthorityListStackView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        changeRootVC()
    }
    
    override func bindLoading() {
        super.bindLoading()
        viewModel.output.loading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.loading(loading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure

extension SetAuthorityVC {
    
    private func configureAuthorityListStackView() {
        typealias Auth = (imageNamed: String, title: String, option: String, explain: String)
        let authList: [Auth] = [("LocationOn", "위치", "(필수)", "현재 위치를 바탕으로 기록 저장"),
                                  ("AllInbox", "저장 공간", "(선택)", "프로필 사진 변경 시 갤러리 접근")]
        
        authList.forEach { auth in
            let baseView = UIView()
            
            let iconView = UIView()
                .then {
                    $0.backgroundColor = .gray100
                    $0.layer.cornerRadius = 50 / 2
                }
            let iconImageView = UIImageView()
                .then {
                    $0.image = UIImage(named: auth.imageNamed)?.withRenderingMode(.alwaysTemplate)
                    $0.tintColor = .gray300
                }
            
            let titleLabel = UILabel()
                .then {
                    let attributedText = NSMutableAttributedString(string: auth.title,
                                                                   attributes: [NSAttributedString.Key.font: UIFont.headline1,
                                                                                NSAttributedString.Key.foregroundColor: UIColor.gray900])
                    attributedText.append(NSAttributedString(string: " \(auth.option)",
                                                             attributes: [NSAttributedString.Key.font: UIFont.headline1,
                                                                          NSAttributedString.Key.foregroundColor: auth.option == "(필수)" ? UIColor.main : UIColor.gray500]))
                    $0.attributedText = attributedText
                }
            let explainLabel = UILabel()
                .then {
                    $0.text = auth.explain
                    $0.textColor = .gray700
                    $0.font = .caption1
                }
            
            baseView.addSubviews([iconView,
                                  titleLabel, explainLabel])
            iconView.addSubview(iconImageView)
            
            iconView.snp.makeConstraints {
                $0.width.height.equalTo(50.0)
                
                $0.top.left.bottom.equalTo(baseView)
            }
            iconImageView.snp.makeConstraints {
                $0.width.height.equalTo(24.0)
                
                $0.center.equalTo(iconView)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(iconView.snp.top).offset(5.0)
                $0.left.equalTo(iconView.snp.right).offset(16.0)
            }
            explainLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(6.0)
                $0.left.equalTo(titleLabel)
            }
            
            authorityListStackView.addArrangedSubview(baseView)
        }
    }
    
}

// MARK: - Layout

extension SetAuthorityVC {
    
    private func configureLayout() {
        view.addSubviews([titleLabel,
                          explainLabel,
                          authorityListStackView,
                          informLabel,
                          confirmButton])
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48.0)
            $0.horizontalEdges.equalTo(view).inset(24.0)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(titleLabel)
        }
        
        authorityListStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(32.0)
            $0.horizontalEdges.equalTo(explainLabel)
        }
        informLabel.snp.makeConstraints {
            $0.top.equalTo(authorityListStackView.snp.bottom).offset(32.0)
            $0.horizontalEdges.equalTo(authorityListStackView)
        }

        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48.0)

            $0.horizontalEdges.equalTo(view).inset(24.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24.0)
        }
    }
    
}

// MARK: - Input

extension SetAuthorityVC {
    private func bindButton() {
        confirmButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let userDataModel = self.userDataModel else { return }
                self.viewModel.requestSignup(userDataModel)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension SetAuthorityVC {
    private func changeRootVC() {
        viewModel.output.isLoginSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.setTBCtoRootVC()
            })
            .disposed(by: disposeBag)
    }
}
