//
//  MyProfileItemViewBuilder.swift
//  PostPro//  Created by Aleksander Wędrychowski on 26/01/2019.
//  Copyright © 2019 KISS DIGITAL SP Z O O. All rights reserved.
import UIKit

final class MyProfileItemViewBuilder {
    
    unowned let view: MyProfileItemView
    
    init(with view: MyProfileItemView) {
        self.view = view
    }
    
    func setupViews() {
        setupProperties()
        setupHierarchy()
        setupAutolayout()
    }
    
    private func setupProperties() {
        view.backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        [
            view.imageViewBackgroundView,
            view.imageViewContainer,
            view.descriptionLabel,
            view.switchView,
            view.verifyButton
        ].addTo(parent: view.contentView)
        view.addSubview(view.contentView)
        view.imageViewContainer.addSubview(view.imageView)
    }
    
    private func setupAutolayout() {
        [view.imageView, view.imageViewContainer, view.descriptionLabel, view.switchView].forEach { subview in
            subview?.centerYAnchor.equal(to: view.centerYAnchor)
        }
        
        guard let contentView = view.contentView else { return }
        
        view.contentView.leftAnchor.equal(to: view.leftAnchor, constant: Constants.MyPosts.cellInternalMarginLeft)
        view.contentView.rightAnchor.equal(to: view.rightAnchor, constant: Constants.MyPosts.cellInternalMarginRight)
        view.contentView.topAnchor.equal(to: view.topAnchor)
        view.contentView.bottomAnchor.equal(to: view.bottomAnchor)
        
        view.imageView.centerXAnchor.equal(to: view.imageViewContainer.centerXAnchor)
        view.imageView.heightAnchor.equalTo(constant: Constants.MyProfile.itemImageViewHeight)
        view.imageView.widthAnchor.equal(to: view.imageView.heightAnchor)
        
        view.imageViewBackgroundView.leftAnchor.equal(to: contentView.leftAnchor)
        view.imageViewBackgroundView.topAnchor.equal(to: contentView.topAnchor)
        view.imageViewBackgroundView.bottomAnchor.equal(to: contentView.bottomAnchor)
        view.imageViewBackgroundView.widthAnchor.equal(to: view.imageViewBackgroundView.heightAnchor)
        
        // ImageView container
        view.imageViewContainer.heightAnchor.equalTo(constant: Constants.cellImageViewSideLenght)
        view.imageViewContainer.widthAnchor.equal(to: view.imageViewContainer.heightAnchor)
        view.imageViewContainer.leftAnchor.equal(to: contentView.leftAnchor, constant: Constants.MyProfile.itemImageViewLeftMargin)
        
        view.descriptionLabel.leftAnchor.equal(to: view.imageViewBackgroundView.rightAnchor, constant: Constants.Margin.standard)
        view.descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: view.contentView.rightAnchor, constant: -10).activate()
        
        view.switchView.rightAnchor.equal(to: contentView.rightAnchor, constant: -Constants.Margin.small)
        
        view.verifyButton.leftAnchor.equal(to: view.descriptionLabel.leftAnchor)
        view.verifyButton.titleLabel?.leftAnchor.equal(to: view.descriptionLabel.leftAnchor)
        view.verifyButton.topAnchor.equal(to: view.descriptionLabel.lastBaselineAnchor, constant: Constants.Margin.small)
        view.verifyButton.heightAnchor.equalTo(constant: Constants.MyProfile.itemVerifyButtonHeight)
        view.verifyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).activate()
        
    }
    
}

extension MyProfileItemViewBuilder {
    
    func buildContentView() -> UIView {
        let view = UIView().manualLayoutable()
        view.backgroundColor = .white
        view.roundCorners()
        view.addShadow(radius: 3)
        view.applyTouchAnimation()
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.appDarkGray.withAlphaComponent(0.5).cgColor
        return view
    }
    
    func buildImageView() -> UIImageView {
        let imageView = UIImageView().manualLayoutable()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func buildImageViewBackground() -> UIView {
        let view = UIView().manualLayoutable()
        view.backgroundColor = UIColor.appBackgroundLight
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }
    
    func buildImageViewContainer() -> UIView {
        let view = UIView().manualLayoutable()
        view.backgroundColor = .appPurple
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3
        view.addShadow(withOpacity: 0.5, radius: 0.3)
        view.roundCorners(with: Constants.cellImageViewSideLenght/2)
        return view
    }
    
    func buildDescriptionLabel() -> UILabel {
        let label = UILabel().manualLayoutable()
        label.numberOfLines = 1
        label.textColor = .appDarkText
        label.font = UIFont.app(ofSize: Constants.FontSize.big, weight: .semibold)
        
        return label
    }
    
    func buildSwitch() -> UISwitch {
        let switchView = UISwitch().manualLayoutable()
        switchView.isUserInteractionEnabled = false
        switchView.isHidden = true
        switchView.setContentCompressionResistancePriority(.required, for: .horizontal)
        switchView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        return switchView
    }
    
    func buildVerifyButton() -> UIButton {
        let button = UIButton().manualLayoutable()
        button.setTitle(Strings.MyProfile.verify.localized, for: .normal)
        button.setTitleColor(.appPurple, for: .normal)
        button.applyTouchAnimation()
        button.isHidden = true
        button.titleLabel?.font = UIFont.app(ofSize: Constants.FontSize.tiny, weight: .bold)
        button.titleEdgeInsets.top = -10
        return button
    }
    
}
