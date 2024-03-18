//
//  AudioPlayService.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 18/03/24.
//

import Foundation
import AVFoundation

protocol AudioPlayerService {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerService {
    private var player: AVAudioPlayer?
    
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "click", ofType: "m4a") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        catch(let error) {
            print(error.localizedDescription)
        }
    }
}
