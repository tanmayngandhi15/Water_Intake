//
//  WaterIntakeViewModel.swift
//  WaterIntake
//
//  Created by Tanmay N. Gandhi on 07/12/24.
//

import Foundation

enum SliderValues: Float {
    case minimum = 0.0
    case maximum = 3000.0
}

class WaterIntakeViewModel {
    
    // Provide slider configuration values
    var sliderMinValue: Float {
        return SliderValues.minimum.rawValue
    }
    
    var sliderMaxValue: Float {
        return SliderValues.maximum.rawValue
    }
}
