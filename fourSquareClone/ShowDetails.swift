//
//  ShowDetails.swift
//  fourSquareClone
//
//  Created by Doğukan Ahi on 27.07.2023.
//

import UIKit
import MapKit
import Parse
class ShowDetails: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var placeatmospherelabel: UILabel!
    @IBOutlet weak var placetypelabel: UILabel!
    
    @IBOutlet weak var placenamelabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageview: UIImageView!
    
    var chosenID = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        getData()
        
        
        
        
        
    }
    func getData(){
       
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenID)
        query.findObjectsInBackground(){ (objects,error) in
            
            if error != nil {
                print("Error")
                
                
            }else{
                
                if objects != nil {
                    
                    for object in objects!{
                        
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placetype = object.object(forKey: "type") as? String {
        
                                if let placeAtmospheree = object.object(forKey: "atmosphere") as? String {
                                    
                                    self.placenamelabel.text = "Place Name: \(placeName)"
                                    self.placetypelabel.text = "Place Type: \(placetype)"
                                    self.placeatmospherelabel.text = "Place Atmosphere: \(placeAtmospheree)"
                                    if let placeLatitude = object.object(forKey: "latitude") as? String {
                                        
                                        if let placeLatitudeDouble = Double(placeLatitude) {
                                            self.chosenLatitude = placeLatitudeDouble
                                        }
                                        
                                    }
                                    
                                    if let placeLongitude = object.object(forKey: "longitude") as? String{
                                        if let placeLongitudeDouble = Double(placeLongitude){
                                            self.chosenLongitude = placeLongitudeDouble
                                        }
                                        
                                    }
                                    
                                    
                                    if let imageData = object.object(forKey: "image") as? PFFileObject{
                                        
                                        imageData.getDataInBackground{(data, error)in
                                            
                                            if error != nil {
                                                
                                                print("error!")
                                            
                                            }else {
                                                
                                                
                                                self.imageview.image = UIImage(data: data!)
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = self.placenamelabel.text!
                    annotation.subtitle = self.placetypelabel.text!
                    annotation.coordinate = location
                    self.mapView.addAnnotation(annotation)
                    
                }
                
                
                
                
            }
            
            
        }
        
        
        
        
        
    }

    
    
    
        
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId) // info görseli eklemek
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            
            pinView?.annotation = annotation
        }
        return pinView
        
        
       
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLatitude != 0.0 { // konum bilgisi geliyor mu kontrolü
            
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude) // seçilen koordinatları beliremek için
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                
                if let placemark = placemarks { // optional olmaktan çıkarıyoruz
                    
                    
                    if placemark.count > 0 { // veri geldi mi kontrolü
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0]) //
                        
                        let mapItem = MKMapItem(placemark: mkPlaceMark) // navigasyon açmak için
                        
                        mapItem.name = self.placenamelabel.text! // isimi beliremek
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] // launch option set 
                        mapItem.openInMaps(launchOptions: launchOptions) // haritaları açmak
                        
                    }
                    
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    
    
    
    
    
}
