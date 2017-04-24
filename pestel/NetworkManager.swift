//
//  NetworkManager.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import PromiseKit

class NetworkManager {
  static let baseUrl = "https://otsos.top"
  static let apiPrefix = "/"

  static func doRequest(_ path: APIPath, _ params: Parameters = [:], _ headers: HTTPHeaders = [:]) -> Promise<Any?> {
    return Promise() { fullfill, reject in
      var params = params
      if let apiToken: String? = StorageHelper.loadObjectForKey(.apiToken) {
        params["api_token"] = apiToken
      }

      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      let url = URL(string: self.baseUrl + self.apiPrefix + path.rawPath)!

      var headers = headers
      headers["accept"] = "application/json"

      Alamofire.request(url, method: path.method, parameters: params, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          debugPrint(response)
          switch response.result {
          case .success:
            if let responseObj = Mapper<PestleResponse>().map(JSONObject: response.result.value) {
              guard responseObj.status == "ok" else { return reject(DataError.unknown) }
              fullfill(responseObj.response)
            } else {
              reject(DataError.unexpectedResponseFormat)
            }
          case .failure:
            if let error = response.result.error {
              guard let alamofireError = error as? AFError else { return reject(error) }
              switch alamofireError {
              case .responseSerializationFailed(reason: .inputDataNilOrZeroLength):
                fullfill(())
              default:
                reject(error)
              }
            } else {
              reject(DataError.unexpectedResponseFormat)
            }
            reject(getError(response.response?.statusCode))
          }
      }
    }
  }

  static func getError(_ statusCode: Int?) -> DataError {
    guard let statusCode = statusCode else { return .unknown }

    switch statusCode {
    case 422: return .unprocessableData
    case 503, 500: return .serverUnavaliable
    default: return .unknown
    }
  }
}

class PestleResponse: Mappable {
  var status: String = ""
  var response: Any? = nil

  required init(map: Map) { }

  func mapping(map: Map) {
    status <- map["status"]
    response <- map["response"]
  }
}