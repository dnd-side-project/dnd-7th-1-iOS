//
//  ProfileImageVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/15.
//

import UIKit
import SnapKit
import Then

class ProfileImageVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    var profileImage = UIImageView()
    
    private var initialTouchPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureLayout()
        setDismissGesture()
    }
}

// MARK: - Configure

extension ProfileImageVC {
    private func configureNaviBar() {
        naviBar.naviType = .present
        naviBar.configureNaviBar(targetVC: self,
                                 title: "")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureLayout() {
        view.addSubview(profileImage)
        
        profileImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(profileImage.snp.width)
        }
    }
    
    private func setDismissGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        default:
            break
        }
    }
}
