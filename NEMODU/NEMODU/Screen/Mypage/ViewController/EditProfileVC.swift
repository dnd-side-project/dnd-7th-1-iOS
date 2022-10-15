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
    
    private let nicknameTitleLabel = UILabel()
        .then {
            $0.text = "닉네임 변경"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let nicknameCheckView = NicknameCheckView()
        .then {
            $0.nicknameTextField.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
        }
    
    private var imagePicker = UIImagePickerController()
    private let viewModel = UserInfoSettingVM()
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
        bindProfileImageBtn()
        checkNicknameValidation()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindValidationView()
    }
    
}

// MARK: - Configure

extension EditProfileVC {
    private func configureNaviBar() {
        naviBar.naviType = .push
        naviBar.configureNaviBar(targetVC: self,
                                 title: "프로필 수정")
        naviBar.configureBackBtn(targetVC: self)
        naviBar.configureRightBarBtn(targetVC: self,
                                     title: "저장",
                                     titleColor: .main)
    }
    
    private func configureContentView() {
        view.addSubviews([profileImageBtn,
                          nicknameTitleLabel,
                          nicknameCheckView])
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
        
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageBtn.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        
        nicknameCheckView.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(64)
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
    private func bindProfileImageBtn() {
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
    
    /// 닉네임 유효성 검사를 요청하는 메서드
    private func checkNicknameValidation() {
        nicknameCheckView.nicknameCheckBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = self.nicknameCheckView.nicknameTextField.text
                else { return }
                nickname.count < 2 || nickname.count > 6
                ? self.nicknameCheckView.setValidationView(.countError)
                : self.viewModel.getNicknameValidation(nickname: nickname)
            })
            .disposed(by: bag)
    }
}

// MARK: - Output

extension EditProfileVC {
    /// 사용 가능한 닉네임인지 판단 후 상태에 따라 view를 구성하는 메서드
    private func bindValidationView() {
        viewModel.output.isValidNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.nicknameCheckView.setValidationView(isValid ? .available : .notAvailable)
            })
            .disposed(by: bag)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

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
