//
//  ViewController.swift
//  Notes
//
//  Created by Владимир Втулкин on 24.09.2021.
//

import UIKit

class NotesViewController: UIViewController
{
	private let storeManager: IStoreManager
	
	private lazy var notesView: INotesView = NotesView(presenter: self.notesPresenter)
	
	private lazy var notesPresenter: NotesPresenter = {
		let presenter = NotesPresenter(storeManager: self.storeManager)
		presenter.didSelectCellHandler = { [weak self] note in
			self?.callNoteViewController(note)
		}
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
		super.viewDidLoad()
		self.view = self.notesView as? UIView
		self.notesPresenter.didLoad(view: self.notesView)
		self.navigationItem.title = Localization.Note.NotesVCNavTitle
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTap))
	}

	private func callNoteViewController(_ note: NoteModel) {
		let viewController = NoteDetailViewController(storeManager: self.storeManager, note: note)
		self.navigationController?.pushViewController(viewController, animated: true)
	}

	@objc private func addButtonTap() {
		let viewController = AddNoteViewController(storeManager: self.storeManager)
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
