//
//  ProteinViewController.swift
//  SwiftyProteins
//
//  Created by Nicolas BOULIOL on 4/28/17.
//  Copyright © 2017 Nicolas BOULIOL. All rights reserved.
//

import UIKit
import SceneKit
import MessageUI

class ProteinViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    var ligVal : String? = ""
    var pdbFile : String? = ""
    var Atoms : [Atom] = []
    var printedAtom : String = ""
    @IBOutlet weak var showAtom: UILabel!
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
        
        testLabel.text = ligVal!
        sceneSetup()
        geometryNode = self.allAtoms()
        sceneView.scene!.rootNode.addChildNode(geometryNode)
        sceneView.backgroundColor = .random()
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        sceneView.addGestureRecognizer(tapRecognizer)
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
    
    func findAtomWithCoordinates(coords: [Float]) -> Atom? {
        for atom in self.Atoms {
            if atom.coordinates == coords {
                return atom
            }
        }
        return nil
    }
    
    func tapHandler(_ gesture: UITapGestureRecognizer) {
        print("TAPPED !")
        
        // check what nodes are tapped
        let p = gesture.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            print(result.node)
            // result.node is the node that the user tapped on
            // perform any actions you want on it
            if let tappedAtom = findAtomWithCoordinates(coords: [result.node.position.x, result.node.position.y, result.node.position.z]) {
                print(tappedAtom.name)
                showAtom.text = "Touched atom : \(tappedAtom.name)"
            }
        } else {
            showAtom.text = ""
        }
    }
    
//    https://www.raywenderlich.com/83748/beginning-scene-kit-tutorial
//    https://www.raywenderlich.com/128728/scene-kit-tutorial-swift-part-4-render-loop
    
    func atom(color: UIColor, size: Float) -> SCNGeometry {
        let at = SCNSphere(radius: CGFloat(size))
        at.firstMaterial!.diffuse.contents = color
        at.firstMaterial?.specular.contents = color == .white ? UIColor.darkGray : UIColor.white
        return at
    }
    
    func allAtoms(ballnstick: Bool = true) -> SCNNode {
        let atomsNode = SCNNode()

        for i in 0..<self.Atoms.count {
            if !ballnstick {
                let at = SCNNode(geometry: self.atom(color: self.Atoms[i].color, size: 1))
                at.position = SCNVector3Make(self.Atoms[i].coordinates[0], self.Atoms[i].coordinates[1], self.Atoms[i].coordinates[2])
                self.Atoms[i].node = at
                atomsNode.addChildNode(at)
            } else {
                let at = SCNNode(geometry: self.atom(color: self.Atoms[i].color, size: 0.5))
                at.position = SCNVector3Make(self.Atoms[i].coordinates[0], self.Atoms[i].coordinates[1] , self.Atoms[i].coordinates[2])
                self.Atoms[i].node = at
                atomsNode.addChildNode(at)
            }
        }
        if ballnstick {
            atomsNode.addChildNode(setCylinders())
        }
        
        return atomsNode
    }
    
    func setCylinders() -> SCNNode {
        let cylindersNode = SCNNode()
        for atom in self.Atoms {
            for co in atom.connections {
                let tmp = self.Atoms[co - 1].node!.position
                let cyl = SCNCylinder(radius: 0.1, height: CGFloat(atom.node!.position.distance(tmp)))
                let node = SCNNode(geometry: cyl)
                cylindersNode.addChildNode(node)
            }
        }
        return cylindersNode
    }
    
    func sceneSetup() {
        // 1
        let scene = SCNScene()
        
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)

        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0: // baals & stick
            geometryNode.removeFromParentNode()
            geometryNode = self.allAtoms()
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            break
        case 1:
            geometryNode.removeFromParentNode()
            geometryNode = self.allAtoms(ballnstick: false)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            break
        default :
            
            geometryNode = self.allAtoms()
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            break
        }
    }


}

private extension SCNVector3{
    func distance(_ receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
