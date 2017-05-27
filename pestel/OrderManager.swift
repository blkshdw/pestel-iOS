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

  var price: Double {
    return bouquets
      .map { $0.price }
      .reduce(0.0, +) +
    bouquets.map { $0.price }
      .reduce(0.0, +)
  }

  func createOrder() -> Promise<Void> {
    let order = Order()
    order.customBouquets = customBouquets
    order.bouquets = bouquets
    return DataManager.instance.createOrder(order: order).then { _ -> Void in
      self.customBouquets = []
      self.bouquets = []
    }
  }
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

  var price: Double {
    return bouquet.price * Double(quantity)
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    bouquet.id >>> map["id"]
    quantity >>> map["quantity"]
  }
}

class CustomOrderBouquet: Mappable {
  var quantity: Int!
  var flowers: [CustomOrderBouquetItem] = []

  required init?(map: Map) {
    return nil
  }

  init(quantity: Int, flowers: [CustomOrderBouquetItem]) {
    self.quantity = quantity
    self.flowers = flowers
  }

  var price: Double {
    return flowers
      .map { $0.flower.price }
      .reduce(0.0, +)
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    quantity >>> map["quantity"]
    flowers >>> map["flowers"]
  }
}

class CustomOrderBouquetItem: Mappable {
  var id: Int = UUID().hashValue
  var quantity: Int!
  var flower: Flower!

  required init?(map: Map) {
    return nil
  }

  init(quantity: Int, flower: Flower) {
    self.quantity = quantity
    self.flower = flower
  }

  var price: Double {
    return flower.price
  }

  func mapping(map: Map) {
    guard map.mappingType == .toJSON else { return }
    quantity >>> map["quantity"]
    flower.id >>> map["id"]
  }
}

