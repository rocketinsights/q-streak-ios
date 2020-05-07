//
//  AddRecordViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    private let grey = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var submissionDateLabel: DatePickerLabel!

    @IBOutlet private weak var contactCountTextField: QTextField!

    @IBOutlet private weak var decrementNumberOfPeopleButton: QButton!

    @IBOutlet private weak var incrementNumberOfPeopleButton: QButton!

    @IBOutlet private weak var infoLabel: UILabel!

    @IBOutlet private weak var peopleLabel: UILabel!

    @IBOutlet private weak var saveButton: QButton!

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.saveButtonTapped(selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }

    @IBAction func decrementNumberOfPeopleButtonTapped(_ sender: Any) {
        viewModel.decrementedContactCount()
        updateCount()
    }

    @IBAction func incrementNumberOfPeopleButtonTapped(_ sender: Any) {
        viewModel.incrementedContactCount()
        updateCount()
    }

    @IBAction func contactCountTextFieldEditingChanged(_ sender: Any) {
        guard let contactCountString = contactCountTextField.text else { return }

        viewModel.setContactCount(contactCountString)
        updateCount()
    }

    @IBAction func datePickerTapGestureRecognizer(_ sender: Any) {
        submissionDateLabel.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Properties

    private var viewModel: AddRecordViewModel!

    // MARK: - Initializers

    static func initialize(viewModel: AddRecordViewModel) -> AddRecordViewController? {
        let addRecordViewControllerStoryboard = UIStoryboard(name: String(describing: AddRecordViewController.self), bundle: nil)
        let addRecordViewController = addRecordViewControllerStoryboard.instantiateInitialViewController() as? AddRecordViewController
        addRecordViewController?.viewModel = viewModel
        return addRecordViewController
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewModel()
        setUpViews()
        updateViews()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)

        if let presentationController = presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
    }

    // MARK: - Methods

    private func setUpViewModel() {
        viewModel.delegate = self
    }

    private func setUpViews() {
        addDoneButtonOnKeyboard()
        setUpTableView()
        setUpDatePicker()
    }

    private func setUpTableView() {
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
    }

    private func setUpDatePicker() {
        submissionDateLabel.delegate = self
        submissionDateLabel.selectedDate = viewModel.submissionDate
    }

    private func updateViews() {
        self.submissionDateLabel.text = "\(Calendar.current.isDateInToday(viewModel.submissionDate) ? "Today, " : "")\(viewModel.submissionDate.formattedDate(dateFormat: "EEEE MMMM d"))"

        infoLabel.isHidden = viewModel.submission == nil ? false: true

        updateCount()

        tableView.reloadData()

        if let submission = viewModel.submission {
            for submissionDestination in submission.destinations {
                for (index, destination) in viewModel.categories.enumerated() where submissionDestination?.slug == destination.slug {
                    tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
                }
            }
        }

        saveButton.setTitle(viewModel.submission == nil ? "Save" : "Update", for: .normal)
    }

    private func updateCount() {
        contactCountTextField.text = "\(viewModel.currentContactCount)"

        peopleLabel.text = viewModel.currentContactCount == 1 ? "person" : "people"

        decrementNumberOfPeopleButton.isEnabled = viewModel.currentContactCount > 0 ? true : false
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        contactCountTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        contactCountTextField.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddRecordViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityCell
        // swiftlint:enable force_cast

        cell.activityCellLabel?.text = viewModel.categories[indexPath.row].name

        let imageName = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false ? "squareCheckboxChecked" : "squareCheckboxUnchecked"
        cell.setImageAs(imageName: imageName)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // swiftlint:disable force_cast
        let cell = tableView.cellForRow(at: indexPath) as! ActivityCell
        // swiftlint:enable force_cast
        cell.setImageAs(imageName: "squareCheckboxChecked")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // swiftlint:disable force_cast
        let cell = tableView.cellForRow(at: indexPath) as! ActivityCell
        // swiftlint:enable force_cast

        cell.setImageAs(imageName: "squareCheckboxUnchecked")
    }
}

// MARK: - AddRecordViewModelDelegate

extension AddRecordViewController: AddRecordViewModelDelegate {

    func retrievedDestinations() {
        DispatchQueue.main.async { [weak self] in self?.updateViews() }
    }

    func addedSubmission(_ submission: Submission) {
        DispatchQueue.main.async { [weak self] in
            let recordDetailViewController = (self?.presentingViewController as? UINavigationController)?.topViewController as? RecordDetailViewController
            recordDetailViewController?.viewModel.submissionDateString = submission.dateString
            self?.dismiss(animated: true, completion: nil)
        }
    }

    func failedSubmission(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }

    func retrievedSubmission() {
        DispatchQueue.main.async { [weak self] in self?.updateViews() }
    }
}

// MARK: - DatePickerLabelDelegate

extension AddRecordViewController: DatePickerLabelDelegate {

    func datePickerDismissed() {
        guard let datePicker = submissionDateLabel.inputView as? UIDatePicker else { return }

        viewModel.submissionDate = Calendar.current.startOfDay(for: datePicker.date)
    }
}
