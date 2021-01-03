//
//  MyProfileViewModel.swift
//  PostPro//  Created by Aleksander Wędrychowski on 25/01/2019.

import Foundation

protocol MyProfileLogic {
    func verify(_ socialType: Social.SocialType, success: @escaping Function, failure: @escaping FailureResponse)
    func uploadUserProfile()
}

final class MyProfileViewModel {
    
    private lazy var repository = UserRepository()
}

// MARK: Private logic
private extension MyProfileViewModel {

}

// MARK: Interface logic methods

extension MyProfileViewModel: MyProfileLogic {
    
    func uploadUserProfile() {
        repository.uploadUserProfile()
    }
    
    func verify(_ socialType: Social.SocialType, success: @escaping Function, failure: @escaping FailureResponse) {
        let model = MyProfile.VerifySocial.Request.init(type: socialType)
        repository.verify(using: model, success: success, failure: failure)
    }
}
