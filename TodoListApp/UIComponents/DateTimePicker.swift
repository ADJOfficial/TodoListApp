//
//  DateTimePicker.swift
//  TodoListApp
//
//  Created by ADJ on 14/07/2024.
//

import UIKit

class DateTimePicker: UIDatePicker {
    init(){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.locale = Locale(identifier: "en_US")
        self.minimumDate = Date()
//        self.minimumDate = timeZone
        self.preferredDatePickerStyle = .compact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
