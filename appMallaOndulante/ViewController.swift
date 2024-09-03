//
//  ViewController.swift
//  appMallaOndulante
//
//  Created by braulio on 07/06/24.
//  Copyright © 2024 braulio. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!

    func sinFunction(x: Float, z: Float) -> Float {
        return 0.2 * sin(x * 5 + z * 3) + 0.1 * cos(x * 5 + z * 10 + 0.6) + 0.05 * cos(x * x * z)
    }

    func squareFunction(x: Float, z: Float) -> Float {
        return x * x + z * z
    }

    let gridSize = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        dibujaMalla()
    }

    func dibujaMalla() {
        // Crear la escena
        let sceneView = SCNView(frame: self.imagen.bounds) // Asegurarse de que el frame sea el correcto
        self.imagen.addSubview(sceneView)

        let scene = SCNScene()
        sceneView.scene = scene

        // Configurar la cámara
        let camara = SCNCamera()
        let camaraNodo = SCNNode()
        camaraNodo.camera = camara
        camaraNodo.position = SCNVector3(x: 0, y: 3, z: 10) // Ajustar la posición de la cámara
        scene.rootNode.addChildNode(camaraNodo)

        let capsuleRadius: CGFloat = 1.0 / CGFloat(gridSize - 1)
        let capsuleHeight: CGFloat = capsuleRadius * 4.0
        var z: Float = Float(-gridSize / 2) * Float(capsuleRadius) * 2.0

        for _ in 0..<gridSize {
            var x: Float = Float(-gridSize / 2) * Float(capsuleRadius) * 2.0
            for _ in 0..<gridSize {
                let capsule = SCNCapsule(capRadius: capsuleRadius, height: capsuleHeight)
                let hue = CGFloat(abs(x * z))
                let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                capsule.firstMaterial?.diffuse.contents = color

                let capsuleNode = SCNNode(geometry: capsule)
                capsuleNode.position = SCNVector3Make(x, 0.0, z)

                let y = CGFloat(squareFunction(x: x, z: z))
                //let y = CGFloat(sinFunction(x: x, z: z))

                let moveUp = SCNAction.moveBy(x: 0, y: y, z: 0, duration: 1.0)
                let moveDown = SCNAction.moveBy(x: 0, y: -y, z: 0, duration: 1.0)
                let sequence = SCNAction.sequence([moveUp, moveDown])
                let repeatedSequence = SCNAction.repeatForever(sequence)
                capsuleNode.runAction(repeatedSequence)

                scene.rootNode.addChildNode(capsuleNode)

                x += 2.0 * Float(capsuleRadius)
            }
            z += 2.0 * Float(capsuleRadius)
        }
        
        // Crear la esfera
              let sphere = SCNSphere(radius: 0.5)
              let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: 0, y: 0.5, z: 0)
              sphere.firstMaterial?.diffuse.contents = UIColor.red
               scene.rootNode.addChildNode(sphereNode)

               // Agregar acción de rebote a la esfera
               let moveUp = SCNAction.moveBy(x: 0, y: 5, z: 0, duration: 1.0)
               let moveDown = SCNAction.moveBy(x: 0, y: -5, z: 0, duration: 1.0)
              let bounceSequence = SCNAction.sequence([moveUp, moveDown])
               let repeatBounce = SCNAction.repeatForever(bounceSequence)
               sphereNode.runAction(repeatBounce)


        // Configurar el SCNView
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = UIColor.black
    }
}
