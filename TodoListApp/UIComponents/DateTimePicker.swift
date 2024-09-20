//
//  DateTimePicker.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class DateTimePicker: UIDatePicker {
    init(minimumDate: Date? = Date()){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = .current
        self.datePickerMode = .dateAndTime
        self.minimumDate = minimumDate
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.tintColor = .systemGreen
        self.preferredDatePickerStyle = .compact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
