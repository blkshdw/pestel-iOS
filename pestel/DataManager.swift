//
//  DataManager.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import PromiseKit
import ObjectMapper

class DataManager {
  static let instance = DataManager()
  var phone: Int? = nil

  var flowers: [Flower] = [] {
    didSet {
      try? StorageHelper.save(flowers.toJSONString(), forKey: .flowers)
    }
  }

  var bouquets: [Bouquet] = [] {
    didSet {
      try? StorageHelper.save(bouquets.toJSONString(), forKey: .bouquets)
    }
  }

  private init() {
    self.flowers = StorageHelper.loadObjectForKey(.flowers) ?? []
    self.bouquets = StorageHelper.loadObjectForKey(.bouquets) ?? []
  }

  func fetchFlowers() -> Promise<[Flower]> {
    return NetworkManager.doRequest(.getFlowers).then { result in
      guard let flowers = Mapper<Flower>().mapArray(JSONObject: result) else { return Promise(error: DataError.unexpectedResponseFormat) }
      self.flowers = flowers
      return Promise(value: flowers)

    }
  }

  func updateUser() -> Promise<Void> {
    return NetworkManager.doRequest(.updateUser).then { result in
      guard let jsonMap = result as? [String: Any] else { throw DataError.unexpectedResponseFormat }
      ProfileManager.instance.updateProfile { profile in
        let map = Map(mappingType: .fromJSON, JSON: jsonMap)
        profile.mapping(map: map)
        profile.isNew = false
      }
      return Promise(value: ())
    }
  }

  func requestAuthCode(phone: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.requestAuthCode(phone: phone)).then { result in
      self.phone = phone
    }
  }

  func confirmCode(code: String) -> Promise<Void> {
    guard let phone = phone else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.confirmAuthCode(phone: phone, code: code)).then { result -> Void in
      guard let jsonMap = result as? [String: Any] else { throw DataError.unexpectedResponseFormat }
      if let userMap = jsonMap["user"] as? [String: Any] {
        let map = Map(mappingType: .fromJSON, JSON: userMap)
        ProfileManager.instance.currentProfile?.mapping(map: map)
      }
      if let token = jsonMap["token"] as? String {
        try? StorageHelper.save(token, forKey: .apiToken)
      }
    }
  }

  func fetchBouquets() -> Promise<[Bouquet]> {
    return NetworkManager.doRequest(.getBouquets).then { result in
      guard let bouquets = Mapper<Bouquet>().mapArray(JSONObject: result) else { return Promise(error: DataError.unexpectedResponseFormat) }
      self.bouquets = bouquets
      return Promise(value: bouquets)

    }
  }

  func createOrder(order: Order) -> Promise<Void> {
    return NetworkManager.doRequest(.createOrder, order.toJSON()).asVoid()
  }

}
