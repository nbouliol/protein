//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/28/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit
import SceneKit

class ProteinViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    var ligVal : String? = ""
    var pdbFile : String? = ""
    var Atoms : [Atom] = []
    
    var geometryNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngle: Float = 0.0

    func loadNparse() {
        let Url = "http://ligand-expo.rcsb.org/reports/\(ligVal![ligVal!.index(ligVal!.startIndex, offsetBy: 0)])/\(ligVal!)/\(ligVal!)_ideal.pdb"
        
        // Start background thread so that image loading does not make app unresponsive
        guard let myURL = URL(string: Url) else {
            print("Error: \(Url) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            //            print("HTML : \(myHTMLString)")
            pdbFile = myHTMLString
            let parser = Parser(pdb: pdbFile!)
            parser.parse()
            self.Atoms = parser.atoms
            print(parser.lines[0])
            print(parser.atoms[0])
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNparse()
        
        print(self.Atoms)
        
        testLabel.text = ligVal!
        sceneSetup()
        geometryNode = self.allAtoms()
        sceneView.scene!.rootNode.addChildNode(geometryNode)
        sceneView.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var testLabel: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func panGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view!)
        var newAngle = (Float)(translation.x)*(Float)(M_PI)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(gesture.state == UIGestureRecognizerState.ended) {
            currentAngle = newAngle
        }
    }
//    https://www.raywenderlich.com/83748/beginning-scene-kit-tutorial
    
    func atom(color: UIColor) -> SCNGeometry {
        let at = SCNSphere(radius: 1)
        at.firstMaterial!.diffuse.contents = color
        at.firstMaterial?.specular.contents = color == .white ? UIColor.darkGray : UIColor.white
        return at
    }
    
    func allAtoms() -> SCNNode {
        let atomsNode = SCNNode()
        
        let carbonNode = SCNNode(geometry: atom(color: .red))
        carbonNode.position = SCNVector3Make(-6, 1, 5)
        atomsNode.addChildNode(carbonNode)
        
        let hydrogenNode = SCNNode(geometry: atom(color: .blue))
        hydrogenNode.position = SCNVector3Make(-2, 2, 0)
        atomsNode.addChildNode(hydrogenNode)
        
        let oxygenNode = SCNNode(geometry: atom(color: .alkaliniMetals))
        oxygenNode.position = SCNVector3Make(+2, 3, 0)
        atomsNode.addChildNode(oxygenNode)
        
        let fluorineNode = SCNNode(geometry: atom(color: .boron))
        fluorineNode.position = SCNVector3Make(+6, 4, 0)
        atomsNode.addChildNode(fluorineNode)

        for atom in self.Atoms {
            print("caca")
            let at = SCNNode(geometry: self.atom(color: atom.color))
            at.position = SCNVector3Make(atom.coordinates[0], atom.coordinates[1], atom.coordinates[2])
            print(at)
            atomsNode.addChildNode(at)
        }
        
        return atomsNode
    }
    
    func sceneSetup() {
        // 1
        let scene = SCNScene()
        
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
//
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
//
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3Make(0, 0, 25)
//        scene.rootNode.addChildNode(cameraNode)
        // 2
        
//        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
//        let boxNode = SCNNode(geometry: boxGeometry)
//        scene.rootNode.addChildNode(boxNode)
//        
//        
//        geometryNode = boxNode
        
//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
//        sceneView.addGestureRecognizer(panRecognizer)
        // 3
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true

    }
    
  /*  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let Url = "http://ligand-expo.rcsb.org/reports/\(ligVal![ligVal!.index(ligVal!.startIndex, offsetBy: 0)])/\(ligVal!)/\(ligVal!)_ideal.pdb"
        
        // Start background thread so that image loading does not make app unresponsive
        guard let myURL = URL(string: Url) else {
            print("Error: \(Url) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//            print("HTML : \(myHTMLString)")
            pdbFile = myHTMLString
            let parser = Parser(pdb: pdbFile!)
            parser.parse()
            self.Atoms = parser.atoms
            print(parser.lines[0])
            print(parser.atoms[0])
        } catch let error {
            print("Error: \(error)")
        }
    }*/

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
