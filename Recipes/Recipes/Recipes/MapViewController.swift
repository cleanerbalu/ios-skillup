//
//  MapViewController.swift
//  Recipes
//
//  Created by Davit on 2.23.15.
//  Copyright (c) 2015 Davit. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var coord: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        if let crd = coord {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(crd, 1000, 1000), animated: true)
            let annot = MKPointAnnotation()
            annot.setCoordinate(crd)
            annot.title = NSLocalizedString("Here did you the recipe",  comment: "Annotation explanation")
            
            mapView.addAnnotation(annot)
            //mapView.mapType = MKMapType.
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = true
    }

    @IBAction func mapTypeChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.Standard
        case 1:
            mapView.mapType = MKMapType.Satellite
        case 2:
            mapView.mapType = MKMapType.Hybrid
        default:
            break
        }
    }
}