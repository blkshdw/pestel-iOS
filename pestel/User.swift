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
  var isNew: Bool = true
  var phoneNumber: String = ""
  var street: String = ""
  var building: String = ""
  var appt: String = ""

  var fullName: String {
    return firstName + " " + lastName
  }

  init() { }

  func mapping(map: Map) {
    id <- map["id"]
    firstName <- map["firstName"]
    lastName <- map["lastName"]
    phoneNumber <- map["phoneNumber"]
    email <- map["email"]
    isNew <- map["isNew"]
    street <- map["street"]
    building <- map["building"]
    appt <- map["appt"]
  }

  required init(map: Map) { }
  
}
