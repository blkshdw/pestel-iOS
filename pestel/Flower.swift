//
//  Flower.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper

class Flower: Mappable {
  var id: Int = 0
  var name: String = ""
  var description: String = ""
  var price: Double = 0
  var image: URL? = nil

  init() { }

  func mapping(map: Map) {
    id <- map["id"]


  }

  required init(map: Map) { }
  
}
