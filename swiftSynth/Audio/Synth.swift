//
//  Synth.swift
//  swiftSynth
//
//  Created by BrettOld on 10/24/19.
//  Copyright © 2019 bretth18. All rights reserved.
//

import AVFoundation
import Foundation


// typealias def, takes one float to represent time and returns one float for audio sample
typealias Signal = (Float) -> (Float)

class Synth {
    
    // MARK: properties
    
    
    // make a singleton, shared static instance allowing access from any VC
    public static let shared = Synth()
    
    public var volume: Float {
        
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    
    // Private variable defs
    private var audioEngine: AVAudioEngine
    private var time: Float = 0
    private let sampleRate: Double
    // deltaTime is the duration each sample is held for
    private let deltaTime: Float
    
    // sourceNode definition
    private lazy var sourceNode = AVAudioSourceNode { (_, _, frameCount, audioBufferList) -> OSStatus in
        
        // audioBufferList holds an array of audio buffer structures to fill with our waveforms
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        
        // for loop to iterate through index values btwn 0 and frameCount
        for frame in 0..<Int(frameCount) {
            let sampleVal = self.signal(self.time)
            self.time += self.deltaTime
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
            }
        }
        // return no error if everything is good
        return noErr
    }
    
    private var signal: Signal
    
    // MARK: init
    
    init(signal: @escaping Signal = Oscillator.sine) {
        
        audioEngine = AVAudioEngine()
        
        // setup AVAudioEngine
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        
        
        self.signal = signal
        
        
        // set our AVAudioFormat
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        
        // attaching our nodes here
        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 0
        
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audioEngine: \(error.localizedDescription)")
        }
        
        
    }
    
    
    // MARK: public functions
    
    public func setWaveformTo(_ signal: @escaping Signal) {
        
        self.signal = signal
    }
}
