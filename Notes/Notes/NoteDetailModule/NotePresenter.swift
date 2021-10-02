//
//  NotePresenter.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

class NotePresenter
{
	private let storeManager: IStoreManager
	private var note: NoteModel
	private weak var view: IEditNote?

	init(storeManager: IStoreManager, note: NoteModel) {
		self.storeManager = storeManager
		self.note = note
	}

	func didLoad(view: IEditNote, doneUI: INoteEditUI) {
		self.view = view
		self.view?.configureAsEdit(note: self.note)

		doneUI.doneButtonTapHandler = { [weak self] in
			self?.editingEnded()
		}
	}
	
	func editingEnded() {
		guard let changes = self.view?.getContent() else { return }
		var shouldUpdate = false
		if self.note.text != changes.0 {
			self.note.text = changes.0
			shouldUpdate = true
		}
		if self.note.image != changes.1 {
			self.note.image = changes.1
			shouldUpdate = true
		}
		
		if shouldUpdate {
			self.storeManager.edit(note: self.note)
		}
	}
}
