//
//  User.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class User: Mappable {
  var id: Int = 0
  var firstName: String = ""
  var lastName: String = ""
  var email: String = ""
  var isNew: Bool = false
  var phoneNumber: String = ""

  var fullName: String {
    return firstName + " " + lastName
  }

  init() { }

  func mapping(map: Map) {
    id <- map["id"]
    firstName <- map["first_name"]
    lastName <- map["last_name"]
    phoneNumber <- map["phone_number"]
    email <- map["email"]
    isNew <- map["isNew"]
  }

  required init(map: Map) { }
  
}
