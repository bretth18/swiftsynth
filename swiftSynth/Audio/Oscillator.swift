//
//  Oscillator.swift
//  swiftSynth
//
//  Created by BrettOld on 10/24/19.
//  Copyright © 2019 bretth18. All rights reserved.
//

import Foundation

// MARK: enum
enum Waveform: Int {
    
    case sine, triangle, sawtooth, square, whiteNoise
}


struct Oscillator {
    
    static var amplitude: Float = 1
    static var frequency: Float = 440
    


    
    
    // MARK: Sine wave
    
    // since is a periodic function of time with a period equal to 2*pi / b, where b is the factor that time or x is being multiplied by before being passed into the function
    static let sine = { (time: Float) -> Float in
        return Oscillator.amplitude * sin(2.0 * Float.pi * Oscillator.frequency * time)
    }
    
    
    // MARK: Triangle wave
    
    // wave is separated into 3 parts: initial incline, turning point and latter incline.
    // period of triangle wave is first calulated by dividing one by Oscillator frequency.
    
    static let triangle = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        let value = currentTime / period
        
        var result = 0.0
        
        if value < 0.25 {
            result = value * 4
        } else if value < 0.75 {
            result = 2.0 - (value * 4.0)
        } else {
            result = value * 4 - 4.0
        }
        
        return Oscillator.amplitude * Float(result)
    }
    
    
    // MARK: sawtooth wave
    
    static let sawtooth = { (time: Float) -> Float in
        let period = 1.0 / Oscillator.frequency
        let currentTime = fmod(Double(time), Double(period))
        return Oscillator.amplitude * ((Float(currentTime) / period) * 2 - 1.0)
    }
    
    
    // MARK: square wave
    
    static let square = { (time: Float) -> Float in
        let period = 1.0 / Double(Oscillator.frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? Oscillator.amplitude: -1.0 * Oscillator.amplitude
    }
    
    
    // MARK: white noise
    
    // White noise oscillator is just random float sample values
    static let whiteNoise = { (time: Float) -> Float in
        return Oscillator.amplitude * Float.random(in: -1...1)          // swift 4.2 random in static method
    }
}
