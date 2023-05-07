//
//  OnboardingVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/20.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

class OnboardingVC: BaseViewController {
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fill
        }
    
    private let progressStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let firstView = OnboardingView()
        .then {
            $0.title.text = "모두 함께 네모두!"
            $0.message.text = "천리길도 한 걸음부터,\n\n네모두와 함께\n걷기, 산책부터 시작해봐요 :)"
            $0.baseImageView.image = UIImage(named: "onboarding1")
            $0.backgroundColor = .systemBackground
        }
    
    private let secondView = OnboardingView()
        .then {
            $0.title.text = "기록"
            $0.message.text = "매주마다 기록하고\n나의 영역을 채워나가요!"
            $0.baseImageView.image = UIImage(named: "onboarding2")
            $0.backgroundColor = .systemBackground
        }
    
    private let thirdView = OnboardingView()
        .then {
            $0.title.text = "챌린지"
            $0.message.text = "챌린지를 통해\n친구와 함께 해요."
            $0.baseImageView.image = UIImage(named: "onboarding3")
            $0.backgroundColor = .systemBackground
        }
    
    private let startBtn = UIButton()
        .then {
            $0.isUserInteractionEnabled = false
            $0.titleLabel?.font = .headline1
            $0.backgroundColor = .gray100
            $0.tintColor = .gray400
            $0.setTitle("시작하기 ", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.layer.cornerRadius = 8
            $0.semanticContentAttribute = .forceRightToLeft
        }
    
    private let skipBtn = UIButton()
        .then {
            $0.titleLabel?.font = .headline1
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.gray500, for: .normal)
        }
    
    private let pageCnt = 3
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureOnboarding()
        configureProgress()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindScrollWithPage()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindBtn()
    }
    
}

// MARK: - Configure

extension OnboardingVC {
    private func configureOnboarding() {
        view.addSubviews([baseScrollView,
                          progressStackView,
                          startBtn,
                          skipBtn])
        baseScrollView.addSubview(baseStackView)
        [firstView, secondView, thirdView].forEach {
            baseStackView.addArrangedSubview($0)
        }
    }
    
    private func configureProgress() {
        for _ in 0..<pageCnt {
            let view = UIView()
            view.backgroundColor = .gray300
            progressStackView.addArrangedSubview(view)
        }
        progressStackView.arrangedSubviews[0].backgroundColor = .gray900
    }
    
    /// 페이지에 따라 progressStackView의 상태를 변경하는 메서드
    private func setPageControlSelectedPage(_ page: Int) {
        for i in 0..<pageCnt {
            progressStackView.arrangedSubviews[i].backgroundColor
            = page == i
            ? .gray900 : .gray300
        }
    }
    
    /// 시작하기 버튼의 활성 상태를 변경하는 메서드
    private func setStartBtnActive(_ active: Bool) {
        startBtn.isUserInteractionEnabled = active
        startBtn.backgroundColor = active ? .main : .gray100
        startBtn.tintColor = active ? .white : .gray400
        startBtn.setTitleColor(active ? .white: .gray400, for: .normal)
        
        skipBtn.isHidden = active
    }
}

// MARK: - Layout

extension OnboardingVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.centerY.equalToSuperview()
            $0.width.equalTo(screenWidth * 3)
        }
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(2)
            $0.width.equalTo(140)
        }
        
        firstView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        secondView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        thirdView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        skipBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        startBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(skipBtn.snp.top).offset(-16)
            $0.height.equalTo(44)
        }
        
        firstView.emphasis.snp.makeConstraints {
            $0.trailing.equalTo(firstView.title.snp.trailing)
        }
        
        firstView.baseImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(10)
            $0.bottom.equalTo(startBtn.snp.top).offset(-38)
        }
        
        secondView.emphasis.snp.makeConstraints {
            $0.trailing.equalTo(secondView.title.snp.trailing).offset(12)
            $0.width.equalTo(71)
        }
        
        secondView.baseImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(startBtn.snp.top).offset(-63)
        }
        
        thirdView.emphasis.snp.makeConstraints {
            $0.trailing.equalTo(thirdView.title.snp.trailing).offset(4)
        }
        
        thirdView.baseImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(startBtn.snp.top).offset(-78)
        }
    }
}

// MARK: - Input

extension OnboardingVC {
    /// scrollView의 스크롤에 따라 페이지를 연결하는 메서드
    private func bindScrollWithPage() {
        baseScrollView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let page = round(self.baseScrollView.contentOffset.x / self.screenWidth)
                if page.isNaN || page.isInfinite { return }
                self.setStartBtnActive(page == 2)
                self.setPageControlSelectedPage(Int(page))
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension OnboardingVC {
    private func bindBtn() {
        startBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentLoginVC()
            })
            .disposed(by: bag)
        
        skipBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentLoginVC()
            })
            .disposed(by: bag)
    }
}

// MARK: - Custom Methods

extension OnboardingVC {
    private func presentLoginVC() {
        UserDefaults.standard.set("No", forKey: UserDefaults.Keys.isFirstAccess)
        
        guard let ad = UIApplication.shared.delegate as? AppDelegate else { return }
        ad.window?.rootViewController = LoginNC()
    }
}
