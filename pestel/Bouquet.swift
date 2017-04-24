//
//  Bouquet.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class Bouquet: Mappable {
  var id: Int = 0
  var name: String = ""
  var description: String = ""
  var image: URL? = nil
  var price: Double = 0

  init() { }

  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    description <- map["description"]
    price <- map["price"]
    image <- (map["image"], URLTransform())
  }

  required init(map: Map) { }
  
}
