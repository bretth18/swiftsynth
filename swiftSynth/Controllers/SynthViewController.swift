//
//  SynthViewController.swift
//  swiftSynth
//
//  Created by BrettOld on 10/24/19.
//  Copyright © 2019 bretth18. All rights reserved.
//

import Foundation
import UIKit

class SynthViewController: UIViewController {
    // MARK: properties
    
    // UI Label for info text
    private lazy var parameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Frequency: 0 Hz  Amplitude: 0%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    

    
    
    private lazy var waveformSelectorSegmentedControl: UISegmentedControl = {
        var images = [ #imageLiteral(resourceName: "Sine Wave Icon"), #imageLiteral(resourceName: "Triangle Wave Icon"),  #imageLiteral(resourceName: "Sawtooth Wave Icon"),  #imageLiteral(resourceName: "Square Wave Icon"),  #imageLiteral(resourceName: "Noise Wave Icon")]
        images = images.map { $0.resizableImage(withCapInsets: .init(top: 0, left: 10, bottom: 0, right: 10), resizingMode: .stretch) }
        let segmentedControl = UISegmentedControl(items: images)
        segmentedControl.setContentPositionAdjustment(.zero, forSegmentType: .any, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(updateOscillatorWaveform), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    
    
    // MARK: VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
    }
    
    // MARK: selector functions
    
    
    // function to update oscillator waveform
    @objc private func updateOscillatorWaveform() {
        let waveform = Waveform(rawValue: waveformSelectorSegmentedControl.selectedSegmentIndex)!
        switch waveform {
            case .sine: Synth.shared.setWaveformTo(Oscillator.sine)
            case .triangle: Synth.shared.setWaveformTo(Oscillator.triangle)
            case .sawtooth: Synth.shared.setWaveformTo(Oscillator.sawtooth)
            case .square: Synth.shared.setWaveformTo(Oscillator.square)
            case .whiteNoise: Synth.shared.setWaveformTo(Oscillator.whiteNoise)
        }
    }
    
    @objc private func setPlaybackStateTo(_ state: Bool) {
        Synth.shared.volume = state ? 0.5 : 0
    }
    
    
    // MARK: touch functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(true)
        guard let touch = touches.first else { return }
        let coord = touch.location(in: view)
        setSynthParametersFrom(coord)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let coord = touch.location(in: view)
        setSynthParametersFrom(coord)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(false)
        // reset label on non contact/playback
        parameterLabel.text = "Frequency: 0 Hz  Amplitude 0%"
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(false)
        parameterLabel.text = "Frequency 0 Hz  Amplitude 0%"
    }
    
    
    // MARK: private functions
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        view.isMultipleTouchEnabled = false
    }
    
    private func setupSubviews() {
        view.addSubview(waveformSelectorSegmentedControl)
        view.addSubview(parameterLabel)
        NSLayoutConstraint.activate([ waveformSelectorSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), waveformSelectorSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10), waveformSelectorSegmentedControl.widthAnchor.constraint(equalToConstant: 250), parameterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10), parameterLabel.centerYAnchor.constraint(equalTo: waveformSelectorSegmentedControl.centerYAnchor, constant: 40)])
        
    }
    
    
    // setSynthParametersFrom
    
    private func setSynthParametersFrom(_ coord: CGPoint) {
        Oscillator.amplitude = Float((view.bounds.height - coord.y) / view.bounds.height)
        Oscillator.frequency = Float(coord.x / view.bounds.width) * 1014 + 32
        
        let amplitudePercent = Int(Oscillator.amplitude * 100)
        let frequencyHertz = Int(Oscillator.frequency)
        parameterLabel.text = "Frequency \(frequencyHertz) Hz  Amplitude: \(amplitudePercent)%"
    }
    
}
