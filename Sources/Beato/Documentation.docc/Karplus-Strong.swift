//
//  Karplus-Strong.swift
//
//
//  Created by Sevki Hasirci on 15/06/2022.
//

import Beato
import Foundation

struct KarplusStrong: Synthesizer {
    let sampleRate: Double
    let frequency: Double
    let duration: Double
}

// Go version of KS https://github.com/timiskhakov/music/blob/master/karplusstrong/basic.go
extension KarplusStrong {
    func synthesize() -> [Float] {
        let noise = (0 ..< Int(sampleRate / frequency)).map {
            Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max)
        }

        let samples = noise

        for i in noise.count ..< samples.count {
            samples[i] = (samples[i - noise.count] + samples[i - noise.count - 1]) / 2
        }
    }
}
