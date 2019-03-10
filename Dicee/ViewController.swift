//
//  ViewController.swift
//  Dicee
//
//  Created by Masterson, Evan on 22/12/2018.
//  Copyright © 2018 Masterson, Evan. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {

  @IBOutlet var bannerView: GADBannerView!
  @IBOutlet weak var leftDiceImageView: UIImageView!
  @IBOutlet weak var rightDiceImageView: UIImageView!
  @IBOutlet weak var middleDiceImageView: UIImageView!
  @IBOutlet weak var changeDiceBtn: UIButton!
  @IBOutlet weak var soundBtn: UIButton!
  var switchState: Bool = false
  var soundOn: Bool = true
  let speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer.init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBannerView()
    checkSoundState()
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    rollDice()
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }

  func rollDice() {
    if switchState {
      let rollMiddle = Int.random(in: 1...6)
      animateDice(imageView: middleDiceImageView, newImage: "dice\(rollMiddle)")
      speak(string: String(rollMiddle))
    } else {
      let rollLeft = Int.random(in: 1...6)
      let rollRight = Int.random(in: 1...6)
      animateDice(imageView: leftDiceImageView, newImage: "dice\(rollLeft)")
      animateDice(imageView: rightDiceImageView, newImage: "dice\(rollRight)")
      speak(string: String(rollLeft + rollRight))
    }
  }
  
  func animateDice(imageView: UIImageView, newImage: String) {
    UIView.transition(with: imageView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
      imageView.image = UIImage(named: newImage)
    }, completion: nil)
  }
  
  func speak(string: String) {
    if soundOn {
      speechSynthesizer.speak(AVSpeechUtterance(string: "You rolled \(string)"))
    }
  }
  
  func checkSoundState() {
    soundOn = UserDefaults.standard.bool(forKey: "sound")
    if soundOn {
      soundBtn.setImage(UIImage(named: "soundOn"), for: .normal)
    } else {
      soundBtn.setImage(UIImage(named: "soundOff"), for: .normal)
    }
  }
  
  func setupBannerView() {
    bannerView.adUnitID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_AD_UNIT_ID") as? String
    bannerView.rootViewController = self
    bannerView.load(GADRequest())
  }
  
  @IBAction func didTapRoll(_ sender: UIButton) {
    rollDice()
  }
  
  @IBAction func didTapChangeDice(_ sender: UIButton) {
    switchState = !switchState
    if switchState {
      changeDiceBtn.setTitle("Two Dice", for: .normal)
      leftDiceImageView.isHidden = true
      rightDiceImageView.isHidden = true
      middleDiceImageView.isHidden = false
    } else {
      changeDiceBtn.setTitle("One Dice", for: .normal)
      leftDiceImageView.isHidden = false
      rightDiceImageView.isHidden = false
      middleDiceImageView.isHidden = true
    }
  }
  
  @IBAction func didTapSound(_ sender: UIButton) {
    UserDefaults.standard.set(!soundOn, forKey: "sound")
    checkSoundState()
  }
}

