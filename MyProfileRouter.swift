//
//  MyProfileRouter.swift
//  PostPro//  Created by Aleksander Wędrychowski on 25/01/2019.

import Foundation
import UIKit

protocol MyProfileRoutingLogic {
    func navigate(to destination: MyProfileRouter.Destination)
}

final class MyProfileRouter: MyProfileRoutingLogic {
    weak var viewController: MyProfileViewController?
    
    init(controller: MyProfileViewController) {
        self.viewController = controller
    }
    
    enum Destination {
        case edit
        case link(Social.SocialType)
        case verificationFailure(AppError)
    }
    
    func navigate(to destination: MyProfileRouter.Destination) {
        switch destination {
        case .edit: routeToEdit()
        case .link(let socialType): routeToLinkSocial(of: socialType)
        case .verificationFailure(let error): routeToVerificationInfo(with: error)
        }
    }
}

private extension MyProfileRouter {
    
    func routeToEdit() {
        let editVC = EditMyProfileViewController()
        viewController?.show(editVC, sender: nil)
    }
    
    func routeToLinkSocial(of type: Social.SocialType) {
        let provideAccountLinkVC = ProvideUsernameViewController(for: type)
        viewController?.show(provideAccountLinkVC, sender: nil)
    }
    
    func routeToVerificationInfo(with error: AppError) {
        let initData = VerificationInfoViewController.InitData(error: error, customTitle: nil, social: appUser?.instagram)
        let verificationInfoVC = VerificationInfoViewController(with: initData)
        viewController?.show(verificationInfoVC, sender: nil)
    }
}
