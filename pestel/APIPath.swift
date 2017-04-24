//
//  APIPath.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import Alamofire

enum APIPath {
  case getFlowers
  case getBouquets
  case requestAuthCode(phone: Int)
  case confirmAuthCode(phone: Int, code: String)
  case createUser
  case updateUser
  case getUser
  case addPromoCode

  var rawPath: String {
    switch self {
    case .requestAuthCode(let phone):
      return "auth/\(phone)"
    case .confirmAuthCode(let phone, let code):
      return "auth/\(phone)/confirm/\(code)"
    case .updateUser, .createUser, .getUser:
      return "user"
    case .addPromoCode:
      return "promo_codes"
    case .getFlowers:
      return "flowers"
    case .getBouquets:
      return "bouquets"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .requestAuthCode(_), .createUser, .addPromoCode, .confirmAuthCode(_, _):
      return .post
    case .updateUser:
      return .put
    default:
      return .get
    }
  }

  var encoding: ParameterEncoding {
    switch method {
    case .get, .delete:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
}
