// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
public struct DeadlinePickerView: View {
    @Binding var isDeadlineEnabled: Bool
    @Binding var deadline: Date?
    @State private var showDatePicker: Bool = false
    
    public init(isDeadlineEnabled: Binding<Bool>, deadline: Binding<Date?>) {
        self._isDeadlineEnabled = isDeadlineEnabled
        self._deadline = deadline
    }
    
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                        .foregroundColor(.primary)
                    if isDeadlineEnabled {
                        Button(action: {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }, label: {
                            Text(deadline ?? Date().addingTimeInterval(86400), style: .date)
                                .foregroundColor(.blue)
                                .font(.system(size: 13))
                        })
                    }
                }
                
                Spacer()
                Toggle("", isOn: $isDeadlineEnabled)
                    .labelsHidden()
                    .onChange(of: isDeadlineEnabled) { value in
                        withAnimation {
                            if value {
                                if deadline == nil {
                                    deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                                }
                            } else {
                                showDatePicker = false
                            }
                        }
                    }
            }
            .padding()
            
            if showDatePicker && isDeadlineEnabled {
                Divider()
                    .transition(.opacity)
                DatePicker(
                    "Выберите дату",
                    selection: Binding($deadline, replacingNilWith: Date()),
                    displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.default, value: showDatePicker)
    }
}

@available(iOS 13.0, *)
extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

