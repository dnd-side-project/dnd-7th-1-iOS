//
//  NavigationBar.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import UIKit
import SnapKit
import Then

class NavigationBar: BaseView {
    private var title = UILabel()
        .then {
            $0.font = .title3M
        }
       
    var backBtn = UIButton()
        .then {
            $0.tintColor = .label
        }
    
    var rightBtn = UIButton()
        .then {
            $0.tintColor = .label
        }
    
    var naviType: NaviType! 
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
}

// MARK: - Configure
extension NavigationBar {
    /// naviBar을 view에 추가하고 title을 지정하는 함수
    func configureNaviBar(targetVC: UIViewController, title: String?) {
        targetVC.view.addSubview(self)
        self.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.leading.trailing.equalTo(targetVC.view.safeAreaLayoutGuide)
        }
        
        self.title.text = title
    }
    
    /// naviBar 구성 이후, 인터랙션에 따라 title을 변경하거나 다른 폰트로 커스텀하고싶을 때 사용합니다.
    func setNaviBarTitleText(title: String, font: UIFont) {
        self.title.text = title
        self.title.font = font
    }
    
    /// title의 font를 변경하는 함수입니다.
    func setTitleFont(font: UIFont) {
        self.title.font = font
    }
    
    /// naviBar의 backBtn을 지정하는 함수입니다.
    /// naviType 지정 필수!
    /// push는 왼쪽, present는 오른쪽에 뒤로가기 / 닫기 버튼이 추가되도록 구현하였습니다.
    func configureBackBtn(targetVC: UIViewController) {
        if naviType == .push {
            leftBtnLayout()
            backBtn.setImage(naviType.backBtnImage, for: .normal)
            backBtn.addTarget(targetVC, action: #selector(targetVC.popVC), for: .touchUpInside)
        } else {
            rightBtnLayout()
            rightBtn.setImage(naviType.backBtnImage, for: .normal)
            rightBtn.addTarget(targetVC, action: #selector(targetVC.dismissVC), for: .touchUpInside)
        }
    }
    
    /// naviBar의 우측 버튼(이미지)을 추가하는 함수입니다.
    func configureRightBarBtn(targetVC: UIViewController, image: UIImage) {
        rightBtnLayout()
        rightBtn.setImage(image, for: .normal)
    }
    
    /// naviBar의 우측 버튼(글자)을 추가하는 함수입니다.
    func configureRightBarBtn(targetVC: UIViewController, title: String, titleColor: UIColor?) {
        rightBtnLayout()
        rightBtn.setTitle(title, for: .normal)
        rightBtn.setTitleColor(titleColor ?? .label, for: .normal)
        rightBtn.titleLabel?.font = .title3SB
    }
}


// MARK: - Layout
extension NavigationBar {
    private func configureLayout() {
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func rightBtnLayout() {
        self.addSubview(rightBtn)
        rightBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func leftBtnLayout() {
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.width.equalTo(26)
        }
    }
}
