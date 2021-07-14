//
//  CommonDefine.swift
//  ChickenVoiceRecognition
//
//  Created by Phineas.Huang on 05/02/2018.
//  Copyright © 2018 SunXiaoShan. All rights reserved.
//

import UIKit

// reference: https://www.flaticon.com
class CommonDefine: NSObject {
    private func getWaitChickenName() -> String {
        return "003-chicken-2"
    }
    
    private func getCommandChickenName() -> String {
        return "005-chicken"
    }
    private func wing() -> String {
        return "006-wing"
    }
    private func white() -> String {
        return "007-white"
    }
    private func layEggs() -> String {
        return "008-layEggs"
    }
    private func webbed_feet() -> String {
        return "009-webbed_feet"
    }
    private func carnivorous() -> String {
        return "010-carnivorous"
    }
    private func longnose() -> String {
        return "011-longnose"
    }
    private func fur() -> String {
        return "012-fur"
    }
    private func tame() -> String {
        return "013-tame"
    }
    private func fierce() -> String {
        return "014-fierce"
    }
    private func two() -> String {
        return "015-two"
    }
    private func four() -> String {
        return "016-four"
    }
    private func zero() -> String {
        return "017-zero"
    }
    private func herbivore() -> String {
        return "018-herbivore"
    }
    private func omnivores() -> String {
        return "019-omnivores"
    }
    private func fly() -> String {
        return "020-fly"
    }
    
    
    
    
    
    
    
    private func getImageView(_ name:String) -> UIImage {
        return UIImage(named: name)!
    }
    
    func getWaitChickenImage() -> UIImage {
        return getImageView(getWaitChickenName())
    }
    
    func getCommandChickenImage() -> UIImage {
        return getImageView(getCommandChickenName())
    }
    
    func getpythonImage() -> UIImage {
        return getImageView(wing())
    }
    
    func getwhiteImage() -> UIImage {
        return getImageView(white())
    }
    func getlayEggsImage() -> UIImage {
        return getImageView(layEggs())
    }
    func getwebbed_feetImage() -> UIImage {
        return getImageView(webbed_feet())
    }
    func getcarnivorousImage() -> UIImage {
        return getImageView(carnivorous())
    }
    func getlongnoseImage() -> UIImage {
        return getImageView(longnose())
    }
    func getfurImage() -> UIImage {
        return getImageView(fur())
    }
    func gettameImage() -> UIImage {
        return getImageView(tame())
    }
    func getfierceImage() -> UIImage {
        return getImageView(fierce())
    }
    func gettwoImage() -> UIImage {
        return getImageView(two())
    }
    func getfourImage() -> UIImage {
        return getImageView(four())
    }
    func getzeroImage() -> UIImage {
        return getImageView(zero())
    }
    func getherbivoreImage() -> UIImage {
        return getImageView(herbivore())
    }
    func getomnivoresImage() -> UIImage {
        return getImageView(omnivores())
    }
    func getflyImage() -> UIImage {
        return getImageView(fly())
    }
    
}
