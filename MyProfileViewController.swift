//
//  MyProfileViewController.swift
//  PostPro//  Created by Aleksander Wędrychowski on 25/01/2019.

import UIKit
import RxCocoa
import RxSwift

final class MyProfileViewController: AppViewController {

    // MARK: - Properties

    private var viewModel: MyProfileLogic!
    private var router: MyProfileRoutingLogic!

    private(set) var headerView: AppBlurredHeaderView!
    private(set) var avatarImageView: UIImageView!
    private(set) var scrollView: UIScrollView!
    private(set) var scrollContentView: UIView!
    private(set) var stackView: UIStackView!
    private(set) var instagramItemView: MyProfileItemView!
    private(set) var notificationsItemView: MyProfileItemView!
    private(set) var logoutButton: UIButton!
    
    // MARK: - Initialization 

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
    	self.viewModel = MyProfileViewModel()
    	self.router = MyProfileRouter(controller: self)
        self.hidesBottomBarWhenPushed = true
    }

    // MARK: - Lifecycle 

    override func loadView() {
        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresentationLogic()
    }

}

// MARK: - Private methods
extension MyProfileViewController {

    private func setupViews() {
        let builder = MyProfileViewBuilder(controller: self)
        self.view = builder.buildView()
        self.avatarImageView = builder.buildAvatarImageView()
        self.headerView = builder.buildHeaderView()
        self.scrollView = builder.buildScrollView()
        self.scrollContentView = builder.buildView()
        self.stackView = builder.buildStackView()
        self.instagramItemView = builder.buildItemView(ofType: .instagram)
        self.notificationsItemView = builder.buildItemView(ofType: .notifications)
        self.logoutButton = builder.buildLogoutButton()
        builder.setupViews()
    }

    private func setupPresentationLogic() {
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(didTapDismiss(_:))
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(didTapEdit(_:))
        self.logoutButton.addTarget(self, action: #selector(didTapLogout(_:)), for: .touchUpInside)
        
        bindAvatar()
        bindSocials()
        bindNotifications()
    }
    
    private func bindAvatar() {
        appUser?.avatarRelay.bind { [weak self] avatar in
            let image = avatar ?? UIImage.instagramIcon
            self?.avatarImageView.image = image
            self?.headerView.setBackgroundImage(image)
        }.disposed(by: disposeBag)
    }
    
    private func bindSocials() {
        appUser?.socialsRelay.bind { [weak self] socials in
            if let instagramSocial = socials.first(where: { $0.type == .instagram }) {
                self?.instagramItemView.configure(with: instagramSocial)
            }
        }.disposed(by: disposeBag)
        
        instagramItemView.delegage = self
    }
    
    private func bindNotifications() {
        appUser?.areNotificationsOnRelay.bind { [weak self] flag in
            self?.notificationsItemView.configure(withNotifications: flag)
        }.disposed(by: disposeBag)
        
        notificationsItemView.delegage = self
    }

}

// MARK: - Verification
extension MyProfileViewController {
    
    private func verify(_ socialType: Social.SocialType) {
        showLoader()
        viewModel.verify(socialType, success: verifySuccess, failure: verifyFailure(_:))
    }
    
    private func verifySuccess() {
        showAlert(title: Strings.MyProfile.verificationSuccess.localized)
    }
    
    private func verifyFailure(_ error: AppError) {
        hideLoader()
        router.navigate(to: .verificationFailure(error))
    }
    
}

// MARK: - Actions
extension MyProfileViewController {
    
    @objc private func didTapDismiss(_ item: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEdit(_ item: UIBarButtonItem) {
        router.navigate(to: .edit)
    }
    
    @objc private func didTapLogout(_ button: UIButton) {
        appUser?.logout()
    }
    
    @objc private func didTapNotificationsItem(_ sender: MyProfileItemView) {
        guard let appUser = appUser else { return }
        appUser.areNotificationsOnRelay.accept(!appUser.areNotificationsOn)
        viewModel.uploadUserProfile()
    }
    
    private func didTapInstagramItem(_ sender: MyProfileItemView) {
        router.navigate(to: .link(.instagram))
    }
    
}

// MARK: - MyProfileItemViewDelegate
extension MyProfileViewController: MyProfileItemViewDelegate {
    
    func myProfileItemViewDidTap(_ sender: MyProfileItemView) {
        switch sender.item {
        case .some(.instagram):
            didTapInstagramItem(sender)
        case .some(.notifications):
            didTapNotificationsItem(sender)
        default: break
        }
    }
    
    func myProfileItemViewDidTap(verify button: UIButton, sender: MyProfileItemView) {
        switch sender.item {
        case .some(.instagram):
            verify(.instagram)
        default: break
        }
    }
}
