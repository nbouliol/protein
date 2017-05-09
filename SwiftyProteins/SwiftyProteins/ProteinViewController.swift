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
    var animate : Bool = false
    var connections : [Connection] = []
    var camera : SCNNode = SCNNode()
    
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
    @IBAction func liaisonButton(_ sender: UIButton) {
        let Url = "https://files.rcsb.org/ligands/view/\(ligVal!)_ideal.sdf"
        
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
            self.connections = Parser.covalent(sdf: pdbFile!)
        } catch let error {
            ft_alert(title: "Error", msg: "\(ligVal!) cannot be found", dismiss: "Go back", style: .destructive, backSegue: true)
            print("Error: \(error)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //            performSegue(withIdentifier: "backSegue", sender: self)
        }
        geometryNode.removeFromParentNode()
        geometryNode = self.allAtoms(ballnstick: bns, hydrogen: hydrogens)
        sceneView.scene!.rootNode.addChildNode(geometryNode)
        sender.isHidden = true
        setAnimButtonsAsDefault()
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
//            print(parser.lines[0])
//            print(parser.atoms[0])
        } catch let error {
            if self.listViewCtrl != nil {
                DispatchQueue.main.async {
                    self.listViewCtrl!.liguands.remove(at: self.listViewCtrl!.liguands.index(of: self.ligVal!)!)
                    self.listViewCtrl!.listOfLiguands.reloadData()
                }
            }
            ft_alert(title: "Error", msg: "\(ligVal!) cannot be found", dismiss: "Go back", style: .destructive, backSegue: true)
            print("Error: \(error)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            performSegue(withIdentifier: "backSegue", sender: self)
        }
    }
    
    var listViewCtrl : ListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewCtrls = self.navigationController?.viewControllers
        let count = viewCtrls?.count
        if count != nil && count! > 1 {
            if let listCtrl = viewCtrls?[count! - 2] as? ListViewController {
                listViewCtrl = listCtrl

                listCtrl.searchActive = false
                listCtrl.searchResult = []
                listCtrl.listOfLiguands.reloadData()
                
                listCtrl.searchBar.text = nil
                listCtrl.searchBar.setShowsCancelButton(false, animated: false)
                
                // Remove focus from the search bar.
                listCtrl.searchBar.endEditing(true)
            }
        }
        
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
//                showAtom.backgroundColor = .white
                showAtom.layer.shadowOffset = CGSize(width: 0, height: 0)
                showAtom.layer.shadowColor = UIColor.white.cgColor
                showAtom.layer.shadowOpacity = 1
                showAtom.layer.shadowRadius = 3
            } else {
                showAtom.text = ""
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
    
    func allAtoms(ballnstick: Bool = true, hydrogen: Bool = true) -> SCNNode {
        let atomsNode = SCNNode()

        
        for i in 0..<self.Atoms.count {
            if !hydrogens && self.Atoms[i].name == "Hydrogen" {
                continue
            }
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

        if connections.isEmpty {
            for co in atom.connections {
                let from = atom
                let to = Atoms[co - 1]
                if !hydrogens && (from.name == "Hydrogen" || to.name == "Hydrogen")  {
                    continue
                }
                let cyl = CylinderLine(parent: cylindersNode, v1: (from.node?.position)!, v2: (to.node?.position)!, radius: 0.1, radSegmentCount: 180, color: UIColor.lightGray)
                cylindersNode.addChildNode(cyl)

            }
        } else {
            for co in connections {
                let from = Atoms[co.from - 1]
                let to = Atoms[co.to - 1]
                if !hydrogens && (from.name == "Hydrogen" || to.name == "Hydrogen")  {
                    continue
                }
                let cyl = CylinderLine(parent: cylindersNode, v1: (from.node?.position)!, v2: (to.node?.position)!, radius: 0.1, radSegmentCount: 180, color: UIColor.lightGray, connection: co.number)
                cylindersNode.addChildNode(cyl)
            }
        }
        }
        
        
        return cylindersNode
    }
    
    func setAnimButtonsAsDefault() {
        cycleButt.isHidden = false
        stopAnimButton.isHidden = true
    }
    
    @IBOutlet weak var cycleButt: UIButton!
    @IBAction func cycleButton(_ sender: UIButton) {
//        SCNTransaction.begin()
//        let materials = geometryNode.geometry?.materials
//        let material = materials?[0]
//        material?.diffuse.contents = UIColor.white
//        SCNTransaction.commit()
        
//        let action = SCNAction.moveBy(x: 0, y: 5, z: 5, duration: 5)
        let action = SCNAction.rotateBy(x: 1, y: 2, z: 3, duration: 5)
        let forever = SCNAction.repeatForever(action)
        geometryNode.runAction(forever, forKey: "loopAction")
//        animate = true
        stopAnimButton.isHidden = false
        sender.isHidden = true
    }
    @IBOutlet weak var stopAnimButton: UIButton!
    @IBAction func stopAnim(_ sender: UIButton) {
        geometryNode.action(forKey: "loopAction")?.speed = 0
        sender.isHidden = true
        cycleButt.isHidden = false
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

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 50)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
//        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0: // baals & stick
            geometryNode.removeFromParentNode()
            geometryNode = self.allAtoms()
            bns = true
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            setAnimButtonsAsDefault()
            break
        case 1:
            geometryNode.removeFromParentNode()
            geometryNode = self.allAtoms(ballnstick: false)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            bns = false
            setAnimButtonsAsDefault()
            break
        default :
            
            geometryNode = self.allAtoms()
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            break
        }
    }
    var hydrogens : Bool = true
    var bns : Bool = true
    @IBAction func hydeHydro(_ sender: UIButton) {
        hydrogens = !hydrogens
        geometryNode.removeFromParentNode()
        geometryNode = self.allAtoms(ballnstick: bns, hydrogen: false)
        sceneView.scene!.rootNode.addChildNode(geometryNode)
        setAnimButtonsAsDefault()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backSegue" {
            if let view = segue.destination as? ListViewController {
                print("caca")
                view.liguands = view.liguands.filter() { $0 != ligVal! }
                print(view.liguands[0])
                view.listOfLiguands.reloadData()
            }
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
        color: UIColor,
        connection: Int = 1)// Color of the cylinder
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
        
        if (connection == 2) {
            nodeCyl.position.x = -0.2
            
            let nodeCyl2 = SCNNode(geometry: cyl)
            nodeCyl2.position.y = -height/2
            nodeCyl2.position.x = 0.2
            zAlign.addChildNode(nodeCyl2)
        } else if (connection == 3) {
            nodeCyl.position.x = -0.07
            nodeCyl.position.z = -0.07
            
            let nodeCyl2 = SCNNode(geometry: cyl)
            nodeCyl2.position.y = -height/2
            nodeCyl2.position.x = 0.07
            nodeCyl2.position.z = -0.07
            let nodeCyl3 = SCNNode(geometry: cyl)
            nodeCyl3.position.y = -height/2
            nodeCyl3.position.z = 0.07
            
            zAlign.addChildNode(nodeCyl2)
            zAlign.addChildNode(nodeCyl3)
        }
        
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

extension UIViewController {
    func ft_alert(title : String, msg : String, dismiss : String, style: UIAlertActionStyle = .default, backSegue:Bool=false) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if backSegue {
            alert.addAction(UIAlertAction(title: dismiss, style: style, handler: {(alert: UIAlertAction!) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.performSegue(withIdentifier: "backSegue", sender: self)
            }))
        } else {
            alert.addAction(UIAlertAction(title: dismiss, style: style, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
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
