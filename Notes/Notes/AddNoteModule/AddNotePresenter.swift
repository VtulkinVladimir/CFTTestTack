//
//  AddNotePresenter.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

import UIKit

class AddNotePresenter
{
	private let storeManager: IStoreManager
	
	private weak var view: IAddNote?

	init(storeManager: IStoreManager) {
		self.storeManager = storeManager
	}

	func didLoad(view: IAddNote, doneUi: INoteAddUi) {
		self.view = view
		self.view?.configureAsAdd()
		doneUi.doneButtonTapHandler = { [weak self] in
			self?.addNote()
		}
	}

	func addNote() {
		guard let changes = self.view?.getContent() else { return }
		if changes.0.isEmpty && changes.1 == nil {
			return
		}
		let note = NoteModel(text: changes.0, image: changes.1)
		self.storeManager.add(note: note)
	}
}
