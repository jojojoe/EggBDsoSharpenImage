//
//  BDsoEffectContentVC.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/10.
//

import UIKit
import TLPhotoPicker
import Photos
import PhotosUI


class BDsoEffectContentVC: UIViewController {
    let bgCoverImgV = UIImageView()
    let contentBgV = UIView()
    var layoutSubsViewOnce = Once()
    let canvasBgV = UIView()
    var featureTitleLabel = UILabel()
    var featureInfoDesLabel = UILabel()
    var effectPreview: BDsoEffectPreview!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCon()
        updateCurrentEffectStatus()
    }
    
    func updateCurrentEffectStatus() {
        featureTitleLabel.text(BDsoToManager.default.currentSelectItem.featureName)
        featureInfoDesLabel.text(BDsoToManager.default.currentSelectItem.descriName)
        bgCoverImgV.image(BDsoToManager.default.currentSelectItem.preImage1Str)
    }
    
    func setupCon() {
        view.backgroundColor(.white)
            .clipsToBounds()
        bgCoverImgV
            .adhere(toSuperview: view) {
                $0.edges.equalToSuperview()
            }
            .contentMode(.scaleAspectFill)
        //
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.adhere(toSuperview: view) {
            $0.edges.equalToSuperview()
        }
        
        //
        let backBtn = UIButton()
            .adhere(toSuperview: view) {
                $0.left.equalToSuperview().offset(20)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
            .image(UIImage(named: "backbtn_ich"))
            .target(target: self, action: #selector(backBtnClick), event: .touchUpInside)
        
        //
        contentBgV.adhere(toSuperview: view) {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(80)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160)
        }
        //
        
        featureTitleLabel
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(backBtn.snp.bottom).offset(0)
                $0.width.height.greaterThanOrEqualTo(30)
            }
            .color(UIColor(hexString: "#22214B")!)
            .font(UIFont.FontName_PoppinsBold, 20)
        
        featureInfoDesLabel
            .adhere(toSuperview: view) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(featureTitleLabel.snp.bottom).offset(4)
                $0.width.height.greaterThanOrEqualTo(21)
            }
            .color(UIColor(hexString: "#22214B")!.withAlphaComponent(0.6))
            .font(UIFont.FontName_PoppinsRegular, 14)
        
        //
        let selelPhotoAlbumBtn = BDsoEffectBottomBtn(frame: .zero, iconStr: "sel_iconphoto", nameStr: "From Library")
        selelPhotoAlbumBtn
            .adhere(toSuperview: view) {
                $0.right.equalTo(view.snp.centerX).offset(-10)
                $0.top.equalTo(contentBgV.snp.bottom).offset(24)
                $0.left.equalToSuperview().offset(30)
                $0.height.equalTo(120)
            }
            .target(target: self, action: #selector(selelPhotoAlbumClick), event: .touchUpInside)
        
        let selelCameraBtn = BDsoEffectBottomBtn(frame: .zero, iconStr: "sel_iconcamera", nameStr: "Scan Photo")
        selelCameraBtn
            .adhere(toSuperview: view) {
                $0.left.equalTo(view.snp.centerX).offset(10)
                $0.top.equalTo(contentBgV.snp.bottom).offset(24)
                $0.right.equalToSuperview().offset(-30)
                $0.height.equalTo(120)
            }
            .target(target: self, action: #selector(selelCameraClick), event: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentBgV.bounds.size.width == UIScreen.main.bounds.size.width {
            layoutSubsViewOnce.run {
                self.stupCanvasV()
            }
        }
    }
    
    func stupCanvasV() {
        //
        var canvasVW: CGFloat = contentBgV.bounds.size.width
        var canvasVH: CGFloat = contentBgV.bounds.size.height
        let targetSizeW: CGFloat = 330.0
        let targetSizeH: CGFloat = 440.0
        
        if targetSizeW / targetSizeH > canvasVW / canvasVH {
            canvasVH = canvasVW * (targetSizeH/targetSizeW)
        } else {
            canvasVW = canvasVH * (targetSizeW/targetSizeH)
        }
        contentBgV.addSubview(canvasBgV)
        canvasBgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(canvasVW)
            $0.height.equalTo(canvasVH)
        }
        
        effectPreview = BDsoEffectPreview(frame: CGRect(x: 0, y: 0, width: canvasVW, height: canvasVH))
        canvasBgV.addSubview(effectPreview)
        
        
        
    }
    
    @objc func backBtnClick() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selelPhotoAlbumClick() {
        checkAlbumAuthorization()
    }
    
    @objc func selelCameraClick() {
        showCameraIfAuthorized()
    }
    
    func selectUserAlubmImg(img: UIImage) {
        let vc = BDsoBeforePreVC(originImg: img)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BDsoEffectContentVC: TLPhotosPickerViewControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self.showPhotoAlbum()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized || status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.showPhotoAlbum()
                        }
                    }
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showPhotoDeniedAlertV()
                    }
                default: break
                }
            }
        }
    }
    
    func showPhotoDeniedAlertV() {
        let alert = UIAlertController(title: "", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
 
    func showPhotoAlbum() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configure = TLPhotosPickerConfigure()
        configure.cameraBgColor = UIColor(hexString: "#1E1E1E") ?? .black
        configure.cameraIcon = UIImage(named: "whtieCamera")
        configure.numberOfColumn = 4
        configure.singleSelectedMode = true
        configure.allowedLivePhotos = false
        configure.allowedVideoRecording = false
        configure.allowedVideo = false
        viewController.configure = configure
        self.present(viewController, animated: true, completion: nil)
    }
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {

        if let asse = withTLPHAssets.first {
            if let img = asse.fullResolutionImage {
                self.selectUserAlubmImg(img: img)
            }
        }
        return true
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker viewcontroller dismiss completion
    }
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        //Custom Rules & Display
        //You can decide in which case the selection of the cell could be forbidden.
        return true
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        // exceed max selection
    }
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        // handle denied albums permissions case
    }
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        // handle denied camera permissions case
        showCameraAlertDenit()
    }
    
    func showCameraAlertDenit() {
        let alert = UIAlertController(title: "", message: "You have declined access to camera, please active it in Settings>Privacy>Camera.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

extension BDsoEffectContentVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showCameraIfAuthorized() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            self.showCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    if authorized {
                        self?.showCamera()
                    } else {
                        self?.handleDeniedCameraAuthorization()
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorization()
        @unknown default:
            break
        }
    }

    private func showCamera() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        let mediaTypes: [String] = ["public.image"]
        picker.cameraDevice = .rear
        picker.mediaTypes = mediaTypes
        picker.allowsEditing = false
        picker.delegate = self
        
        // if user is on ipad using split view controller, present picker as popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.sourceView = view
            picker.popoverPresentationController?.sourceRect = .zero
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    private func handleDeniedCameraAuthorization() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.showCameraAlertDenit()
            }
        }
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.originalImage] as? UIImage) {
            selectUserAlubmImg(img: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


class BDsoEffectBottomBtn: UIButton {
    var iconStr: String
    var nameStr: String
    
    init(frame: CGRect, iconStr: String, nameStr: String) {
        self.iconStr = iconStr
        self.nameStr = nameStr
        super.init(frame: frame)
        setupV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupV() {
        self.backgroundColor(UIColor.white.withAlphaComponent(0.3))
            .cornerRadius(20)
            .borderColor(UIColor.white.withAlphaComponent(0.3), width: 1)
        let iconImgV = UIImageView()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(self.snp.centerY).offset(-18)
                $0.width.height.equalTo(40)
            }
            .contentMode(.center)
            .image(iconStr)
        let nameL = UILabel()
            .adhere(toSuperview: self) {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(iconImgV.snp.bottom).offset(12)
                $0.width.height.greaterThanOrEqualTo(10)
            }
            .color(UIColor(hexString: "#22214B")!)
            .font(UIFont.FontName_PoppinsMedium, 16)
            .text(nameStr)
    }
}



