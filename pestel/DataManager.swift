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

  func requestAuthCode(phone: Int) -> Promise<Void> {
    return NetworkManager.doRequest(.requestAuthCode(phone: phone)).then { result in
      self.phone = phone
    }
  }

  func confirmCode(code: String) -> Promise<Void> {
    guard let phone = phone else { return Promise(error: DataError.unknown) }
    return NetworkManager.doRequest(.confirmAuthCode(phone: phone, code: code)).asVoid()
  }

  func fetchBouquets() -> Promise<[Bouquet]> {
    return NetworkManager.doRequest(.getBouquets).then { result in
      guard let bouquets = Mapper<Bouquet>().mapArray(JSONObject: result) else { return Promise(error: DataError.unexpectedResponseFormat) }
      self.bouquets = bouquets
      return Promise(value: bouquets)

    }
  }

}
