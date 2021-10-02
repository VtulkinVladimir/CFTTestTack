//
//  SceneDelegate.swift
//  Notes
//
//  Created by Владимир Втулкин on 24.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let storeManager: IStoreManager = StoreManager()
		let window = UIWindow(windowScene: scene)
		self.window = window
		let launchedBefore = UserDefaults()
		
		if !launchedBefore.bool(forKey: "launchedBefore") {
			let firstNote = NoteModel(text: Localization.Note.noteText, image: UIImage(named: "CFTLogo"))
			storeManager.add(note: firstNote)
			launchedBefore.set(true, forKey: "launchedBefore")
		}
		window.rootViewController = UINavigationController(rootViewController: NotesViewController(storeManager: storeManager))
		window.makeKeyAndVisible()
	}
}

