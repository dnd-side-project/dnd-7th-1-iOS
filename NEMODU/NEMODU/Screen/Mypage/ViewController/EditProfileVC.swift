//
//  EditProfileVC.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/10/15.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Photos

class EditProfileVC: BaseViewController {
    private let naviBar = NavigationBar()
    
    private let profileImageBtn = UIButton()
        .then {
            $0.setImage(UIImage(named: "defaultThumbnail"), for: .normal)
            $0.imageView?.layer.cornerRadius = 48
        }
    
    private let cameraIconImageView = UIImageView()
        .then {
            $0.image = UIImage(named: "Camera")
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .systemBackground
        }
    
    private var imagePicker = UIImagePickerController()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        super.configureView()
        configureNaviBar()
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
    }
    
}

// MARK: - Configure

extension EditProfileVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "프로필 수정")
        naviBar.configureBackBtn(targetVC: self)
    }
    
    private func configureContentView() {
        view.addSubviews([profileImageBtn])
        profileImageBtn.addSubview(cameraIconImageView)
        
        imagePicker.delegate = self
    }
}

// MARK: - Layout

extension EditProfileVC {
    private func configureLayout() {
        profileImageBtn.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(40)
            $0.width.height.equalTo(96)
            $0.centerX.equalToSuperview()
        }
        
        cameraIconImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.height.equalTo(28)
        }
    }
}

// MARK: - Custom Methods

extension EditProfileVC {
    private func setDefaultProfile() {
        profileImageBtn.setImage(UIImage(named: "defaultThumbnail"), for: .normal)
    }
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func checkGalleryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.checkGalleryAuthorization()
                }
            }
        default:
            let accessConfirmVC = UIAlertController(title: "권한 필요",
                                                    message: "갤러리 접근 권한이 없습니다. 설정 화면에서 설정해주세요.",
                                                    preferredStyle: .alert)
            let goSettings = UIAlertAction(title: "설정", style: .default) { (action) in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            let cancel = UIAlertAction(title: "취소",
                                       style: .cancel,
                                       handler: nil)
            accessConfirmVC.addAction(goSettings)
            accessConfirmVC.addAction(cancel)
            present(accessConfirmVC, animated: true)
        }
    }
}

// MARK: - Input

extension EditProfileVC {
    private func bindBtn() {
        profileImageBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                let alert =  UIAlertController(title: "프로필 사진 설정",
                                               message: nil,
                                               preferredStyle: .actionSheet)
                
                let library =  UIAlertAction(title: "앨범에서 사진 선택",
                                             style: .default) {
                    (action) in self.checkGalleryAuthorization()
                }
                
                let setDefaultImage =  UIAlertAction(title: "기본 이미지로 변경",
                                                     style: .default) { (action) in
                    self.setDefaultProfile()
                }
                
                let cancel = UIAlertAction(title: "취소",
                                           style: .cancel,
                                           handler: nil)
                
                [library, setDefaultImage, cancel].forEach { alert.addAction($0) }
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension EditProfileVC {
    
}

// MARK: -

extension EditProfileVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageBtn.setImage(image, for: .normal)
        } else if let image = info[.originalImage] as? UIImage {
            profileImageBtn.setImage(image, for: .normal)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
