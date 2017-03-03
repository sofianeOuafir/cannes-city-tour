//
//  DetailsViewController.swift
//  TD5
//
//  Created by GELE Axel on 28/02/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager = CLLocationManager()

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var openMap: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    var valeurImage: String = ""
    var valeurNumero: String = ""
    var valeurNom: String = ""
    var valeurLong: Float = 0.0
    var valeurLatt: Float = 0.0
    
    var myRoute : MKRoute!

    @IBAction func callPhone(_ sender: UIButton) {
        valeurNumero.trimmingCharacters(in: .whitespaces)
        let url:NSURL = NSURL(string: valeurNumero)!
        print(valeurNumero)
        
        if (UIApplication.shared.canOpenURL((url as URL)))
        {
            UIApplication.shared.openURL(url as URL)
            print("T dans la boucle")
        }
        //print( "Test : " + variable.description)
        print("T pas dans la boucle")

        
    }

    
    @IBAction func openMap(_ sender: Any) {
        
        let latitude: CLLocationDegrees = CLLocationDegrees(valeurLatt)
        let longitude: CLLocationDegrees = CLLocationDegrees(valeurLong)
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name =  valeurNom
        
        mapItem.openInMaps(launchOptions: options)

    }
    
    @IBAction func share(_ sender: UIButton) {
        let activityItems = [self.imageView.image, valeurNom] as [Any]

        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: valeurImage)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        imageView.image = image
        let point1 = MKPointAnnotation() // Creattion des deux points
        let point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        point1.title = "Point depart "
        point1.subtitle = ""
        mapView.addAnnotation(point1) // affichage des points
        
        point2.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(valeurLatt), CLLocationDegrees(valeurLong
        ))
        point2.title = "Point arrive "
        point2.subtitle = ""
        mapView.addAnnotation(point2)
        mapView.centerCoordinate = point2.coordinate
        mapView.delegate = self

        mapView.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(1,1)), animated: true)
        
        // affichage de l'itinéraire
        
        let directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markChungli)
        directionsRequest.destination = MKMapItem(placemark: markTaipei)
        
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            
            if error == nil {
                self.myRoute = response!.routes[0] as MKRoute
                self.mapView.add(self.myRoute.polyline)
            }
        

            
        
        })
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(monImage : String, monNumero : String, monNom : String, maLatt : Float, maLong : Float){
        print("lala" + monImage)
        valeurImage = monImage
        valeurNumero = monNumero
        valeurNom = monNom
        valeurLatt = maLatt
        valeurLong = maLong
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.darkGray
        myLineRenderer.lineWidth = 3
        return myLineRenderer
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        let positionUser = MKPointAnnotation()
        positionUser.coordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        mapView.addAnnotation(positionUser)
        locationManager.stopUpdatingLocation()
     }



}
