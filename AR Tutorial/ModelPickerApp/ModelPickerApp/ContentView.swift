//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by Jaejun Shin on 27/6/2022.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    private var models: [Model] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else { return [] }
        
        var availableModels = [Model]()
        for fileName in files where fileName.hasSuffix("usdz") {
            let modelName = fileName.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelname: modelName)
            availableModels.append(model)
        }
        
        return availableModels
    }()
    
    @State private var showingPlacementButtons = false
    @State private var selectedModel: Model?
    @State private var confirmedSelectedModel: Model?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(confirmedModelForPlacement: $confirmedSelectedModel)
            
            if showingPlacementButtons {
                PlacementButtonsView(showingPlacementButtons: $showingPlacementButtons,
                                     selectedModel: $selectedModel,
                                     confirmedSelectedModel: $confirmedSelectedModel)
            } else {
                ModelPickerView(showingPlacementButtons: $showingPlacementButtons,
                                selectedModel: $selectedModel,
                                models: models)
            }
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var confirmedModelForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = CustomARView(frame: .zero)
                
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.confirmedModelForPlacement {
            
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to the scene: \(model)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("unable to load model entity")
            }
            
            DispatchQueue.main.async {
                self.confirmedModelForPlacement = nil
            }
        }
    }
    
}

class CustomARView: ARView {
    let focusSquare = FESquare()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focusSquare.viewDelegate = self
        focusSquare.delegate = self
        focusSquare.setAutoUpdate(to: true)
        
        self.setUpARView()
    }
    
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpARView () {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
}

extension CustomARView: FEDelegate {
    func toTrackingState() {
        print("tracking")
    }
    
    func toInitializingState() {
        print("initializing")
    }
}

struct ModelPickerView: View {
    @Binding var showingPlacementButtons: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0..<self.models.count) { index in
                    Button {
                        print("\(self.models[index].modelName)")
                        self.selectedModel = models[index]
                        self.showingPlacementButtons = true
                    } label: {
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonsView: View {
    @Binding var showingPlacementButtons: Bool
    @Binding var selectedModel: Model?
    @Binding var confirmedSelectedModel: Model?
    
    var body: some View {
        HStack {
            Button {
                print("Cancel pressed")
                placementButtonAction()
            } label: {
                Image(systemName: "xmark")
                    .frame(width:60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button {
                print("Confirm pressed")
                confirmedSelectedModel = selectedModel
                placementButtonAction()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width:60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }

        }
    }
    func placementButtonAction() {
        self.selectedModel = nil
        self.showingPlacementButtons = false
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
