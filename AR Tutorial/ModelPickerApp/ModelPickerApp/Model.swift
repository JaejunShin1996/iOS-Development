//
//  Model.swift
//  ModelPickerApp
//
//  Created by Jaejun Shin on 29/6/2022.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellabel: AnyCancellable? = nil
    
    init(modelname: String) {
        self.modelName = modelname
        
        self.image = UIImage(named: modelname)!
        
        let filename = modelname + ".usdz"
        self.cancellabel = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                print("DEBUG: Unable to load modelEntity with filename: \(filename)")
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("DEBUG: Successful to load modelEntity with filename: \(filename)")
            })
    }
}
