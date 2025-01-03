//
//  WeatherModal.swift
//  MoosamKiJaankari
//
//  Created by parag on 02/01/25.
//

import Foundation



struct WeatherModal {
  
    var cityName: String
    
    private  var temp:Float
    
    var tempreture: String {
        return String(format: "%.2f", temp)
    }
    
   
   private let id: WEATHERCONDITION

    //computation prop
    var condition:String {
        switch id {
        case .thunderstorm:
//           print("thunderstorm")
            return "cloud.bolt"
        case .drizzle:
//            print("drizzle")
             return "cloud.drizzle"
        case .rain:
//            print("rain")
             return "cloud.heavyrain.fill"
        case .snow:
//            print("snow")
             return "sun.snow"
        case .atmosphere:
//            print("atmosphere")
             return "cloud.fog"
        case .clearSky:
//            print("atmosphere")
             return "sun.max"
        case .brokenClouds:
//            print("brokenClouds")
             return "smoke"
        default:
//             print("unknown")
            return "sun.min"
        }
    
        
    }
    
    init(id: WEATHERCONDITION,temp:Float,name:String) {
        self.id = id
        self.temp = temp
        self.cityName = name
    }
    
}
