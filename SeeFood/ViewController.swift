//
//  ViewController.swift
//  SeeFood
//
//  Created by user on 27.08.2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("could not convert to CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Loading CIImage fail.") }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let resoults = request.results as? [VNClassificationObservation] else {fatalError("model fail to process image")
            }
            
            if let firstResout = resoults.first {
                if firstResout.identifier.contains("Hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not a hotdog!"
                }
                print(resoults)
            }
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        } catch {
            print("error performing request\(error)")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }

}

