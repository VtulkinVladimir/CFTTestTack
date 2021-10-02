//
//  StoreManager.swift
//  Notes
//
//  Created by Владимир Втулкин on 24.09.2021.
//

import CoreData

protocol IStoreManager
{
	func addListner(_ listner: IListner)
	func add(note: NoteModel)
	func edit(note: NoteModel)
	func retrive() -> [NoteModel]
	func delete(_ note: NoteModel)
}

class StoreManager: IStoreManager
{
	private let listnersManager = ListnersManager()
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Notes")
		container.loadPersistentStores {(storeDescription, error) in
			if let error = error as NSError? {
				assertionFailure("Error \(error.localizedDescription)")
			}
		}
		return container
	}()
	
	private lazy var viewContext: NSManagedObjectContext = {
		return self.persistentContainer.viewContext
	}()

	func addListner(_ listner: IListner) {
		self.listnersManager.addListners(listner)
	}
	
	func add(note: NoteModel) {
		let newNote = Note(context: self.viewContext)
		newNote.text = note.text
		newNote.id = note.id
		newNote.image = note.image?.jpegData(compressionQuality: 1)

		self.saveContext()
		self.listnersManager.needReload()
	}
	
	func delete(_ note: NoteModel) {
		guard let noteDB = self.findNote(with: note.id) else { return }
		self.viewContext.delete(noteDB)
		
		self.saveContext()
		self.listnersManager.needReload()
	}

	func edit(note: NoteModel) {
		guard let noteDB = self.findNote(with: note.id) else { return }
		noteDB.text = note.text
		noteDB.image = note.image?.jpegData(compressionQuality: 1)
		
		self.saveContext()
		self.listnersManager.needReload()
	}

	func retrive() -> [NoteModel] {
		var notes = [Note]()
		do {
			notes = try self.viewContext.fetch(Note.fetchRequest())
		} catch {
			assertionFailure("Error \(error.localizedDescription)")
		}
		let notesModel = notes.compactMap { NoteModel(note: $0) }
		return notesModel
	}

	private func findNote(with id: UUID) -> Note? {
		do {
			let predicate = NSPredicate(format: "id == %@", id as CVarArg)
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
			request.predicate = predicate
			let notes = try self.viewContext.fetch(request)
			if let noteDB = notes.first as? Note {
				return noteDB
			}
		} catch {
			assertionFailure("Error \(error.localizedDescription)")
		}
		return nil
	}

	private func saveContext () {
		do {
			try self.viewContext.save()
		} catch {
			let nserror = error as NSError
			assertionFailure("Error \(nserror.localizedDescription)")
		}
	}
}
