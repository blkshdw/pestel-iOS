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
import CoreLocation

class ProfileManager {
  static let instance = ProfileManager()

  var currentProfile: User? = nil {
    didSet {
      let currentProfileJSON = currentProfile?.toJSONString()
      try? StorageHelper.save(currentProfileJSON, forKey: .currentProfile)
    }
  }

  var currentCoordinate: CLLocationCoordinate2D? = nil {
    didSet {
      try? StorageHelper.save(currentCoordinate?.latitude, forKey: .currentLatitude)
      try? StorageHelper.save(currentCoordinate?.latitude, forKey: .currentLongitude)
    }
  }

  var isAuthorized: Bool {
    let apiToken: String? = StorageHelper.loadObjectForKey(.apiToken)
    return apiToken != nil
  }

  func updateProfile(_ closure: (User) -> Void) {
    let profile = currentProfile ?? User()
    closure(profile)
    self.currentProfile = profile
    return
  }

  func signOut() {
    try? StorageHelper.save(nil, forKey: .apiToken)
    currentProfile = nil
  }

  private init() {
    if let profileJSON: String = StorageHelper.loadObjectForKey(.currentProfile) {
      currentProfile =  Mapper<User>().map(JSONString: profileJSON)
    }
    if let latitude: Double = StorageHelper.loadObjectForKey(.currentLatitude),
      let longitude: Double = StorageHelper.loadObjectForKey(.currentLongitude) {
      currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
  }
}
