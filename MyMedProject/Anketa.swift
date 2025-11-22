import SwiftUI
import FirebaseAuth

struct AnketaView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    // Личные данные
    @State private var fullName = ""
    @State private var iin = ""
    @State private var gender = "Мужской"
    let genders = ["Мужской", "Женский"]
    @State private var dateOfBirth = Date()
    
    // Контакт
    @State private var phone = "+7"
    @State private var selectedCity = ""
    let cities = ["Астана", "Алматы", "Караганда", "Шымкент", "Актобе", "Тараз", "Павлодар", "Усть-Каменогорск", "Костанай", "Кызылорда"]

    // Физические данные
    @State private var height = ""
    @State private var weight = ""
    @State private var systolic = ""
    @State private var diastolic = ""
    @State private var pulse = ""
    
    // Вредные привычки
    @State private var habitsSmoking = false
    @State private var habitsAlcohol = false
    @State private var habitsCaffeine = false
    @State private var habitsOther = false
    @State private var habitsOtherText = ""
    
    // Аллергии и хронические заболевания
    @State private var allergies: [String] = [""]
    @State private var chronicDiseases: [String] = [""]
    
    @State private var showEmptyNameAlert = false
    @State private var showSavedAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - ЛИЧНЫЕ ДАННЫЕ
                        card {
                            sectionTitle("Личные данные")
                            customField("ФИО", text: $fullName)
                            customField("ИИН", text: $iin)
                            DatePicker("Дата рождения", selection: $dateOfBirth, displayedComponents: .date)
                            Picker("Пол", selection: $gender) {
                                ForEach(genders, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // MARK: - КОНТАКТ
                        card {
                            sectionTitle("Контактная информация")
                            customField("Телефон", text: $phone)
                                .keyboardType(.phonePad)
                            
                            VStack(alignment: .leading) {
                                Text("Город")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Menu {
                                    ForEach(cities, id: \.self) { city in
                                        Button(city) { selectedCity = city }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCity.isEmpty ? "Выберите город" : selectedCity)
                                            .foregroundColor(selectedCity.isEmpty ? .gray : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                            }
                        }

                        // MARK: - ФИЗИЧЕСКИЕ ДАННЫЕ
                        card {
                            sectionTitle("Физические данные")
                            HStack {
                                customField("Рост (см)", text: $height)
                                    .keyboardType(.numberPad)
                                customField("Вес (кг)", text: $weight)
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                customField("Систолическое давление", text: $systolic)
                                    .keyboardType(.numberPad)
                                customField("Диастолическое давление", text: $diastolic)
                                    .keyboardType(.numberPad)
                            }
                            HStack {
                                customField("Пульс", text: $pulse)
                                    .keyboardType(.numberPad)
                                Spacer()
                            }
                        }
                        
                        // MARK: - ВРЕДНЫЕ ПРИВЫЧКИ
                        card {
                            sectionTitle("Вредные привычки")
                            Toggle("Курение", isOn: $habitsSmoking)
                            Toggle("Алкоголь", isOn: $habitsAlcohol)
                            Toggle("Кофеин", isOn: $habitsCaffeine)
                            Toggle("Другое", isOn: $habitsOther)
                            
                            if habitsOther {
                                TextField("Укажите другие привычки", text: $habitsOtherText)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.leading, 4)
                            }
                        }
                        
                        // MARK: - АЛЛЕРГИИ
                        card {
                            sectionTitle("Аллергии")
                            Text("Пример: цитрус, трава")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            ForEach(allergies.indices, id: \.self) { i in
                                customField("Аллергия \(i+1)", text: $allergies[i])
                            }
                            
                            Button("+ Добавить аллергию") {
                                allergies.append("")
                            }
                            .foregroundColor(.blue)
                        }
                        
                        // MARK: - ХРОНИЧЕСКИЕ ЗАБОЛЕВАНИЯ
                        card {
                            sectionTitle("Хронические заболевания")
                            Text("Пример: астма, гастрит")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            ForEach(chronicDiseases.indices, id: \.self) { i in
                                customField("Болезнь \(i+1)", text: $chronicDiseases[i])
                            }
                            
                            Button("+ Добавить заболевание") {
                                chronicDiseases.append("")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                
                // MARK: - КНОПКИ
                HStack {
                    Button("Пропустить") {
                        if let email = Auth.auth().currentUser?.email {
                            authViewModel.currentUser = User(username: "", email: email)
                        }
                        authViewModel.isSignedIn = true
                        authViewModel.shouldShowAnketa = false
                    }

                    .foregroundColor(Color(hex: "144B75"))
                    
                    Spacer()
                    
                    Button("Сохранить") {
                        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showEmptyNameAlert = true
                        } else {
                            authViewModel.completeAnketa(username: fullName)
                            // Показываем alert и после его закрытия сразу переходим в главное меню
                            showSavedAlert = true
                        }
                    }
                    .alert("Данные сохранены", isPresented: $showSavedAlert) {
                        Button("OK") {
                            // Здесь больше ничего делать не нужно — VM уже обновила isSignedIn
                            // Navigation автоматически поменяет экран, так как RootView смотрит на isSignedIn
                        }
                    } message: {
                        Text("Вы можете изменить данные позже в профиле.")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(hex: "144B75"))
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color(hex: "F7FBFF"), Color(hex: "F7FBFF")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .alert("Введите ФИО", isPresented: $showEmptyNameAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("Данные сохранены", isPresented: $showSavedAlert) {
                Button("OK") {}
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Анкета")
        }
    }
    
    // MARK: - UI COMPONENTS
    private func customField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .textFieldStyle(.roundedBorder)
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.bottom, 4)
    }
    
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding()
        .background(Color(hex: "E6F2FF"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct AnketaView_Previews: PreviewProvider {
    static var previews: some View {
        AnketaView(authViewModel: AuthViewModel())
    }
}
