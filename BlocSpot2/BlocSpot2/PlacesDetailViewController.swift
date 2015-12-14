//
//  PlacesDetailViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/3/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

import UIKit
import MapKit
//import CoreData
import CoreLocation




class PlacesDetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var placeLong: UILabel!
    @IBOutlet weak var placeLat: UILabel!
    
    var currentPlace: Places!
    
    //var newPlace = [NSManagedObject]()
    
    //let newPlace = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var placeLongitude = Double()
    var placeLatitude = Double()
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    var inititalLocation:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    var pickerDataSource = ["Pyrénées Atlantique", "Haute Pyrenees", "Haute Garonne", "Ariege", "Andorra", "Pyrénées Orientales"];
    
    //@IBOutlet weak var notesLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    //@IBOutlet weak var locationLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let place = currentPlace {
            // A place exists.  EDIT Mode.
            
        } else {
            // A place does NOT exist.  ADD Mode.
            
            currentPlace = Places.MR_createEntity() as Places
            currentPlace.name = ""
        }
        
        let startingLocation = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude)
        
        centerMapOnLocation(startingLocation)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude)
        dropPin.title = "Lat. \(placeLatitude)"
        detailMapView.addAnnotation(dropPin)
        detailMapView.delegate = self
        
        print(placeLatitude)
        print(placeLongitude)
        
        //placeLat.text = "Lat. \(placeLatitude)"
        //placeLong.text = "Long. \(placeLongitude)"
        
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
       
        if currentPlace.name == "" {
            title = "New Place"
        } else {
            title = currentPlace.name
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(true)
        
        //------------------------------------------
        
        nameLabel.resignFirstResponder()
        
        
        saveContext()
        
       
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        currentPlace.location = "\(pickerDataSource[row])"
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
        if nameLabel.text != "" {
        currentPlace.name = nameLabel.text!
        currentPlace.longitude = placeLongitude
        currentPlace.latitude = placeLatitude
            
       }
        
        print(currentPlace.latitude)
        print(currentPlace.longitude)
        print(currentPlace.name)
        print(currentPlace.location)
        
}

    
       
        
    }

extension PlacesDetailViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text != "" {
            self.title       = nameLabel.text
            currentPlace.name = nameLabel.text!
        }
    }
    
}

