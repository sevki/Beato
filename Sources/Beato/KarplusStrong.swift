//
//  KarplusStrong.swift
//  Beato
//
//  Karplus-Strong algorithm for guitar-like sound synthesis
//  Reference: https://github.com/timiskhakov/music/blob/master/karplusstrong/basic.go
//

import Foundation

/// KarplusStrong synthesizer implements the Karplus-Strong algorithm for plucked string synthesis.
/// This creates realistic guitar-like sounds by using noise and a feedback delay line.
public struct KarplusStrong: Synthesizer {
    /// The sample rate in Hz (e.g., 44100)
    public let sampleRate: Double

    /// Duration of each note in seconds
    public let noteDuration: Double

    public init(sampleRate: Double = 44100.0, noteDuration: Double = 1.0) {
        self.sampleRate = sampleRate
        self.noteDuration = noteDuration
    }

    /// Synthesizes a single frequency using the Karplus-Strong algorithm
    /// - Parameters:
    ///   - frequency: The frequency to synthesize in Hz
    ///   - duration: The duration in seconds
    /// - Returns: An array of audio samples
    public func synthesize(frequency: Double, duration: Double) -> [Float] {
        // Create initial noise buffer with length equal to the period
        let bufferSize = Int(sampleRate / frequency)
        let noise = (0 ..< bufferSize).map { _ in
            Float.random(in: -1.0...1.0)
        }

        // Generate samples for the specified duration
        let sampleCount = Int(sampleRate * duration)
        var samples = noise
        samples.reserveCapacity(sampleCount)

        // Apply the Karplus-Strong algorithm: average adjacent samples
        for i in bufferSize ..< sampleCount {
            let average = (samples[i - bufferSize] + samples[i - bufferSize + 1]) / 2.0
            samples.append(average * 0.996) // Apply slight damping
        }

        return Array(samples.prefix(sampleCount))
    }

    /// Synthesizes a track of pitches
    /// - Parameter track: The track containing pitches to synthesize
    /// - Throws: Any errors during synthesis
    public func synth(_ track: Track) throws {
        var allSamples: [Float] = []

        for pitch in track {
            let samples = synthesize(frequency: pitch.wrappedValue, duration: noteDuration)
            allSamples.append(contentsOf: samples)
        }

        // For now, we just generate the samples. In a future version,
        // this could write to a file or play through audio output.
        // The samples are in allSamples array.
    }
}
