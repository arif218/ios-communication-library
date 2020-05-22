//
//  NCCommunication+PushNotification.swift
//  NCCommunication
//
//  Created by Marino Faggiana on 22/05/2020.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import Alamofire
import SwiftyJSON

extension NCCommunication {

    @objc public func subscribingPushNotification(serverUrl: String, account: String, user: String, password: String, pushTokenHash: String, devicePublicKey: String, proxyServerUrl: String, customUserAgent: String? = nil, addCustomHeaders: [String:String]? = nil, completionHandler: @escaping (_ account: String, _ deviceIdentifier: String?, _ signature: String?, _ publicKey: String?, _ errorCode: Int, _ errorDescription: String?) -> Void) {
                            
        guard let devicePublicKeyEncoded = NCCommunicationCommon.shared.encodeString(devicePublicKey) else {
            completionHandler(account, nil, nil, nil, NSURLErrorUnsupportedURL, NSLocalizedString("_invalid_url_", value: "Invalid server url", comment: ""))
            return
        }
        
        let endpoint = "ocs/v2.php/apps/notifications/api/v2/push?format=json&pushTokenHash=" + pushTokenHash + "&devicePublicKey=" + devicePublicKeyEncoded + "&proxyServer=" + proxyServerUrl
        
        guard let url = NCCommunicationCommon.shared.createStandardUrl(serverUrl: serverUrl, endpoint: endpoint) else {
            completionHandler(account, nil, nil, nil, NSURLErrorUnsupportedURL, NSLocalizedString("_invalid_url_", value: "Invalid server url", comment: ""))
            return
        }
        
        let method = HTTPMethod(rawValue: "POST")
        let headers = NCCommunicationCommon.shared.getStandardHeaders(user: user, password: password, appendHeaders: addCustomHeaders, customUserAgent: customUserAgent, e2eToken: nil)
        
        sessionManager.request(url, method: method, parameters:nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).validate(statusCode: 200..<300).responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .failure(let error):
                let error = NCCommunicationError().getError(error: error, httResponse: response.response)
                completionHandler(account, nil, nil, nil, error.errorCode, error.description)
            case .success(let json):
                let json = JSON(json)
                let statusCode = json["ocs"]["meta"]["statuscode"].int ?? -999
                if 200..<300 ~= statusCode  {
                    var deviceIdentifier = json["ocs"]["data"]["deviceIdentifier"].stringValue
                    var signature = json["ocs"]["data"]["signature"].stringValue
                    var publicKey = json["ocs"]["data"]["publicKey"].stringValue
                    
                    deviceIdentifier = NCCommunicationCommon.shared.encodeString(deviceIdentifier) ?? ""
                    signature = NCCommunicationCommon.shared.encodeString(signature) ?? ""
                    publicKey = NCCommunicationCommon.shared.encodeString(publicKey) ?? ""
                    
                    completionHandler(account, deviceIdentifier, signature, publicKey, 0, nil)
                } else {
                    let errorDescription = json["ocs"]["meta"]["errorDescription"].string ?? NSLocalizedString("_invalid_data_format_", value: "Invalid data format", comment: "")
                    completionHandler(account, nil, nil, nil, statusCode, errorDescription)
                }
            }
        }
    }
    
    @objc public func unsubscribingPushNotification(serverUrl: String, account: String, user: String, password: String, customUserAgent: String? = nil, addCustomHeaders: [String:String]? = nil, completionHandler: @escaping (_ account: String, _ errorCode: Int, _ errorDescription: String?) -> Void) {
                            
        let endpoint = "ocs/v2.php/apps/notifications/api/v2/push"
        
        guard let url = NCCommunicationCommon.shared.createStandardUrl(serverUrl: serverUrl, endpoint: endpoint) else {
            completionHandler(account, NSURLErrorUnsupportedURL, NSLocalizedString("_invalid_url_", value: "Invalid server url", comment: ""))
            return
        }
        
        let method = HTTPMethod(rawValue: "DELETE")
        let headers = NCCommunicationCommon.shared.getStandardHeaders(user: user, password: password, appendHeaders: addCustomHeaders, customUserAgent: customUserAgent, e2eToken: nil)
        
        sessionManager.request(url, method: method, parameters:nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).validate(statusCode: 200..<300).response { (response) in
            debugPrint(response)
            switch response.result {
            case .failure(let error):
                let error = NCCommunicationError().getError(error: error, httResponse: response.response)
                completionHandler(account, error.errorCode, error.description)
            case .success( _):
                completionHandler(account, 0, nil)
            }
        }
    }
    
    @objc public func subscribingPushProxy(proxyServerUrl: String, pushToken: String, deviceIdentifier: String, signature: String, publicKey: String, userAgent: String, completionHandler: @escaping (_ errorCode: Int, _ errorDescription: String?) -> Void) {
                
        let endpoint = "/devices?format=json&pushToken=" + pushToken + "&deviceIdentifier=" + deviceIdentifier + "&deviceIdentifierSignature=" + signature + "&userPublicKey=" + publicKey
        
        guard let url = NCCommunicationCommon.shared.createStandardUrl(serverUrl: proxyServerUrl, endpoint: endpoint) else {
            completionHandler(NSURLErrorUnsupportedURL, NSLocalizedString("_invalid_url_", value: "Invalid server url", comment: ""))
            return
        }
        
        let method = HTTPMethod(rawValue: "POST")
        var headers = HTTPHeaders()
        headers.update(.userAgent(userAgent))
                
        sessionManager.request(url, method: method, parameters:nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).validate(statusCode: 200..<300).response { (response) in
            debugPrint(response)
            switch response.result {
            case .failure(let error):
                let error = NCCommunicationError().getError(error: error, httResponse: response.response)
                completionHandler(error.errorCode, error.description)
            case .success( _):
                completionHandler(0, nil)
            }
        }
    }
    
    @objc public func unsubscribingPushProxy(proxyServerUrl: String, deviceIdentifier: String, signature: String, publicKey: String, completionHandler: @escaping (_ errorCode: Int, _ errorDescription: String?) -> Void) {
                
        let endpoint = "/devices?format=json&deviceIdentifier=" + deviceIdentifier + "&deviceIdentifierSignature=" + signature + "&userPublicKey=" + publicKey
        
        guard let url = NCCommunicationCommon.shared.createStandardUrl(serverUrl: proxyServerUrl, endpoint: endpoint) else {
            completionHandler(NSURLErrorUnsupportedURL, NSLocalizedString("_invalid_url_", value: "Invalid server url", comment: ""))
            return
        }
        
        let method = HTTPMethod(rawValue: "POST")
        
        sessionManager.request(url, method: method, parameters:nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).validate(statusCode: 200..<300).response { (response) in
            debugPrint(response)
            switch response.result {
            case .failure(let error):
                let error = NCCommunicationError().getError(error: error, httResponse: response.response)
                completionHandler(error.errorCode, error.description)
            case .success( _):
                completionHandler(0, nil)
            }
        }
    }
}

