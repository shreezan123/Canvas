//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Shrijan Aryal on 10/21/18.
//  Copyright © 2018 Shrijan Aryal. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
   
    override func viewDidLoad() {
        
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        
        if sender.state == .began{
            print ("beginning for tray")
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
            print ("changing for tray")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            if (velocity.y > 0){
                print ("moving tray up")
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
                self.downArrow.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI / 180))
                
            }
            else {
                print ("moving tray up")
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
                downArrow.transform = downArrow.transform.rotated(by: CGFloat(180 * M_PI / 180))
            }
        }
        
    }
    //pan gesture recognizer for smileys
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("moving face began")
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceOnCanvas(sender:)))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
            
            // Optionally set the number of required taps, e.g., 2 for a double click
            tapGestureRecognizer.numberOfTapsRequired = 2
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5,y: 1.5)
            
        } else if sender.state == .changed {
            print("face pos changing")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("face moving ended")
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1,y: 1)
        }
    }
    
    @objc func  didPanFaceOnCanvas(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            print ("debug: clicked on face")
            newlyCreatedFace = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
        }
    }
    @objc func didTap(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
}
