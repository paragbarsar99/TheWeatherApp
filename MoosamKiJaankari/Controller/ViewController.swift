//
//  ViewController.swift
//  MoosamKiJaankari
//
//  Created by parag on 01/01/25.
//

import UIKit
import CoreLocation
import ToastViewSwift
protocol WeatherManagerDelegate {
    func didUpdateWeather(weather:WeatherModal)
    func didUpdateWeatherError(_ error:Error)
}
class ViewController: UIViewController, UITextFieldDelegate {
    var isLocationPermissionAllowed:Bool = false
    var mainView = MainView();
    lazy var searchBar = mainView.InputField()
    lazy var searchIcon = mainView.IconButton(icon: "magnifyingglass")
    lazy var locationIcon = mainView.IconButton(icon:"location.fill")
    lazy var weatherIcon = mainView.ImageView()
    lazy var currentCity = mainView.Text()
    lazy var degreeText = mainView.Text()
    lazy var temp = mainView.Text()
    lazy var backgroundImg = mainView.BackgroundImg(src:"background" )

    var weatherModal = WeatherManager()
    var locationHandler = CLLocationManager()
    
    func onSearch(){
        if(!searchBar.isFirstResponder){
            searchBar.becomeFirstResponder();
            return
        }
        if let input = searchBar.text{
            if(input.count >= 3){
            weatherModal.fetch(reqCity: input)
            searchBar.text = ""
            searchBar.endEditing(true)
            searchBar.placeholder = input
            }else{
                onShowToastMessage(text: "Please enter more than 3 characters")
            }
        }
    }

    func onUpdateWeatherIcon(icon:String) {
        weatherIcon.image =  mainView.SystemUIImage(src: icon,config:UIImage.SymbolConfiguration(pointSize: 100))
        animateSymbol()
    }
    
    func permissionHandler(){
        switch locationHandler.authorizationStatus {
        case .authorizedWhenInUse:
            print("allowd authorizedWhenInUse")
            locationHandler.desiredAccuracy = kCLLocationAccuracyBest
            locationHandler.startUpdatingLocation()
        case .denied:
            self.showLocationPermissionDeniedAlert()
            print("not allowd authorizedWhenInUse")

        default:
            self.showLocationPermissionDeniedAlert()
            print("unknown",locationHandler.authorizationStatus)
        }
    }
    
    func onAskLocationPermsision(){
            locationHandler.requestWhenInUseAuthorization();
            permissionHandler()
                
    }
    
    func onShowToastMessage(text:String){
        DispatchQueue.main.async {
            let toast =  Toast.text(text.capitalized(with: .current))
            toast.show()
        }
    }
    
    func showLocationPermissionDeniedAlert() {
            let alert = UIAlertController(title: "Location Access Denied", message: "Please enable location access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                self.openAppSettings()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    func animateSymbol() {
        // Start the animation
               UIView.animate(withDuration: 0.3, animations: {
                   // Bounce up effect
                   self.weatherIcon.transform = CGAffineTransform(translationX: 0, y: -20)
               }) { _ in
                   UIView.animate(withDuration: 0.3, animations: {
                       // Slight drop back
                       self.weatherIcon.transform = CGAffineTransform(translationX: 0, y: 10)
                   }) { _ in
                       // Final position, resetting transform
                       UIView.animate(withDuration: 0.2) {
                           self.weatherIcon.transform = .identity
                       }
                   }
               }
    }
    
   @objc func onSetupTapGesture(){
       searchBar.resignFirstResponder();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onSetupTapGesture))
        view.addGestureRecognizer(gesture)
        searchBar.delegate = self
        weatherModal.delegate = self
        locationHandler.delegate = self
        let searchbarContianer = mainView.HStack()
        let tempDetailsContainer = mainView.VStack()
        let tempRowContainer = mainView.HStack()
        view.addSubview(backgroundImg)
        view.addSubview(searchbarContianer)
        view.addSubview(tempDetailsContainer)
       
        NSLayoutConstraint.activate([
            backgroundImg.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        //top search bar

        searchBar.attributedPlaceholder = NSAttributedString(
            string: "New York",
            attributes: [
                .foregroundColor: UIColor.label.withAlphaComponent(0.5)
            ]
        )
        searchBar.returnKeyType = .search
        searchIcon.addAction(UIAction {_ in
            self.onSearch()
        }, for: .touchUpInside  )
        
        locationIcon.addAction(UIAction {_ in
            self.onAskLocationPermsision()
        }, for: .touchUpInside)
        
        searchbarContianer.addArrangedSubview(locationIcon);
        searchbarContianer.addArrangedSubview(searchBar);
        searchbarContianer.addArrangedSubview(searchIcon);
        
        searchbarContianer.distribution = .fill;
        searchbarContianer.alignment = .center;
        
        locationIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        locationIcon.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
      
        searchIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        searchIcon.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
     
        NSLayoutConstraint.activate([
            searchbarContianer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            searchbarContianer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            searchbarContianer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])

        weatherIcon.tintColor = .systemBackground
        locationIcon.tintColor = .systemBackground;
        searchIcon.tintColor = .systemBackground
        
 
        let degree = mainView.ImageView()

        degree.image = UIImage(systemName: "degreesign.celsius",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        degree.tintColor = .systemBackground
        degree.contentMode = .scaleAspectFill;
        
         
        temp.font = UIFont.systemFont(ofSize: 72,weight: .bold)
      
      
        
        temp.textColor = .systemBackground
        degreeText.textColor = .systemBackground
  
        currentCity.font =  UIFont.systemFont(ofSize: 28,weight: .semibold)
        currentCity.textColor = .systemBackground
        
        //tem details container
        tempRowContainer.addArrangedSubview(temp)

//        tempRowContainer.addArrangedSubview(degree)

        tempRowContainer.alignment = .center
        tempDetailsContainer.addArrangedSubview(weatherIcon)
        tempDetailsContainer.addArrangedSubview(tempRowContainer)
        tempDetailsContainer.addArrangedSubview(currentCity)
    
        tempDetailsContainer.alignment = .trailing;
    
        NSLayoutConstraint.activate([
            tempDetailsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tempDetailsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40),
            tempDetailsContainer.topAnchor.constraint(equalTo: searchbarContianer.bottomAnchor,constant: 20),
        ])
        onAskLocationPermsision()
    }
}


extension ViewController:UITextInputDelegate,WeatherManagerDelegate,CLLocationManagerDelegate{
    func didUpdateWeatherError(_ error: Error) {
         if let clientError = error as? ErrorModal{
             self.onShowToastMessage(text: clientError.message)
           
        }
    }
    
    func didUpdateWeather(weather: WeatherModal) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
//            print(weather.condition)
            self.onUpdateWeatherIcon(icon: weather.condition)
            self.temp.text = "\(weather.tempreture)°C";
            self.currentCity.text = weather.cityName;
            self.searchBar.placeholder = weather.cityName
        }
      
    }
    
    func selectionWillChange(_ textInput: UITextInput?) {
        
    }
    
    func selectionDidChange(_ textInput: UITextInput?) {
        
    }
    
    func textWillChange(_ textInput: UITextInput?) {
        
    }
    
    func textDidChange(_ textInput: UITextInput?) {
        
    }
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSearch()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    print("Latitude: \(latitude), Longitude: \(longitude)")
                    self.weatherModal.fetch(lon: longitude,lat: latitude);
                    // Stop updates if you only need the current location
                    manager.stopUpdatingLocation()
                }
     }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.permissionHandler()
    }
}


#Preview{
    ViewController()
}


