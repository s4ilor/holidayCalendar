//
//  request.swift
//  AMS_helloworld
//
//  Created by Paweł Olbrycht on 14/01/2020.
//  Copyright © 2020 Paweł Olbrycht. All rights reserved.
//

import Foundation
import Alamofire

enum HolidayError: Error{
    case noDataAvailable
    case canNotProcessData
}

//This is how we will access the response from the API.
//In here we need to configure all that we would like to access.
struct HolidayRequest {
    
var resourceURL: URL
    
let API_KEY = "bdd93ffcf5075fb400a48da445c8dcfe8654745f"
    
    init(countryCode : String) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat  = "2019"
        let currentYear = format.string(from: date)
        
        let destinationURL = "https://calendarific.com/api/v2/holidays?&api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        
        guard let resourceURL = URL(string: destinationURL) else {fatalError()}
        
        self.resourceURL = resourceURL
        
    }


    func getHolidays (compleation: @escaping(Result<[HolidayDetails], HolidayError>) ->Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in

            guard let jsonData = data else {
                compleation(.failure(.noDataAvailable))
                return
            }

            do{
                let decoder = JSONDecoder()
                let holidaysResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidayDetails = holidaysResponse.response.holidays
                compleation(.success(holidayDetails))
            }catch{
                compleation(.failure(.canNotProcessData))
            }

        }
        dataTask.resume()
    }
}
