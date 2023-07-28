//
//  MapVC.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 27.07.2023.
//

import UIKit
import MapKit
import Parse
class MapVC: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Go Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecgnizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
        
        
            }
    
    
    @objc func chooseLocation(gestureRecgnizer: UIGestureRecognizer){
        
        
        if gestureRecgnizer.state == UIGestureRecognizer.State.began { // biri tıkladıysa uzun süre kontrolü
            
            let touches = gestureRecgnizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            
            self.mapView.addAnnotation(annotation)
            
            self.chosenLatitude = String(coordinates.latitude)
            self.chosenLongitude = String(coordinates.longitude)
            
        }
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude:  locations[0].coordinate.longitude) // konum almak için
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // zooom miktarı
        let region = MKCoordinateRegion(center: location, span: span) // yer belirleme
        
        mapView.setRegion(region, animated: true) // haritada belirlenen yeri displayleme
        
        
        
    }
    
  @objc  func saveButtonClicked(){
        let object = PFObject(className: "Places")
      let Placemodel = PlaceModel.sharedInstance
      object["name"] = Placemodel.placeName
      object["type"] = Placemodel.placeType
      object["atmosphere"] = Placemodel.placeAtmosphere
      object["latitude"] = self.chosenLatitude
      object["longitude"] = self.chosenLongitude
      
      
      if let imageData = Placemodel.placeImage.jpegData(compressionQuality: 0.5 ){
          object["image"] = PFFileObject(name: "image.jpg", data: imageData)
          
          
      }
      object.saveInBackground {(success, error) in
          
          if error != nil {
              
              print("Error occured while saving image.")
          }else{
              self.performSegue(withIdentifier: "toSavedPlaces", sender: nil)
          }
          
      }
    
      
      

      
    }

    @objc  func backButtonClicked(){
          performSegue(withIdentifier: "fromMaptoUpload", sender: nil)
      }
}
