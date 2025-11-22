
import SwiftUI

struct AnketaView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var gender = "Мужской"
    
    let genders = ["Мужской", "Женский", "Другое"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Личные данные").font(.headline)) {
                    TextField("Имя", text: $name)
                    TextField("Возраст", text: $age)
                        .keyboardType(.numberPad)
                    Picker("Пол", selection: $gender) {
                        ForEach(genders, id: \.self) { g in
                            Text(g)
                        }
                    }
                }
                
                Section {
                    Button(action: submitForm) {
                        Text("Сохранить")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Анкета")
        }
    }
    
    private func submitForm() {
        // Здесь позже можно добавить сохранение данных
        print("Имя: \(name), Возраст: \(age), Пол: \(gender)")
    }
}

struct AnketaView_Previews: PreviewProvider {
    static var previews: some View {
        AnketaView()
    }
}

