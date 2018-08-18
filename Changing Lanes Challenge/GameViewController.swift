//
//  GameViewController.swift
//  Changing Lanes Challenge
//
//  Created by Andy Gray on 17/08/2018.
//  Copyright © 2018 Andy Gray. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {

    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        interstitial = createAndLoadInterstitial()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func playAd()
    {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
            interstitial = createAndLoadInterstitial()
        }
        //return interstitial
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial
    {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8250698761734487/1627780162")
        interstitial.delegate = self
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        interstitial = createAndLoadInterstitial()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
