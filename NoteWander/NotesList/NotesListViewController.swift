//
//  NotesListViewController.swift
//  NoteWander
//
//  Created by Manas Mishra on 14/04/18.
//  Copyright © 2018 manas. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewNoteList: UITableView!
    
    let viewModel = NoteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.delegate = self
        viewModel.initializeFetchResultController()
        configureViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    private func configureViews() {
        self.view.alpha = 0.3
        activityIndicator.startAnimating()
        configureTableView()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewButtonClicked))
        self.navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    @objc func addNewButtonClicked() {
         pushNoteVC(true)
    }
    
    private func pushNoteVC(_ isNew: Bool, note: NoteMO? = nil) {
        let vc = NoteViewController(nibName: "NoteViewController", bundle: nil)
        vc.addNewNote = isNew
        vc.note = note
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func configureTableView() {
        tableViewNoteList.delegate = self
        tableViewNoteList.dataSource = self
        tableViewNoteList.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        tableViewNoteList.reloadData()
        self.view.alpha = 1
        self.activityIndicator.stopAnimating()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        cell.titleLabel.text = viewModel.getTitle(indexPath.row)
        cell.updatedLabel.text = viewModel.getUpdatedAt(indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       pushNoteVC(false, note: viewModel.notes[indexPath.row])
    }
    
}
extension NotesListViewController: NoteListViewModelDelegate {
    func updateNote(at indexPath: IndexPath) {
        tableViewNoteList.reloadRows(at: [indexPath], with: .fade)
    }
    
    func moveNote(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        tableViewNoteList.moveRow(at: fromIndexPath, to: toIndexPath)
        tableViewNoteList.reloadRows(at: [toIndexPath, fromIndexPath], with: .fade)
    }
    
    func deleteNote(at indexPath: IndexPath) {
        tableViewNoteList.deleteRows(at: [indexPath], with: .fade)
    }
    
    func insertNote(at indexPath: IndexPath) {
        tableViewNoteList.insertRows(at: [indexPath], with: .fade)
    }
    
}















