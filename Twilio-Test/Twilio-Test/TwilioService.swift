//
//  TwilioService.swift
//  Twilio-Test
//
//  Created by Carlos Alcala on 7/21/24.
//
//Almofire Package is https://github.com/Alamofire/Alamofire
import Foundation
import Alamofire

class TwilioService {
    //var for Twilio credentials
    let accountSID = "sid"
    let authToken = "auth"
    let fromNumber = "+num"

    //function for sending messages
    func sendSMS(to number: String, message: String, completion: @escaping (String) -> Void) {
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages.json"
        let parameters: [String: String] = [
            "From": fromNumber,
            "To": number,
            "Body": message
        ]

        //tappig into the HTTP
        let headers: HTTPHeaders = [
            .authorization(username: accountSID, password: authToken)
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion("Message sent successfully")
                case .failure(let error):
                    completion("Failed to send message: \(error.localizedDescription)")
                }
            }
    }
}
