//
//  Weather.swift
//  MoosamKiJaankari
//
//  Created by parag on 02/01/25.
//

import Foundation


struct WeatherManager {
     let baseUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=d1309379356e177897de596381cd5a7b"
    
    var delegate:WeatherManagerDelegate?
    
    func responseUnWrap(_ safeData:Data) -> String?{
        if let jsonString = String(data: safeData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }

    func errorJSONParser(_ data:Data) -> Error?{
        do{
         let response = try JSONDecoder().decode(ErrorModal.self,from: data)
            print("errorJSONParser", response)
            return response
        }catch{
            return nil
        }
    }
    
    func fetch(reqCity:String? = nil,lon:Double? = nil,lat:Double? = nil){
        var requestCity = "\(baseUrl)"
        if let reqCity{
            requestCity.append("&q=\(reqCity)")
        }
        
        if let lon ,let lat {
            requestCity.append("&lat=\(lat)&lon=\(lon)")
        }
      
//       print(requestCity)
        performRequest(url:requestCity)
    }
  
    func responseHandler(data:Data?,urlResponse:URLResponse?,error:Error?){
        if(error != nil){
            print(error!," responseHandler")
            delegate?.didUpdateWeatherError(error!);
            return;
        }
        //convert the data into string
        if let safeData = data {
            if let error = errorJSONParser(safeData){
                delegate?.didUpdateWeatherError(error);
                return;
            }
                if let currentWeather = parseJSON(data: safeData){
                    delegate?.didUpdateWeather(weather: currentWeather)
                }
            
        }
        
    }
    func performRequest(url:String){
        //1.Create url for request
        if let reqUrl = URL(string: url){
            //2.create a URLSession
            let session = URLSession(configuration: .default);
            
            //3.Give the session a task
            let task = session.dataTask(with: reqUrl,completionHandler: responseHandler(data:urlResponse:error:))
            
            //4.start the task;
            task.resume();
        }
    }
    
    func parseJSON(data:Data) -> WeatherModal?{
            do{
            let response = try JSONDecoder().decode(weatherResponse.self, from: data)
//                print(response, "parseJSONResponse")
                let weatherData =  WeatherModal(id: response.weather[0].id,temp: response.main.temp,name: response.name)
                return weatherData
            }catch{
//             print(error, " parseJSONError")
                delegate?.didUpdateWeatherError(error)
                return nil
        }
      
    }
    
}
