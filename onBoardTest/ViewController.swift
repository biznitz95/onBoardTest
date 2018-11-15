//
//  ViewController.swift
//  onBoardTest
//
//  Created by Bizet Rodriguez on 11/14/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import SwiftyOnboard
import ChameleonFramework
import Lottie

class ViewController: UIViewController {
    
    var swiftyOnboard: SwiftyOnboard!
    let colors: [UIColor] = [UIColor.flatSkyBlue, UIColor.flatLime, UIColor.flatYellowDark, UIColor.flatRed, UIColor.flatMint]
    let titles: [String] = ["Welcome to Appy!", "The Add Button", "Deleting", "Searching", "Start!"]
    let subTitles: [String] = ["Let's show you how things work!", "This button let's you add Groups, Categories and Items!", "This is how you delete stuff", "This is used to search for any type", "Are you a new user?"]
    let images: [String] = ["space1", "space2", "space3", "space4", "blue"]
    let animations: [String] = ["world", "star_success_", "teamwork", "message", "world"]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor.blue.cgColor
        let purple = UIColor.purple.cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [blue, purple]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient()
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: titles.count, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
}

extension ViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return titles.count
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
//        view.imageView.image = UIImage(named: images[index])
//        view.imageView.contentMode = .center
        
        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        let height = CGFloat(200)
        let width = CGFloat(200)
        
        let xPos = (viewWidth) + (height/2.0)
        let yPos = (viewHeight) + (height/1.0)
        
        
        var animationView = LOTAnimationView(filePath: animations[index])
        animationView.setAnimation(named: animations[index])
        animationView.loopAnimation = true
        animationView.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        view.addSubview(animationView)
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "Lato-Heavy", size: 22)
        view.subTitle.font = UIFont(name: "Lato-Regular", size: 16)
        
        //Set the text in the page:
        view.title.text = titles[index]
        view.subTitle.text = subTitles[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "Lato-Heavy", size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }

}
