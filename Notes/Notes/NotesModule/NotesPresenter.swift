//
//  NotesPresenter.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

import UIKit

class NotesPresenter: IListner
{
	var didSelectCellHandler: ((NoteModel) -> Void)?

	private let storeManager: IStoreManager

	private var notes: [NoteModel]? {
		didSet {
			self.view?.reload()
		}
	}

	private weak var view: INotesView?

	init(storeManager: IStoreManager) {
		self.storeManager = storeManager
		storeManager.addListner(self)
		self.getNotes()
	}

	func didLoad(view: INotesView) {
		self.view = view
		self.view?.didDeleteCellHandler = { [weak self] index in
			self?.deleteNote(at: index)
		}
	}

	func numberOfRows() -> Int {
		guard let notes = self.notes else { return 0 }
		return notes.count
	}

	func notify() {
		self.getNotes()
	}

	func configureCell(index: Int) -> UITableViewCell {
		guard let notes = self.notes else { return UITableViewCell() }
		let note = notes[index]
		let cell = UITableViewCell.init(style: .default, reuseIdentifier: "NoteCell")
		cell.textLabel?.text = note.text
		return cell
	}

	func didSelectCell(at index: Int) {
		guard let notes = self.notes else { return }
		let note = notes[index]
		self.didSelectCellHandler?(note)
	}
	
	func deleteNote(at index: Int) {
		guard let notes = self.notes else { return }
		let note = notes[index]
		self.storeManager.delete(note)
	}

	private func getNotes() {
		self.notes = self.storeManager.retrive()
	}
}
