//
//  NoteViewController.swift
//  NoteWander
//
//  Created by Manas Mishra on 14/04/18.
//  Copyright © 2018 manas. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var addNewNote = false
    var note: NoteMO?

    @IBOutlet weak var noteDescriptionTV: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureVC() {
        addNavigationButton()
        noteDescriptionTV.delegate = self
        titleTF.delegate = self
        configureViews()
    }

    private func configureViews() {
        if addNewNote {return}
        titleTF.text = note?.title
        noteDescriptionTV.text = note?.noteDescription
    }
    private func addNavigationButton() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backButtonClicked))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        guard !addNewNote else { return }
        let saveButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteButtonClicked))
        self.navigationItem.setRightBarButton(saveButton, animated: true)
    }
    @objc func deleteButtonClicked() {
        self.view.alpha = 0.3
        self.activityIndicator.startAnimating()
        deleteNote()
    }
    @objc func backButtonClicked() {
        saveNote()
    }
    private func popVC() {
        DispatchQueue.main.async {
            self.view.alpha = 1
            self.activityIndicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func saveNote() {
        if (titleTF.text == "Untitled" && (noteDescriptionTV.text == "" || noteDescriptionTV.text == "Write Note")) {
            popVC()
            return
        }
        if (titleTF.text == note?.title) && (noteDescriptionTV.text == note?.noteDescription) {
            popVC()
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let moc = appDelegate.persistentContainer.viewContext
        guard let newNote = addNewNote ? NoteMO(context: moc) : note else {return}
        newNote.title = titleTF.text
        newNote.noteDescription = noteDescriptionTV.text
        newNote.updatedAt = Date() as NSDate
        DispatchQueue.global().async {
            do {
                 try moc.save()
            } catch {
                print(error)
            }
            self.popVC()
        }
    }
    private func deleteNote() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let moc = appDelegate.persistentContainer.viewContext
        moc.delete(note!)
        DispatchQueue.global().async {
            do {
                try moc.save()
            } catch {
                print(error)
            }
            self.popVC()
        }
    }

}

extension NoteViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty ?? false) {
            textField.text = "Untitled"
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "Untitled") {
            textField.text = ""
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Write Note") {
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count > 300 {
            return true
        }
        return false
    }
}







