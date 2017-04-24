//
//  ProfileManager.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class ProfileManager {
  static let instance = ProfileManager()

  var currentProfile: User? = nil {
    didSet {
      let currentProfileJSON = currentProfile?.toJSONString()
      try? StorageHelper.save(currentProfileJSON, forKey: .currentProfile)
    }
  }

  var isAuthorized: Bool {
    let apiToken: String? = StorageHelper.loadObjectForKey(.apiToken)
    return apiToken != nil
  }

  func updateProfile(_ closure: (User) -> Void) -> Promise<Void> {
    let profile = currentProfile ?? User()
    closure(profile)
    //return DataManager.instance.updateUser(profile: profile).then {
      //try? StorageHelper.save(profile.toJSONString(), forKey: .currentProfile)
    //}
    return Promise(value: ())
  }

  func signOut() {
    try? StorageHelper.save(nil, forKey: .apiToken)
    currentProfile = nil
  }

  private init() {
    if let profileJSON: String = StorageHelper.loadObjectForKey(.currentProfile) {
      currentProfile =  Mapper<User>().map(JSONString: profileJSON)
    }
  }
}
