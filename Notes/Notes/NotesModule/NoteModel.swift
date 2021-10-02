//
//  NoteModel.swift
//  Notes
//
//  Created by Владимир Втулкин on 24.09.2021.
//
import Foundation
import UIKit

class NoteModel
{
	let id: UUID
	var text: String
	var image: UIImage?
	
	init(text: String, image: UIImage? = nil) {
		self.text = text
		self.id = UUID()
		self.image = image
	}

	init(note: Note) {
		self.text = note.text
		self.id = note.id
		if let imageData = note.image {
			let image = UIImage(data: imageData)
			self.image = image
		}
	}
}
