//
//  Order.swift
//  pestle
//
//  Created by Алексей on 27.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class Order: Mappable {
  var customBouquets: [CustomOrderBouquet] = []
  var bouquets: [OrderBouquet] = []
  var deliveryAddress: String = ""

  required init?(map: Map) {
    return nil
  }

  init() {
    
  }

  func mapping(map: Map) {
    customBouquets <- map["customBouquets"]
    bouquets <- map["bouquets"]
    deliveryAddress <- map["deliveryAddress"]
  }
}
