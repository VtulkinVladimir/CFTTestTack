//
//  NotesView.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

import UIKit
import SnapKit

protocol INotesView: AnyObject
{
	var didDeleteCellHandler: ((Int) -> Void)? { get set }
	func reload()
}

class NotesView: UIView
{
	var didDeleteCellHandler: ((Int) -> Void)?

	private let tableView: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		return table
	}()

	private var presenter: NotesPresenter

	init(presenter: NotesPresenter) {
		self.presenter = presenter
		super.init(frame: .zero)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func reload() {
		self.tableView.reloadData()
	}

	private func configure() {
		self.addSubview(tableView)
		tableView.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
	}
}

extension NotesView: UITableViewDelegate, UITableViewDataSource, INotesView
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter.numberOfRows()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.presenter.configureCell(index: indexPath.row)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
		self.presenter.didSelectCell(at: indexPath.row)
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: Localization.Note.NotesViewDeleteButtonTitle) { _, _, complete in
			self.didDeleteCellHandler?(indexPath.row)
			complete(true)
		}
		let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}
}
