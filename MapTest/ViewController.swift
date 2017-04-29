//
//  ViewController.swift
//  MapTest
//
//  Created by d-point on 8/2/1438 AH.
//  Copyright © 1438 edever. All rights reserved.
//

import UIKit
import MapKit


struct AnnotationData {
    var Latitude:Double!
    var Longtitude:Double!
    var Value:Int!
}

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var Annotations:[AnnotationData] = []
    
    @IBOutlet weak var InformationLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.showsUserLocation = true
        mapView.delegate = self
        LoadAnnotations()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func SetAnnoteColor(Value: Int) -> UIImage {
        switch Value {
        case 390...392:
            return #imageLiteral(resourceName: "Blue")
        case 393...395:
            return #imageLiteral(resourceName: "Cyan")
        case 396...398:
            return #imageLiteral(resourceName: "HighCyan")
        case 399...402:
            return #imageLiteral(resourceName: "Green")
        case 403...420:
            return #imageLiteral(resourceName: "Yellow")
        case 421...470:
            return #imageLiteral(resourceName: "Orange")
        case 471...600:
            return #imageLiteral(resourceName: "Red")
        default:
            return #imageLiteral(resourceName: "Black")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annview = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annview.image = SetAnnoteColor(Value: Int(annotation.title!!)!)
        annview.canShowCallout = true
        
        return annview

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let ValueString = annotation.title!!
            let valueInt = Int(ValueString)!
            var MyText = ""
            switch valueInt {
            case 390...392:
                MyText = "Your Life is safe here."
            case 393...395:
                MyText = "Air is fresh, live your life."
            case 396...398:
                MyText = "the Air is great, very suitable for living."
            case 399...402:
                MyText = "No threats, You are in work environment. You should take a walk around in the garden"
            case 403...420:
                MyText = "The air is polluted, you should plant some plants around"
            case 421...470:
                MyText = "Threaten, the air if very polluted. Please inform the authority now and run away"
            case 471...600:
                MyText = "Dangerous Area, leave now"
            default:
                MyText = "You can not live here"
            }
            InformationLabel.text = "CO2 = \(ValueString), \(MyText)"
        }
    }
    
    func LoadAnnotations() {
        Annotations.removeAll(keepingCapacity: false)
        let MainDomain = "http://co2maps.m1a1r.com/api/"
        let session = URLSession.shared
        var task = URLSessionDownloadTask()
        
        let url:URL! = URL(string: MainDomain + "GetMapDetails")
        task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let JsonObjects = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Array<Any>
                    DispatchQueue.main.async {

                    print(JsonObjects as Any)
                        if JsonObjects?.count == 0 {
                            print("No Test Points Found")
                            return
                        }
                    for index in 0...(JsonObjects?.count)!-1 {
                        
                        var Annote = AnnotationData()
                        let CurrentObject = JsonObjects?[index] as! Dictionary<String,Any>
                        Annote.Latitude = Double(CurrentObject["Latitude"] as! String)
                        Annote.Longtitude = Double(CurrentObject["Longtitude"] as! String)
                        Annote.Value = CurrentObject["Value"] as! Int
                        self.Annotations.append(Annote)
                        print(Annote)
                        let annotation = MKPointAnnotation()
                        annotation.title = String(Annote.Value)
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Annote.Latitude, longitude: Annote.Longtitude)
                        self.mapView.addAnnotation(annotation)
                        
                    }
                    
                    }
                    
                }catch{
                    print("something went wrong, try again")
                }
            }
        })
        task.resume()
    }
    
    
    


}

