//
//  NoteListViewModel.swift
//  NoteWander
//
//  Created by Manas Mishra on 15/04/18.
//  Copyright © 2018 manas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol NoteListViewModelDelegate {
    func moveNote(fromIndexPath: IndexPath, toIndexPath: IndexPath)
    func deleteNote(at indexPath: IndexPath)
    func insertNote(at indexPath: IndexPath)
    func updateNote(at indexPath: IndexPath)
}

class NoteListViewModel: NSObject {
    
    var fetchResultController: NSFetchedResultsController<NoteMO>?
    var delegate: NoteListViewModelDelegate?
    let dateFormatter = DateFormatter()
    var notes: [NoteMO] {
        guard let noteArray = fetchResultController?.fetchedObjects else {return []}
        return noteArray
    }
    
    override init() {
        super.init()
        //initializeFetchResultController()
    }
    
    func getTitle(_ index: Int) -> String {
        let noteTitle = notes[index].title ?? ""
        return noteTitle
    }
    func getDescriptionOfNote(_ index: Int) -> String {
        let noteDesc = notes[index].noteDescription ?? ""
        return noteDesc
    }
    func getUpdatedAt(_ index: Int) -> String {
        guard let updatedDate = notes[index].updatedAt as Date? else {return ""}
        dateFormatter.dateFormat = DateFormatType(rawValue: "yyyy-MM-dd HH:mm:ss")?.rawValue
        return dateFormatter.string(from: updatedDate)
    }
}

extension NoteListViewModel: NSFetchedResultsControllerDelegate {
    func initializeFetchResultController() {
        let fetchRequest: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (appDelegate.persistentContainer.viewContext), sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController?.delegate = self
        do {
            try fetchResultController?.performFetch()
        } catch {
            print(error)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            delegate?.updateNote(at: indexPath!)
        case .insert:
            delegate?.insertNote(at: newIndexPath!)
        case .delete:
            delegate?.deleteNote(at: indexPath!)
        case .move:
            delegate?.moveNote(fromIndexPath: indexPath!, toIndexPath: newIndexPath!)
        }
    }
}


















