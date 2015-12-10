//
//  ViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    //starts map overlooking Pyrenees
    let initialLocation = CLLocation(latitude: 42.988566, longitude: 0.460573)
    
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    
    var garonneOverlay:MKPolygon!
    
    
    
    // MARK: - location manager to authorize user location for Maps app
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(initialLocation)
        checkLocationAuthorizationStatus()
        
        
        
        var coordsGaronne: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2DMake(43.30343225870785, 0.5996895362299814),
            CLLocationCoordinate2DMake(43.13114632727472, 0.4735406605249715),
            CLLocationCoordinate2DMake(43.01179237131475, 0.6144920457147984),
            CLLocationCoordinate2DMake(42.86666750519025, 0.4664504110596246),
            CLLocationCoordinate2DMake(42.70476430440321, 0.4694242354839573),
            CLLocationCoordinate2DMake(42.7023444464383, 0.6724293954056981),
            CLLocationCoordinate2DMake(42.82627047245492, 0.6722285925662019),
            CLLocationCoordinate2DMake(42.82062394943355, 0.862425175772441),
            CLLocationCoordinate2DMake(43.13132577569904, 1.049065884288642),
            CLLocationCoordinate2DMake(43.28454888824196, 1.282866070213431),
            CLLocationCoordinate2DMake(43.4135923420815, 0.8489902909390712)
            ]
        
        
        let addSpot = UILongPressGestureRecognizer(target: self, action: "action:")
        addSpot.minimumPressDuration = 1
        mapView.addGestureRecognizer(addSpot)
        
       
        
        mapView.delegate = self
        
        let polygon2 = MKPolygon(coordinates: &coordsGaronne, count: coordsGaronne.count)
        
        mapView.addOverlay(polygon2)
        
        
    }
    
    let regionRadius: CLLocationDistance = 200000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsCompass = true
        mapView.showsScale = true
    }
    
    
   
    
    func action(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            self.pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = newCoordinate
            pointAnnotation.title = "New Place Added"
            pointAnnotation.subtitle = "click i to add details"
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
            print(pointAnnotation.coordinate)
            
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let identifier = "PinDetails"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = true
        let btn = UIButton(type: .DetailDisclosure)
        annotationView!.rightCalloutAccessoryView = btn
        
        //adding this create the push segue immediately, but still does not send the lat/long values
        //self.performSegueWithIdentifier("UserInfo", sender: self)
        
        return annotationView
        
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "PinDetails") {
            
            let yourNextViewController = segue.destinationViewController as! PlacesDetailViewController
            
                yourNextViewController.placeLatitude = (pointAnnotation.coordinate.latitude)
                yourNextViewController.placeLongitude = (pointAnnotation.coordinate.longitude)
            
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("PinDetails", sender: self)
            
        }
    }
    
    func colorMap(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        
        
        if (overlay is MKPolygon) {
            
            let pr1 = MKPolygonRenderer(overlay: overlay)
            pr1.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
            pr1.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            pr1.lineWidth = 0.5
            return pr1
            }
        return nil
        }
    
    
}

