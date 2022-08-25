//
//  LocationManager.swift
//  Test
//
//  Created by PC on 25/08/22.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject {
    
    // MARK: - Properties
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? = nil
    private var forceForLocationPermission = false
    private var onLocationAccessCompletion: ((Bool) -> ())?
    private var onLocationUpdateHandler: ((CLLocationCoordinate2D?, Error?) -> ())?
    
    // MARK: - Init
    private override init() {
        super.init()
        setupLocationManager()
        addNotificationObservers()
    }
    
    // MARK: - Deinit
    deinit {
        removeNotificationObservers()
        stopLocationUpdate()
    }
    
    // MARK: - Functions
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 10
        //        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
    }
    
    func startLocationUpdate(onLocationUpdate: @escaping ((CLLocationCoordinate2D?, Error?) -> ())) {
        onLocationUpdateHandler = onLocationUpdate
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
        onLocationAccessCompletion = nil
        forceForLocationPermission = false
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func requestLocationServiceIfNeed(force: Bool, completionHandler: @escaping ((Bool) -> ())) {
        onLocationAccessCompletion = completionHandler
        forceForLocationPermission = force
        checkForLocationServicePermission()
    }
    
    func requestUserLocationServiceIfNeed(completionHandler: @escaping ((Bool) -> ())) {
        onLocationAccessCompletion = completionHandler
        //        checkForUserLocationServicePermission()
        checkForLocationServicePermission()
    }
    
    private func checkForLocationServicePermission() {
        DispatchQueue.main.async {
            let authorizationStatus: CLAuthorizationStatus
            if #available(iOS 14, *) {
                authorizationStatus = self.locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            
            switch authorizationStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.onLocationAccessCompletion?(true)
            case .denied, .restricted:
                Utils.showAlertForAppSettings(title: "We Can't Get Your Location", message: "To enable location service, you need to allow location service for this application from settings.", allowCancel: true) { (completed) in
                }
                self.onLocationAccessCompletion?(false)
            @unknown default:
                break
            }
        }
    }
    
    func getPromiseCurrentLocation(comp: @escaping ((CLLocationCoordinate2D?)->())) {
        LocationManager.shared.startLocationUpdate { location,error  in
            if let location = location {
                comp(location)
            } else if let error = error {
                print(error.localizedDescription)
                comp(nil)
            }
            LocationManager.shared.stopLocationUpdate()
        }
    }
    
    
    func getFullAddress(location: CLLocation, completionHandler: @escaping ((String)->())) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            self.generateAddress(objPlacemark: placemark, completionHandler: completionHandler)
        }
    }
    
    private func generateAddress(objPlacemark : CLPlacemark, completionHandler: @escaping ((String)->())) {
        
        print("objPlacemark : \(objPlacemark.description)")
        var completeAddress = ""
        
        if objPlacemark.name != nil {
            completeAddress = String(describing: objPlacemark.name!)
        }
        
        if objPlacemark.thoroughfare != nil && (objPlacemark.name != objPlacemark.thoroughfare) {
            completeAddress = completeAddress + ", " + String(describing: objPlacemark.thoroughfare!)
        }
        
        if objPlacemark.subThoroughfare != nil {
            completeAddress = completeAddress + ", " + String(describing: objPlacemark.subThoroughfare!)
        }
        
        if objPlacemark.subLocality != nil {
            completeAddress = completeAddress + "," + String(describing: objPlacemark.subLocality!)
        }
        
        if objPlacemark.locality != nil {
            completeAddress = String(describing: objPlacemark.locality!)
        }
        
        if objPlacemark.postalCode != nil {
            completeAddress = completeAddress + "," + String(describing: objPlacemark.postalCode!)
        }
        
        if objPlacemark.administrativeArea != nil {
            completeAddress = completeAddress + "," +  String(describing: objPlacemark.administrativeArea!)
        }
        
        if objPlacemark.isoCountryCode != nil {
            completeAddress = completeAddress + "," + String(describing: objPlacemark.isoCountryCode!)
        }
        
        print("completeAddress : \(completeAddress)")
        return completionHandler(completeAddress)
    }
    
    //    private func checkForUserLocationServicePermission() {
    //        DispatchQueue.main.async {
    //            switch CLLocationManager.authorizationStatus() {
    //            case .notDetermined:
    //                self.locationManager.requestWhenInUseAuthorization()
    //            case .authorizedAlways, .authorizedWhenInUse:
    //                self.onLocationAccessCompletion?(true)
    //            case .denied, .restricted:
    //                self.onLocationAccessCompletion?(false)
    //            @unknown default:
    //                break
    //            }
    //        }
    //    }
    
    // MARK: - NotificationCenter events
    @objc private func onApplicationWillEnterForegroundNotification() {
        if forceForLocationPermission {
            checkForLocationServicePermission()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Get Error: did failed with error: \(error)")
        onLocationUpdateHandler?(currentLocation,error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkForLocationServicePermission()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        currentLocation = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        currentLocation = location.coordinate
        onLocationUpdateHandler?(currentLocation,nil)
    }
}



// MARK: - USE
/*
 
 private func requestLocationServiceAccess() {
     LocationManager.shared.requestLocationServiceIfNeed(force: false) { (haspermission) in
         if !haspermission {
             DispatchQueue.main.async {
                 Utility.showAlertForAppSettings(title: "Need to access Location service", message: "Turn on Location services on your device.", allowCancel: true) { (completed) in
                 }
                 return
             }
         } else {
             self.addLocation()
         }
     }
 }
 
 private func addLocation() {
     LocationHelper.shared.startLocationUpdate { letlong, error in
         if error == nil {
             let cordinate = CLLocation(latitude: letlong!.latitude, longitude: letlong!.longitude)
             LocationHelper.shared.getFullAddress(location: cordinate) { address in
                 print(address)
             }
             LocationHelper.shared.stopLocationUpdate()
         }
     }
 }
 
 */

