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
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBAction func shareNavButton(_ sender: Any) {
        // set up activity view controller
        let imageToShare = sceneView.snapshot()
        let defaultText = "I want to share with you this protein : \(ligVal!) - Generated with SwiftyProteins"
        let activityViewController = UIActivityViewController(activityItems: [imageToShare, defaultText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    func loadNparse() {
        let Url = "http://ligand-expo.rcsb.org/reports/\(ligVal![ligVal!.index(ligVal!.startIndex, offsetBy: 0)])/\(ligVal!)/\(ligVal!)_ideal.pdb"
        
        // Start background thread so that image loading does not make app unresponsive
        guard let myURL = URL(string: Url) else {
            print("Error: \(Url) doesn't seem to be a valid URL")
            return
        }
        
        do {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            //            print("HTML : \(myHTMLString)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

        navItem.title = ligVal!
        sceneSetup()
        geometryNode = self.allAtoms()
        sceneView.scene!.rootNode.addChildNode(geometryNode)
        sceneView.backgroundColor = .random()
        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        sceneView.addGestureRecognizer(tapRecognizer)
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
//    http://stackoverflow.com/questions/30190171/scenekit-object-between-two-points
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
                let at = SCNNode(geometry: self.atom(color: self.Atoms[i].color, size: 0.9))
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
            atomsNode.addChildNode(setCylinders(atomsNode: atomsNode))
        }
        
        return atomsNode
    }
    
    func setCylinders(atomsNode:SCNNode) -> SCNNode {
        let cylindersNode = SCNNode()
       for atom in self.Atoms {

            for co in atom.connections {
                let from = atom
                let to = Atoms[co - 1]
                
                let cyl = CylinderLine(parent: cylindersNode, v1: (from.node?.position)!, v2: (to.node?.position)!, radius: 0.1, radSegmentCount: 180, color: UIColor.lightGray)
                cylindersNode.addChildNode(cyl)

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
        omniLightNode.light!.color = UIColor(white: 1, alpha: 1.0)
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

class   CylinderLine: SCNNode
{
    init( parent: SCNNode,//Needed to line to your scene
        v1: SCNVector3,//Source
        v2: SCNVector3,//Destination
        radius: CGFloat,// Radius of the cylinder
        radSegmentCount: Int, // Number of faces of the cylinder
        color: UIColor )// Color of the cylinder
    {
        super.init()
        
        //Calcul the height of our line
        let  height = v1.distance(v2)
        
        //set position to v1 coordonate
        position = v1
        
        //Create the second node to draw direction vector
        let nodeV2 = SCNNode()
        
        //define his position
        nodeV2.position = v2
        //add it to parent
        parent.addChildNode(nodeV2)
        
        //Align Z axis
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float(CGFloat(M_PI_2))
        
        //create our cylinder
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
        cyl.radialSegmentCount = radSegmentCount
        cyl.firstMaterial?.diffuse.contents = color
        
        //Create node with cylinder
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = -height/2
        zAlign.addChildNode(nodeCyl)
        
        //Add it to child
        addChildNode(zAlign)
        
        //set constraint direction to our vector
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
