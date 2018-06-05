//
//  ViewController.swift
//  Project25
//
//  Created by Administrator on 6/4/18.
//  Copyright © 2018 SmartApps. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

	var images = [UIImage]()
	
	var peerID: MCPeerID!
	var mcSession: MCSession!
	var mcAdvertiserAssistant: MCAdvertiserAssistant!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Selfie Share"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
		
		peerID = MCPeerID(displayName: UIDevice.current.name)
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		mcSession.delegate = self
		
	}

	
	@objc func showConnectionPrompt() {
		
		let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
		ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
		
	}
	
	
	@objc func startHosting(action: UIAlertAction) {
		
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant.start()
		
	}
	
	
	@objc func joinSession(action: UIAlertAction) {
		
		let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
		
	}
	
	
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
		
	}
	
	
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
		
	}
	
	
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
		dismiss(animated: true)
	}
	
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
		case MCSessionState.connected:
			print("Connected: \(peerID.displayName)")
			
		case MCSessionState.connecting:
			print("Connecting: \(peerID.displayName)")
			
		case MCSessionState.notConnected:
			print("Not Connected: \(peerID.displayName)")
		}
	}
	
	
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		if let image = UIImage(data: data) {
			DispatchQueue.main.async { [unowned self] in
				self.images.insert(image, at: 0)
				self.collectionView?.reloadData()
			}
		}
	}
	
	
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		
	}
	
	
	@objc func importPicture() {
		
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
		
	}
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
		
		dismiss(animated: true)
		
		images.insert(image, at: 0)
		collectionView?.reloadData()
		
		//Check if there are any peers to send to.
		if mcSession.connectedPeers.count > 0 {
			
			//Convert the new image to a Data object.
			if let imageData = UIImagePNGRepresentation(image) {
				//Send to all peers, ensuring it gets delivered.
				do {
					try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
				} catch {
					let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					present(ac, animated: true)
				}
			}
		}
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
		
		if let imageView = cell.viewWithTag(1000) as? UIImageView {
			imageView.image = images[indexPath.item]
		}
		
		return cell
		
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

