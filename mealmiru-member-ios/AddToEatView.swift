//
//  AddToEatView.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/05.
//

import SwiftUI

struct AddToEatView: View {
    @EnvironmentObject private var session: AppSession
    @Environment(\.dismiss) private var dismiss
    @Binding var items: [ToEatItem]

    @State private var text = ""
    @State private var hasExpDate = false
    @State private var expDate: Date? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Food name", text: $text)
                
                Section() {
                    Toggle(isOn: $hasExpDate) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Exp. date")
                                
                                if let expDate {
                                    Text(expDate, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .onChange(of: hasExpDate) {_, isOn in
                        expDate = isOn ? Date() : nil
                    }
                    
                    if hasExpDate, let expDate {
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { expDate },
                                set: { self.expDate = $0 }
                            ),
                            displayedComponents: .date
                        ) .datePickerStyle(.graphical)
                        .labelsHidden()
                    }
                }
            }
            .navigationTitle("Add To Eat")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard !text.isEmpty else { return }

                        
                        Task {
                            await session.createToEat(
                                name: text,
                                expDate: hasExpDate ? expDate : nil
                            )
                            
                            items.append(
                                ToEatItem(
                                    name: text,
                                    expDate: hasExpDate ? expDate : nil
                                )
                            )
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                        .disabled(text.isEmpty)
                    }
                
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark"
                        )
                    }
                }
            }
        }
    }
}
