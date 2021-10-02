//
//  NoteView.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

import UIKit
import SnapKit

protocol IEditNote: AnyObject
{
	var rootView: UIView { get set }
	func getContent() -> (String, UIImage?)
	func configureAsEdit(note: NoteModel)
	func set(image: UIImage)
}

protocol IAddNote: AnyObject
{
	var rootView: UIView { get set }
	func getContent() -> (String, UIImage?)
	func configureAsAdd()
	func set(image: UIImage)
}

class NoteView: UIView, IEditNote, IAddNote
{
	var imageButtonTapHandler: (() -> Void)?
	var rootView = UIView()
	
	private let textView = UITextView()
	private var imageView = UIImageView()
	private var fontSize: CGFloat = 24
	
	init() {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configureAsEdit(note: NoteModel) {
		self.textView.text = note.text
		self.imageView.image = note.image
		self.configure()
	}
	
	func getContent() -> (String, UIImage?) {
		return (self.textView.text, self.imageView.image)
	}
	
	func configureAsAdd() {
		self.configure()
		self.textView.becomeFirstResponder()
	}
	
	func set(image: UIImage) {
		self.imageView.image = image
	}
	
	@objc private func addSizeBarButtonTap() {
		self.textView.font = .systemFont(ofSize: (self.fontSize + 10))
	}
	
	@objc private func doneBarButtonTap() {
		self.textView.resignFirstResponder()
	}
	
	@objc private func imageBarButtonTap() {
		self.imageButtonTapHandler?()
	}
	
	private func configure() {
		self.textView.font = .systemFont(ofSize: self.fontSize)
		self.textView.allowsEditingTextAttributes = true
		
		self.imageView.backgroundColor = .lightText
		self.imageView.contentMode = .scaleAspectFit
		
		self.rootView.addSubview(imageView)
		imageView.snp.makeConstraints { maker in
			maker.top.equalTo(self.rootView.safeAreaLayoutGuide.snp.topMargin)
			maker.centerX.equalToSuperview()
			maker.width.equalToSuperview()
			maker.height.equalTo(100)
		}
		
		self.rootView.addSubview(self.textView)
		textView.snp.makeConstraints { maker in
			maker.top.equalTo(imageView.snp.bottom)
			maker.bottom.equalToSuperview()
			maker.width.equalToSuperview()
			maker.centerX.equalToSuperview()
		}

		let toolBar = UIToolbar()
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let plusSize = UIBarButtonItem(title: "+10", style: .plain, target: self, action: #selector(self.addSizeBarButtonTap))
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBarButtonTap))
		let imageButton = UIBarButtonItem(title: "Image", style: .plain, target: self, action: #selector(self.imageBarButtonTap))
		
		toolBar.items = [flexibleSpace, plusSize, imageButton, doneButton]
		toolBar.sizeToFit()
		self.textView.inputAccessoryView = toolBar
	}
}
