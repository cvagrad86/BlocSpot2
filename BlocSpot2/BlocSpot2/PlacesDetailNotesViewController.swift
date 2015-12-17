//
//  PlacesDetailNotesViewController.swift
//  BlocSpot2
//
//  Created by Eric Chamberlin on 12/11/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//
import UIKit
import CoreData
import MapKit
import CoreLocation


class PlacesDetailNotesViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    @IBOutlet weak var placeLongitudeLabel: UILabel!
    @IBOutlet weak var placeLatitudeLabel : UILabel!
    
    @IBOutlet weak var placeNotes: UITextView!
    
    var places: [Places]!
    var plNotes: [PlacesDetails]!
    
    var placeSelected:String?
    var placeLocation: String?
    var placeLongitude: Double!
    var placeLatitude: Double!
    var newPlaceNotes:String?
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var mapItemData:MKMapItem!
    var savedAnnotation:MKAnnotation!
    var inititalLocation:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    
    let sortKeyName   = "name"
    let sortKeyRating = "beerDetails.rating"
    let wbSortKey     = "wbSortKey"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchAllPlaces()
        //fetchAllNotes()
        
        placeLabel.text = placeSelected
        placeLocationLabel.text = placeLocation
        placeLongitudeLabel.text = "Long. \(placeLongitude)"
        placeLatitudeLabel.text = "Lat. \(placeLatitude)"
        
        let startingLocation = CLLocationCoordinate2DMake(placeLatitude, placeLongitude)
        
        centerMapOnLocation(startingLocation)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(placeLatitude, placeLongitude)
        dropPin.title = placeLabel.text
        dropPin.subtitle = placeLocationLabel.text
        
        placeMapView.addAnnotation(dropPin)
        placeMapView.delegate = self
        
        //if let notes = plNotes {
          //  placeNotes.text = plNotes.
        //} else {
           // plNotes = PlacesDetails.MR_createEntity() as PlacesDetails
            //plNotes.notes = ""
        //}


        
    }
    
    let regionRadius: CLLocationDistance = 100000
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D.init(latitude: placeLatitude, longitude: placeLongitude),
            regionRadius * 1.5 , regionRadius * 1.5)
        placeMapView.setRegion(coordinateRegion, animated: true)
        placeMapView.showsCompass = true
        placeMapView.showsScale = true
    
    }
    
    @IBAction func addPhotos(sender: UIBarButtonItem) {
        
        let picker = UIImagePickerController()
        picker.delegate=self
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        self.presentViewController(picker,
            animated: true,
            completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
        
    }
    
    @IBAction func takePhotos(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            let picker = UIImagePickerController()
            picker.delegate=self
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                animated: true,
                completion: nil)
        } else {
            noCamera()
        }
        
    }

    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .ScaleAspectFit //3
        myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true,
            completion: nil)
    }


    
    @IBAction func shareNote(sender: UIBarButtonItem) {
        
        let vc = UIActivityViewController(activityItems: [places], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    
    }
    
    @IBAction func saveNotes(sender: UIBarButtonItem) {
        
        
    }
   
    @IBAction func addNotes(sender: UIButton) {
        
        var inputTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add Notes", message: "Weather, animals, etc", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // Do whatever you want with inputTextField?.text
            print("\(inputTextField?.text)")
            self.placeNotes.text = inputTextField?.text
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
        }
        
        presentViewController(alertController, animated: true, completion: nil)
            
        }

    
  

   
    
    func fetchAllPlaces() {
        
        let sortKey = NSUserDefaults.standardUserDefaults().objectForKey(wbSortKey) as? String

        let ascending = (sortKey == sortKeyRating) ? false : true
        
        places = Places.MR_findAllSortedBy(sortKey, ascending: ascending) as! [Places]
        
        
    }
    
   
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        saveContext()
    
    }
    
    func saveContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }

    
    


}