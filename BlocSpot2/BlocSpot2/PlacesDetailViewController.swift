//
//  PlacesDetailViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation


class PlacesDetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var detailMapView: MKMapView!
    
    @IBOutlet weak var placeLong: UILabel!
    @IBOutlet weak var placeLat: UILabel!
    
    //var newPlace = [NSManagedObject]()
    
    let newPlace = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var placeLongitude = Double()
    var placeLatitude = Double()
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    var inititalLocation:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    

    
    @IBOutlet weak var notesLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startingLocation = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude)
        
        centerMapOnLocation(startingLocation)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude)
        dropPin.title = "NewPlace"
        detailMapView.addAnnotation(dropPin)
        detailMapView.delegate = self
        
        print(placeLatitude)
        print(placeLongitude)
        
        placeLat.text = "Latitude \(placeLatitude)"
        placeLong.text = "Longitude \(placeLongitude)"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //want to get the map to center on the place chosen in previous window
    
    let regionRadius: CLLocationDistance = 100000
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
       let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D.init(latitude: placeLatitude, longitude: placeLongitude),
            regionRadius * 1.5 , regionRadius * 1.5)
        detailMapView.setRegion(coordinateRegion, animated: true)
        detailMapView.showsCompass = true
        detailMapView.showsScale = true
    }

    
    @IBAction func savePlaceDetails(sender: AnyObject) {
        
        //when this is clicked, it saves this data AND the lat and long data as Core Data
        
        let placeDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: newPlace)

        let place = Places(entity: placeDescription!, insertIntoManagedObjectContext:  newPlace)

        place.name = nameLabel.text
        place.location = locationLabel.text
        place.longitude = placeLongitude
        place.latitude = placeLongitude
        
        print(place.name)
        print(place.location)
        
        do {
            try place.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        

}

    
       
        
    }

