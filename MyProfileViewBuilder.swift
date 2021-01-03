//
//  MyProfileViewBuilder.swift
//  PostPro//  Created by Aleksander Wędrychowski on 25/01/2019.

import UIKit

final class MyProfileViewBuilder {
	
	private unowned let controller: MyProfileViewController
    private var view: UIView! { return controller.view }
    
	init(controller: MyProfileViewController) {
        self.controller = controller
	}

	func buildView() -> UIView {
		let view = UIView()
        view.backgroundColor = .appBackground
		return view
	}
    
    func setupViews() {
        setupProperties()
        setupHierarchy()
        setupAutoLayout()
    }
    
    private func setupProperties() {
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconClose"))
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconEdit"))
        controller.navigationItem.title = Strings.MyProfile.myProfile.localized
    }

    private func setupHierarchy() {
        view.addSubview(controller.scrollView)
        controller.scrollView.addSubview(controller.scrollContentView)
        controller.scrollContentView.addSubview(controller.stackView)
        view.addSubview(controller.logoutButton)
        controller.stackView.addArrangedSubviews([
            controller.headerView,
            controller.instagramItemView,
            controller.notificationsItemView
            ])
    }
    
	private func setupAutoLayout() {
        
        // scroll view
        controller.scrollView.topAnchor.equal(to: view.topAnchor)
        controller.scrollView.leftAnchor.equal(to: view.leftAnchor)
        controller.scrollView.rightAnchor.equal(to: view.rightAnchor)
        controller.scrollView.bottomAnchor.equal(to: view.bottomAnchor)
        
        // scroll content view
        controller.scrollContentView.edges(equalTo: controller.scrollView)
        controller.scrollContentView.widthAnchor.equal(to: view.widthAnchor)
        
        // image view
        controller.avatarImageView.heightAnchor.equalTo(constant: Constants.MyProfile.avatarImageViewHeight)
        controller.avatarImageView.widthAnchor.equal(to: controller.avatarImageView.heightAnchor)
        
        // stackView
        controller.stackView.edges(equalTo: controller.scrollContentView)
        
        // header
        controller.headerView.heightAnchor.equalTo(constant: Constants.MyPosts.headerViewHeight)
        
        // instagram item
        controller.instagramItemView.heightAnchor.equalTo(constant: MyProfileItemView.height)
        
        // notifications item
        controller.notificationsItemView.heightAnchor.equalTo(constant: MyProfileItemView.height)
        
        // logoutButton
        controller.logoutButton.heightAnchor.equalTo(constant: Constants.MyProfile.logoutButtonHeight)
        controller.logoutButton.widthAnchor.constraint(equalTo: controller.logoutButton.heightAnchor, multiplier: 2).activate()
        controller.logoutButton.centerXAnchor.equal(to: view.centerXAnchor)
        controller.logoutButton.bottomAnchor.equal(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Margin.standard)
	}

}

extension MyProfileViewBuilder {
    
    func buildHeaderView() -> AppBlurredHeaderView {
        let view = AppBlurredHeaderView(withContent: controller.avatarImageView)
        view.blurEffectRadius = Constants.blurOnRadius
        return view
    }
    
    func buildAvatarImageView() -> UIImageView {
        let view = UIImageView().manualLayoutable()
        view.contentMode = .scaleAspectFill
        view.roundCorners(with: Constants.MyProfile.avatarImageViewHeight/2)
        
        return view
    }
    
    func buildScrollView() -> UIScrollView {
        let view = UIScrollView().manualLayoutable()
        view.alwaysBounceVertical = true
        view.bounces = true
        return view
    }
    
    func buildStackView() -> UIStackView {
        let view = UIStackView().manualLayoutable()
        view.spacing = Constants.MyProfile.stackViewSpacing
        view.axis = .vertical
        return view
    }
    
    func buildItemView(ofType item: MyProfileItemView.Item) -> MyProfileItemView {
        let view = MyProfileItemView(presenting: item)
        return view
    }
    
    func buildLogoutButton() -> UIButton {
        let view = UIButton().manualLayoutable()
        view.titleLabel?.font = UIFont.app(ofSize: Constants.FontSize.tiny, weight: .semibold)
        view.setTitle(Strings.logout.localized, for: .normal)
        view.setTitleColor(UIColor.gray.withAlphaComponent(0.5), for: .normal)
        view.applyTouchAnimation()
        return view
    }
    
}
