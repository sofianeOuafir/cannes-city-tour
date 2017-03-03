//
//  MapViewController.swift
//  TD5
//
//  Created by GELE Axel on 20/02/2017.
//  Copyright © 2017 GELE Axel. All rights reserved.
//

import UIKit
import MapKit
import SWXMLHash
import CoreLocation
//class customAnnotationView : MKAnnotationView {
//    let mytitle : UILabel
//    let mySubtitle :
//    
//}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var POIList = [POI]()
    @IBOutlet var maMap: MKMapView!
    var locationManager = CLLocationManager()


    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        maMap.delegate = self
        maMap.showsUserLocation = true
        let myIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        myIndicatorView.center = self.view.center
        myIndicatorView.hidesWhenStopped = true
        myIndicatorView.color = UIColor.white
        myIndicatorView.backgroundColor = UIColor.black
        self.view.addSubview(myIndicatorView)
        myIndicatorView.startAnimating()
        let url = URL(string: "http://dam.lanoosphere.com/poi.xml")
        let data = try? Data(contentsOf: url!)
        let xml = SWXMLHash.lazy(data!)
        
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        
        
        maMap.showsScale = true
        for elem in xml["Data"]["POI"].all {
            //var monPOI = POI()
            let id = (elem.element?.attribute(by: "id")?.text)!
            let name = (elem.element?.attribute(by: "name")?.text)!
            let image = (elem.element?.attribute(by: "image")?.text)!
            let lattitude = Float((elem.element?.attribute(by: "latitude")?.text)!)
            let longitude = Float((elem.element?.attribute(by: "longitude")?.text)!)
            let phone = (elem.element?.attribute(by: "phone")?.text)!
            let email = (elem.element?.attribute(by: "mail")?.text)!
            let url = (elem.element?.attribute(by: "url")?.text)!
            let description = (elem.element?.attribute(by: "description")?.text)!
            let monPOI = POI(id: id, name: name, image: image, latt: lattitude!, long: longitude!, phone: phone, email: email, url: url, description: description)
            POIList.append(monPOI)
            NSLog(monPOI.id)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            myIndicatorView.stopAnimating()
        })
        

        for POI in POIList
        {
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(POI.latt), longitude: CLLocationDegrees(POI.long))
            maMap.addAnnotation(annotation)
            annotation.title = POI.name
            let address = CLLocation(latitude: CLLocationDegrees(POI.latt), longitude: CLLocationDegrees(POI.long))
            CLGeocoder().reverseGeocodeLocation(address, completionHandler: {
                placemarks, error in
                
                if error == nil && (placemarks?.count)! > 0 {
                    let placeMark = placemarks?.last
                    
                    annotation.subtitle = placeMark?.thoroughfare
                    
                }
            })


        }
        maMap.showAnnotations(maMap.annotations, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //let button = UIButton(type: .detailDisclosure)
            let identifier = "customAnnotation"
    
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            return annotationView
        
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let myDetailsViewController = storyboard.instantiateViewController(withIdentifier: "detailView") as! DetailsViewController
        
        var POI = POIList[1]
        for aPOI in POIList
        {
            if(aPOI.name == ((view.annotation?.title)!)!)
            {
                POI = aPOI
            }
        }
        
        let url = URL(string: POI.image)
//        let data = try? Data(contentsOf: url!)
//        let image = UIImage(data: data!)
        self.navigationItem.title = (view.annotation?.title)!
        let monNumeroTel = POI.phone
        let monNomPlace = POI.name
        let lattitude = POI.latt
        let longitude = POI.long
        print("LALALLALALA" + POI.latt.description)
        if POI.latt == 43.5509 {
            print( "erreur")
        }else{
            myDetailsViewController.setImage(monImage: (url?.absoluteString)!, monNumero: monNumeroTel, monNom: monNomPlace, maLatt : lattitude, maLong : longitude)
            //myDetailsViewController.imageView.image = image
            self.navigationController?.pushViewController(myDetailsViewController, animated: true)
            NSLog("lala" + (url?.absoluteString)!)
            NSLog("LALLALALA", POI.id)

        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        let positionUser = MKPointAnnotation()
        
        positionUser.coordinate = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
        
        
        maMap.addAnnotation(positionUser)
        
        locationManager.stopUpdatingLocation()
        

        
    }


}
