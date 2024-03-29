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
    
    private let baseScrollView = UIScrollView()
        .then {
            $0.showsVerticalScrollIndicator = false
        }
    
    private let contentView = UIView()
    
    private let profileImageBtn = UIButton()
        .then {
            $0.setImage(.defaultThumbnail, for: .normal)
            $0.imageView?.layer.cornerRadius = 48
            $0.imageView?.contentMode = .scaleAspectFill
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
    
    private let profileMessageTitleLabel = UILabel()
        .then {
            $0.text = "나의 소개글"
            $0.font = .body1
            $0.textColor = .gray900
        }
    
    private let profileMessageTextView = NemoduTextView()
        .then {
            $0.tv.placeholder = "나의 소개글을 작성해주세요"
        }
    
    private var imagePicker = UIImagePickerController()
    private let viewModel = UserInfoSettingVM()
    private var isBasic = false
    weak var delegate: ProfileChanged?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInteractivePopGesture(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getMyProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setInteractivePopGesture(true)
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
        bindSaveBtn()
        bindBackBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        bindAPIErrorAlert(viewModel)
        bindProfileData()
        bindValidationView()
        bindBaseScrollView()
        bindDismiss()
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
        view.addSubview(baseScrollView)
        baseScrollView.addSubview(contentView)
        contentView.addSubviews([profileImageBtn,
                                 nicknameTitleLabel,
                                 nicknameCheckView,
                                 profileMessageTitleLabel,
                                 profileMessageTextView])
        profileImageBtn.addSubview(cameraIconImageView)
        
        imagePicker.delegate = self
    }
    
    private func configureProfileData(_ data: MyProfileResponseModel) {
        profileImageBtn.kf.setImage(with: data.picturePathURL,
                                    for: .normal,
                                    placeholder: .defaultThumbnail)
        profileMessageTextView.tv.text = data.intro
    }
}

// MARK: - Layout

extension EditProfileVC {
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
        }
        
        profileImageBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
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
        
        profileMessageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameCheckView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        
        profileMessageTextView.snp.makeConstraints {
            $0.top.equalTo(profileMessageTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(121)
        }
    }
}

// MARK: - Custom Methods

extension EditProfileVC {
    private func setRightBarBtnActive(_ isActive: Bool) {
        naviBar.rightBtn.isUserInteractionEnabled = isActive
        naviBar.rightBtn.setTitleColor(isActive ? .main : .gray300, for: .normal)
    }
    
    private func setDefaultProfile() {
        profileImageBtn.setImage(.defaultThumbnail,
                                 for: .normal)
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
                    self.viewModel.input.isProfileImageChanged.accept(true)
                }
                
                let setDefaultImage =  UIAlertAction(title: "기본 이미지로 변경",
                                                     style: .default) { (action) in
                    self.setDefaultProfile()
                    self.isBasic = true
                    self.viewModel.input.isProfileImageChanged.accept(true)
                }
                
                let cancel = UIAlertAction(title: "취소",
                                           style: .cancel,
                                           handler: nil)
                
                [library, setDefaultImage, cancel].forEach { alert.addAction($0) }
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    /// 닉네임 유효성 검사를 요청하는 메서드
    private func checkNicknameValidation() {
        nicknameCheckView.nicknameCheckBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = self.nicknameCheckView.nicknameTextField.text
                else { return }
                
                if nickname == UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname) {
                    self.nicknameCheckView.setValidationView(.notChanged)
                } else {
                    nickname.count < 2 || nickname.count > 6
                    ? self.nicknameCheckView.setValidationView(.countError)
                    : self.viewModel.getNicknameValidation(nickname: nickname)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 저장 버튼 status & post 바인딩
    private func bindSaveBtn() {
        // 변경된 프로필을 서버에 전송
        naviBar.rightBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                let newNickname = self.nicknameCheckView.nicknameTextField.text,
                let profileImage = self.profileImageBtn.currentImage
                else { return }
                self.viewModel.postEditProfile(
                    EditProfileRequestModel(picture: profileImage,
                                            editNickname: newNickname,
                                            intro: self.profileMessageTextView.tv.text,
                                            isBasic: self.isBasic))
            })
            .disposed(by: disposeBag)
        
        // 닉네임 확인 상태에 따른 저장 버튼 활성화 상태 및 색상 연결
        viewModel.output.isNextBtnActive
            .asDriver()
            .drive(onNext: { [weak self] isNicknameChecked in
                guard let self = self else { return }
                self.setRightBarBtnActive(isNicknameChecked)
            })
            .disposed(by: disposeBag)
        
        // 닉네임 변경 시, 버튼 비활성화
        nicknameCheckView.nicknameTextField.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] newNickname in
                guard let self = self,
                      let defaultNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
                else { return }
                self.viewModel.output.isNextBtnActive.accept(defaultNickname == newNickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBackBtn() {
        // 기존 뒤로가기 pop 액션 remove
        naviBar.backBtn.removeTarget(self,
                                     action: #selector(self.popVC),
                                     for: .touchUpInside)
        // 값 상태에 따라 binding
        naviBar.backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let nickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
                else { return }
                let isProfileImageChanged = self.viewModel.input.isProfileImageChanged.value
                let isNicknameChanged = nickname != self.nicknameCheckView.nicknameTextField.text
                let isProfileMessageChanged = self.viewModel.input.isProfileMessageChanged.value
                
                if isProfileImageChanged || isNicknameChanged || isProfileMessageChanged {
                    self.popUpAlert(alertType: .discardChanges,
                                    targetVC: self,
                                    highlightBtnAction: #selector(self.dismissAlertAndPopVC),
                                    normalBtnAction: #selector(self.dismissAlert))
                } else {
                    self.popVC()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Output

extension EditProfileVC {
    private func bindProfileData() {
        viewModel.output.myProfile
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.configureProfileData(data)
            })
            .disposed(by: disposeBag)
    }
    
    /// 사용 가능한 닉네임인지 판단 후 상태에 따라 view를 구성하는 메서드
    private func bindValidationView() {
        viewModel.output.isValidNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                self.nicknameCheckView.setValidationView(isValid ? .available : .notAvailable)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBaseScrollView() {
        profileMessageTextView.tv.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.baseScrollView.scrollToBottom(animated: true)
                self.viewModel.input.isProfileMessageChanged.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDismiss() {
        viewModel.output.isProfileSaved
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
                self.delegate?.popupToastView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageBtn.setImage(image, for: .normal)
        } else if let image = info[.originalImage] as? UIImage {
            profileImageBtn.setImage(image, for: .normal)
        }
        isBasic = false
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - ProfileChanged Protocol

protocol ProfileChanged: AnyObject {
    func popupToastView()
}
