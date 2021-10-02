//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//
import UIKit

protocol INoteEditUI: AnyObject
{
	var doneButtonTapHandler: (() -> Void)? { get set }
}

class NoteDetailViewController: UIViewController
{
	var doneButtonTapHandler: (() -> Void)?

	private let presenter: NotePresenter

	private lazy var ui: IEditNote = {
		let view = NoteView()
		view.imageButtonTapHandler = { [weak self] in
			self?.callImagePicker()
		}
		return view
	}()

	init(storeManager: IStoreManager, note: NoteModel) {
		self.presenter = NotePresenter(storeManager: storeManager, note: note)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view = self.ui.rootView
		self.presenter.didLoad(view: self.ui, doneUI: self)
		self.navigationItem.largeTitleDisplayMode = .never
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTap))
	}

	@objc private func doneButtonTap() {
		self.doneButtonTapHandler?()
		self.navigationController?.popViewController(animated: true)
	}

	private func callImagePicker() {
		let vc = UIImagePickerController()
		vc.delegate = self
		vc.allowsEditing = true
		self.navigationController?.present(vc, animated: true, completion: nil)
	}
}

extension NoteDetailViewController: INoteEditUI
{
}

extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
		DispatchQueue.main.async {
			self.ui.set(image: image)
		}
		self.dismiss(animated: true, completion: nil)
	}
}
