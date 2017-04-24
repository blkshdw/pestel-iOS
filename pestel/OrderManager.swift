//
//  OrderManager.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class OrderManager {
  static let instance = OrderManager()

  var customBouquets: [CustomOrderBouquet] = []
  var bouquets: [OrderBouquet] = []
}


class OrderBouquet: Mappable {
  var bouquet: Bouquet!
  var quantity: Int!

  required init?(map: Map) {
    return nil
  }

  init(bouquet: Bouquet, quantity: Int = 1) {
    self.bouquet = bouquet
    self.quantity = quantity
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    bouquet.id >>> map["id"]
    quantity >>> map["quantity"]
  }
}

class CustomOrderBouquet: Mappable {
  var quantity: Int!
  var flowers: [CustomOrderBouquetFlower] = []

  required init?(map: Map) {
    return nil
  }

  init(quantity: Int, flowers: [CustomOrderBouquetFlower]) {
    self.quantity = quantity
    self.flowers = flowers
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    quantity >>> map["quantity"]
    flowers >>> map["flowers"]
  }
}

class CustomOrderBouquetFlower: Mappable {
  var quantity: Int!
  var flower: Flower!

  required init?(map: Map) {
    return nil
  }

  init(quantity: Int, flower: Flower) {
    self.quantity = quantity
    self.flower = flower
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    quantity >>> map["quantity"]
    flower.id >>> map["id"]
  }
}

