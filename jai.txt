import SwiftUI

struct CategoriesView: View {
    // Пример данных
    let doctorCategories = ["Терапевт", "Кардиолог", "Дерматолог", "Невролог", "Хирург", "Офтальмолог", "Стоматолог", "Эндокринолог", "Педиатр", "Ортопед", "Гастроэнтеролог", "Отоларинголог", "Гинеколог", "Аллерголог", "Диетолог"]
    @State private var favorites: [String] = ["Кардиолог", "Хирург"]
    @State private var favoriteDoctors: [(name: String, speciality: String, rating: Double, clinic: String, image: String)] = [
        (name: "Аекина С.С.", speciality: "Терапевт", rating: 4.8, clinic: "City Clinic", image: "doctor1"),
        (name: "Амангельдина А.А.", speciality: "Кардиолог", rating: 4.9, clinic: "Heart Clinic", image: "doctor2")
    ]


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // ------------------ Блок Избранное ------------------
                    if !favoriteDoctors.isEmpty {
                        Text("Избранное")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(favoriteDoctors, id: \.name) { doctor in
                                    FavoriteDoctorCard(doctor: doctor) {
                                        withAnimation(.spring()) {
                                            favoriteDoctors.removeAll { $0.name == doctor.name }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }


                    // ------------------ Список категорий врачей ------------------
                    Text("Категории врачей")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        ForEach(doctorCategories, id: \.self) { category in
                            NavigationLink(destination: DoctorsListView(category: category)) {
                                HStack {
                                    Text(category)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}


struct FavoriteDoctorCard: View {
    let doctor: (name: String, speciality: String, rating: Double, clinic: String, image: String)
    var removeAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            Image(doctor.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .shadow(radius: 1)

            VStack(alignment: .leading, spacing: 3) {
                Text(doctor.name)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)

                Text(doctor.speciality)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))

                    Text(String(format: "%.1f", doctor.rating))
                        .font(.system(size: 12))

                    Text("• \(doctor.clinic)")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }

            Spacer()

            // Кнопка удаления
            Button(action: removeAction) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.system(size: 16))
            }
        }
        .padding(14)
        .frame(width: 260, height: 100)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}


// ------------------ Список врачей по категории ------------------
struct DoctorsListView: View {
    let category: String
    
    let allDoctors: [String: [(name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)]] = [
        "Терапевт": [
            (name: "Аекина С.С.", speciality: "Терапевт", rating: 3.5, exp: 10, image: "doctor1", clinic: "City Clinic", phone: "+7 701 123 45 67", price: "5000 KZT"),
            (name: "Куаныш А.К.", speciality: "Терапевт", rating: 4.7, exp: 8, image: "doctor2", clinic: "Central Hospital", phone: "+7 701 765 43 21", price: "4500 KZT"),
            (name: "Зайтин Ж.К.", speciality: "Терапевт", rating: 2.2, exp: 5, image: "doctor3", clinic: "Health Plus", phone: "+7 701 234 56 89", price: "4000 KZT"),
            (name: "Калелова А.К.", speciality: "Терапевт", rating: 5.0, exp: 12, image: "doctor3", clinic: "City Clinic", phone: "+7 701 987 65 43", price: "5200 KZT"),
            (name: "Анарбеков Е.Т.", speciality: "Терапевт", rating: 4.3, exp: 7, image: "doctor3", clinic: "Central Hospital", phone: "+7 701 654 32 10", price: "4700 KZT"),
            (name: "Омаров С.А.", speciality: "Терапевт", rating: 4.6, exp: 9, image: "doctor3", clinic: "Health Plus", phone: "+7 701 321 45 67", price: "4800 KZT"),
            (name: "Ерланов К.С.", speciality: "Терапевт", rating: 4.9, exp: 15, image: "doctor3", clinic: "City Clinic", phone: "+7 701 543 21 76", price: "5500 KZT"),
            (name: "Оразбеков Д.А.", speciality: "Терапевт", rating: 4.1, exp: 6, image: "doctor3", clinic: "Central Hospital", phone: "+7 701 876 54 32", price: "4300 KZT")
        
        ],
        "Кардиолог": [
            (name: "Амангельдина А.А.", speciality: "Кардиолог", rating: 4.7, exp: 8, image: "doctor2", clinic: "Cardio Center", phone: "+7 701 234 56 78", price: "7000 KZT"),
            (name: "Талгатова С.С.", speciality: "Кардиолог", rating: 5.0, exp: 12, image: "doctor1", clinic: "Heart Clinic", phone: "+7 701 876 54 32", price: "7500 KZT")
        ]
    ]
    
    @State private var selectedClinic: String = "Все клиники"
    @State private var minRating: Double = 0
    @State private var minExp: Int = 0
    @State private var maxPrice: Double = 10000
    
    var clinics: [String] {
        let clinics = doctors.map { $0.clinic }
        return ["Все клиники"] + Array(Set(clinics))
    }
    
    var doctors: [(name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)] {
        allDoctors[category] ?? []
    }
    
    var filteredDoctors: [(name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)] {
        doctors.filter { doctor in
            let priceValue = Double(doctor.price.replacingOccurrences(of: " KZT", with: "")) ?? 0
            return (selectedClinic == "Все клиники" || doctor.clinic == selectedClinic) &&
                   doctor.rating >= minRating &&
                   doctor.exp >= minExp &&
                   priceValue <= maxPrice
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // ------------------ Горизонтальные фильтры ------------------
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Клиника
                    Menu {
                        ForEach(clinics, id: \.self) { clinic in
                            Button(clinic) { selectedClinic = clinic }
                        }
                    } label: {
                        FilterButton(title: selectedClinic)
                    }
                    
                    // Рейтинг
                    Menu {
                        let ratingValues = stride(from: 1.0, through: 5.0, by: 0.2).map { Double($0) }

                        ForEach(ratingValues, id: \.self) { value in
                            Button(String(format: "%.1f ⭐️", value)) {
                                minRating = value
                            }
                        }
                    } label: {
                        FilterButton(title: String(format: "Рейтинг от: %.1f", minRating))
                    }
                    
                    // Стаж
                    Menu {
                        ForEach(Array(0...30), id: \.self) { exp in
                            Button("\(exp) лет") { minExp = exp }
                        }
                    } label: {
                        FilterButton(title: "Стаж от: \(Int(minExp)) лет") // принудительно Int
                    }

                    // Цена
                    Menu {
                        ForEach([1000,2000,3000,4000,5000,6000,7000,8000,9000,10000], id: \.self) { price in
                            Button("\(price) KZT") { maxPrice = Double(price) }
                        }
                    } label: {
                        FilterButton(title: "До: \(Int(maxPrice)) KZT") // Int вместо Double
                    }
                }
                .padding(.horizontal)
            }
            
            // ------------------ Список врачей ------------------
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredDoctors, id: \.name) { doctor in
                        doctorCard(doctor: doctor)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(category)
    }
    
    private func doctorCard(doctor: (name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)) -> some View {
        @State var isFavorite = false
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(doctor.image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(doctor.name)
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(isFavorite ? .yellow : .gray)
                        }
                    }
                    
                    Text(doctor.speciality)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.system(size: 14))
                        Text("• \(doctor.exp) лет")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                        Text(doctor.clinic)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 14))
                        Text(doctor.phone)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 6) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 14))
                        Text(doctor.price)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.15), radius: 12, x: 0, y: 6)
        )
    }
}

// ------------------ Кнопка фильтра ------------------
struct FilterButton: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.blue.opacity(0.15))
            .foregroundColor(.blue)
            .cornerRadius(12)
    }
}
