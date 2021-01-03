//
//  MyProfileItem.swift
//  PostPro//  Created by Aleksander Wędrychowski on 25/01/2019.
//  Copyright © 2019 KISS DIGITAL SP Z O O. All rights reserved.
import UIKit

protocol MyProfileItemViewDelegate: final class {
    func myProfileItemViewDidTap(_ sender: MyProfileItemView)
    func myProfileItemViewDidTap(verify button: UIButton, sender: MyProfileItemView)
}

final class MyProfileItemView: UIView {
    
    static let height: CGFloat = 95
    
    enum Item {
        case instagram
        case notifications
    }
    
    // MARK: - Properties
    private(set) var contentView: UIView!
    private(set) var imageViewBackgroundView: UIView!
    private(set) var imageView: UIImageView!
    private(set) var imageViewContainer: UIView!
    private(set) var descriptionLabel: UILabel!
    private(set) var switchView: UISwitch!
    private(set) var verifyButton: UIButton!
    
    weak var delegage: MyProfileItemViewDelegate?
    private(set) var item: Item!
    
    required convenience init(presenting item: Item) {
        self.init()
        self.item = item
        self.adjust()
    }
    
    private init() {
        super.init(frame: .zero)
        setupView()
        setupInteractions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let builder = MyProfileItemViewBuilder(with: self)
        self.contentView = builder.buildContentView()
        self.imageViewBackgroundView = builder.buildImageViewBackground()
        self.imageView = builder.buildImageView()
        self.imageViewContainer = builder.buildImageViewContainer()
        self.descriptionLabel = builder.buildDescriptionLabel()
        self.switchView = builder.buildSwitch()
        self.verifyButton = builder.buildVerifyButton()
        builder.setupViews()
    }
    
    private func setupInteractions() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContentView(_:)))
        contentView.addGestureRecognizer(gestureRecognizer)
        
        verifyButton.addTarget(self, action: #selector(didTapVerifyButton), for: .touchUpInside)
    }
    
    private func adjust() {
        switch item {
        case .some(.instagram):
            imageView.image = UIImage.instagramIcon
            descriptionLabel.text = Strings.MyProfile.linkInstagram.localized
        case .some(.notifications):
            imageView.image = UIImage.notificationIcon
            descriptionLabel.text = Strings.MyProfile.notifications.localized
            verifyButton.isHidden = true
            switchView.isHidden = false
        default:
            break
        }
    }
    
    private func configureToInstagram(using model: Social) {
        self.descriptionLabel.text = Strings.MyProfile.linkInstagram.localized
        
        if let instagramUsername = model.username {
            self.descriptionLabel.text = "@" + instagramUsername
            verifyButton.isHidden = model.verified == true
        }

    }
}

// MARK: - Actions
extension MyProfileItemView {
    
    @objc private func didTapContentView(_ sender: UITapGestureRecognizer) {
        delegage?.myProfileItemViewDidTap(self)
    }
    
    @objc private func didTapVerifyButton(_ sender: UIButton) {
        delegage?.myProfileItemViewDidTap(verify: sender, sender: self)
    }
    
}

// MARK: - Endpoints
extension MyProfileItemView {
    
    func configure(with model: Social) {
        
        switch model.type {
        case .instagram:
            configureToInstagram(using: model)
        default: break
        }
    }
    
    func configure(withNotifications flag: Bool) {
        self.switchView.setOn(flag, animated: self.window != nil)
    }
}
