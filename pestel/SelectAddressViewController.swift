//
//  SelectAddressViewController.swift
//  pestle
//
//  Created by Алексей on 06.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

private let markerZoom: Float = 17
private let cityZoom: Float = 10
private let defaultLatitude = 56.314578
private let defaultLongitude = 43.994579

class SelectAddressViewController: UIViewController {
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var continueButton: GoButton!
  @IBOutlet weak var searchView: UIView!

  var searchController: UISearchController? = nil
  let resultsViewController = GMSAutocompleteResultsViewController()
  let locationManager = CLLocationManager()
  let marker = GMSMarker()

  var address: (street: String, number: String)? = nil {
    didSet {
      guard let address = address else { return }
      searchController?.searchBar.text = "\(address.street), \(address.number)"
    }
  }

  var doneButtonHandler: (() -> Void)? = nil

  var coordinate: CLLocationCoordinate2D? = nil {
    didSet {
      guard let coordinate = coordinate else { return }
      continueButton.isEnabled = true
      marker.position = coordinate
      marker.map = mapView
      let cameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: markerZoom)
      mapView.animate(with: cameraUpdate)

      _ = ReverseGeocoder.getAdress(coordinate: coordinate).then { [weak self] address -> Void in
        guard let number = address?.streetNumber else { return }
        guard let streetName = address?.streetName else { return }
        self?.address = (street: streetName, number: number)
      }
    }
  }

  override func viewDidLoad() {
    continueButton.isEnabled = false
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconLocation"), style: .plain, target: self, action: #selector(SelectAddressViewController.myLocationButtonDidTap))
    configureMap()
    configureSearch()
    continueButton.setTitle("Выбрать", for: .normal)
  }

  func configureMap() {
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    mapView.isMyLocationEnabled = true
    marker.isDraggable = true
    marker.map = mapView

    guard let coordinate = ProfileManager.instance.currentCoordinate else { return }
    mapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: cityZoom)
  }

  func configureSearch() {
    definesPresentationContext = true
    resultsViewController.delegate = self
    searchController = UISearchController(searchResultsController: resultsViewController)
    searchController?.searchResultsUpdater = resultsViewController

    resultsViewController.extendedLayoutIncludesOpaqueBars = true
    searchController?.dimsBackgroundDuringPresentation = false
    resultsViewController.edgesForExtendedLayout = UIRectEdge([])

    searchController?.searchBar.sizeToFit()
    guard let searchBar = searchController?.searchBar else { return }
    searchView.addSubview(searchBar)
  }

  func myLocationButtonDidTap() {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL(string: "prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(URL(string: "prefs:root=LOCATION_SERVICES")!)
      }
    } else {
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      mapView.isMyLocationEnabled = true
    }
  }

  @IBAction func continueButtonDidTap(_ sender: GoButton) {
    doneButtonHandler?()
  }
}


extension SelectAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    self.coordinate = place.coordinate
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error) {
    let alertController = UIAlertController(title: NSLocalizedString("error", comment: "Error alert"), message: error.localizedDescription, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Error alert"), style: .default, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }


}

extension SelectAddressViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate

  }
}

extension SelectAddressViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    guard let coordinate = locations.first?.coordinate else { return }
    mapView.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: markerZoom))
    self.coordinate = coordinate
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
    locationManager.startUpdatingLocation()
  }
}
