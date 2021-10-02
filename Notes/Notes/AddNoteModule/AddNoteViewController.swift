//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

import UIKit

protocol INoteAddUi: AnyObject
{
	var doneButtonTapHandler: (() -> Void)? { get set }
}

class AddNoteViewController: UIViewController
{
	var doneButtonTapHandler: (() -> Void)?

	private let storeManager: IStoreManager

	private lazy var ui: IAddNote = {
		let ui = NoteView()
		ui.imageButtonTapHandler = { [weak self] in
			self?.callImagePicker()
		}
		return ui
	}()

	private lazy var presenter: AddNotePresenter = {
		let presenter = AddNotePresenter(storeManager: self.storeManager)
		return presenter
	}()

	init(storeManager: IStoreManager) {
		self.storeManager = storeManager
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		self.view = self.ui.rootView
		self.presenter.didLoad(view: self.ui, doneUi: self)
		self.navigationItem.largeTitleDisplayMode = .never
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTap))
	}

	private func callImagePicker() {
		let vc = UIImagePickerController()
		vc.delegate = self
		vc.allowsEditing = true
		self.navigationController?.present(vc, animated: true, completion: nil)
	}

	@objc private func doneButtonTap() {
		self.doneButtonTapHandler?()
		self.navigationController?.popViewController(animated: true)
	}
}

extension AddNoteViewController: INoteAddUi
{
}

extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			DispatchQueue.main.async {
				self.ui.set(image: image)
			}
		}
		self.dismiss(animated: true, completion: nil)
	}
}
