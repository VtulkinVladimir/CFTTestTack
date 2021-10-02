//
//  Listners.swift
//  Notes
//
//  Created by Владимир Втулкин on 25.09.2021.
//

protocol IListner
{
	func notify()
}

class ListnersManager
{
	private var listners = [IListner]()
	
	deinit {
		self.listners.removeAll()
	}

	func addListners(_ listner: IListner) {
		self.listners.append(listner)
	}

	func needReload() {
		self.listners.forEach {
			$0.notify()
		}
	}
	
}
