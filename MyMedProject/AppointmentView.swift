import SwiftUI

struct AppointmentView: View {
    let doctorName: String
    
    // Пример дней (можно генерировать динамически)
    @State private var days: [Date] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: today)! }
    }()
    
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: String? = nil
    
    let timeSlots = ["09:00", "10:00", "11:00", "13:00", "15:00", "16:00", "17:00", "18:00", "19:00"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Запись к врачу \(doctorName)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Выбор даты
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(days, id: \.self) { day in
                        let dayNumber = Calendar.current.component(.day, from: day)
                        let weekday = Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: day)-1]
                        
                        Button(action: {
                            selectedDate = day
                            selectedTime = nil // сброс выбранного времени
                        }) {
                            VStack {
                                Text(weekday)
                                    .font(.subheadline)
                                Text("\(dayNumber)")
                                    .font(.headline)
                            }
                            .frame(width: 50, height: 50)
                            .background(Calendar.current.isDate(selectedDate, inSameDayAs: day) ? Color.blue : Color(.systemGray6))
                            .foregroundColor(Calendar.current.isDate(selectedDate, inSameDayAs: day) ? .white : .black)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Сетка времени
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 12)], spacing: 12) {
                ForEach(timeSlots, id: \.self) { slot in
                    Button(action: {
                        selectedTime = slot
                    }) {
                        Text(slot)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(selectedTime == slot ? Color.blue : Color(.systemGray6))
                            .foregroundColor(selectedTime == slot ? .white : .black)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Кнопка записи
            Button(action: {
                guard let time = selectedTime else { return }
                print("Записаны на \(selectedDate) в \(time)")
            }) {
                Text("Записаться")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTime == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .disabled(selectedTime == nil)
            
            Spacer()
        }
        .navigationTitle("Запись")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView(doctorName: "Аекина С.С.")
    }
}
