
import SwiftUI
import SwiftData

import SwiftUI
// MedApp - SwiftUI starter
// Цвета: PrimaryDark #0A2A43, PrimaryBlue #1F6FEB, LightBlue #8FC8FF
extension Color {
    static let primaryDark = Color(hex: "0A2A43")
    static let primaryBlue = Color(hex: "1F6FEB")
    static let lightBlue = Color(hex: "8FC8FF")
    static let background = Color(hex: "FFFFFF")
    static let surface = Color(hex: "F5F7FA")
    static let border = Color(hex: "E3E7ED")
    static let textMain = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "6F7A84")
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
// MARK: - Models (simple mock)
struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let speciality: String
    let rating: Double
    let price: String
}
struct Clinic: Identifiable {
    let id = UUID()
    let name: String
    let address: String
}
// MARK: - Mock Data
let sampleDoctors = [
    Doctor(name: "Алия Жанабева", speciality: "Гинеколог", rating: 4.9, price: "10 000 ₸"),
    Doctor(name: "Салтанат Той", speciality: "Стоматолог", rating: 4.8, price: "8 000 ₸"),
    Doctor(name: "Бауыр Жуков", speciality: "Терапевт", rating: 4.7, price: "6 000 ₸")
]
let sampleClinics = [
    Clinic(name: "МедЦентр Алматы", address: "ул. Достык, 12"),
    Clinic(name: "Белый Лотос", address: "просп. Абая, 55")
]
// MARK: - Main TabView
struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Главная", systemImage: "house.fill") }
            NavigationStack { SearchView() }
                .tabItem { Label("Поиск", systemImage: "magnifyingglass") }
            NavigationStack { MapView() }
                .tabItem { Label("Карта", systemImage: "map.fill") }
            NavigationStack { FavoritesView() }
                .tabItem { Label("Избранное", systemImage: "star.fill") }
            NavigationStack { ProfileView() }
                .tabItem { Label("Профиль", systemImage: "person.crop.circle") }
        }
        .accentColor(.primaryBlue)
        .background(Color.background)
    }
}
// MARK: - Home
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("MedApp")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.textMain)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .foregroundColor(.primaryDark)
                            .padding(8)
                            .background(Color.surface)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                SearchBar()
                    .padding(.horizontal)
                Text("Популярные специальности")
                    .font(.headline)
                    .foregroundColor(.textMain)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(["Стоматолог","Кардиолог","Гинеколог","Педиатр"], id: \.self) { item in
                            SpecialtyCard(title: item)
                        }
                    }
                    .padding(.horizontal)
                }
                Text("Лучшие врачи недели")
                    .font(.headline)
                    .foregroundColor(.textMain)
                    .padding(.horizontal)
                VStack(spacing: 12) {
                    ForEach(sampleDoctors) { doc in
                        NavigationLink(destination: DoctorProfileView(doctor: doc)) {
                            DoctorRow(doctor: doc)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.background.ignoresSafeArea())
    }
}
// MARK: - Search Bar
struct SearchBar: View {
    @State private var text = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            TextField("Поиск врача, клиники или услуги", text: $text)
        }
        .padding(12)
        .background(Color.surface)
        .cornerRadius(12)
    }
}
// MARK: - Specialty Card
struct SpecialtyCard: View {
    let title: String
    var body: some View {
        VStack {
            Circle()
                .fill(Color.lightBlue.opacity(0.4))
                .frame(width: 64, height: 64)
                .overlay(Image(systemName: "cross.case.fill").font(.title2).foregroundColor(.primaryBlue))
            Text(title)
                .font(.subheadline)
                .foregroundColor(.textMain)
        }
        .frame(width: 110, height: 130)
        .background(Color.surface)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
// MARK: - Doctor Row
struct DoctorRow: View {
    let doctor: Doctor
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.primaryBlue.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(Text(String(doctor.name.split(separator: " ").compactMap { $0.first }.map{String($0)}.joined())).font(.headline))
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.headline)
                    .foregroundColor(.textMain)
                Text(doctor.speciality)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                HStack(spacing: 8) {
                    Label(String(format: "%.1f", doctor.rating), systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(doctor.price)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            Spacer()
            Button(action: {}) {
                Text("Записаться")
                    .font(.subheadline.weight(.semibold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.surface)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}
// MARK: - Search View
struct SearchView: View {
    var body: some View {
        VStack(spacing: 12) {
            SearchBar()
                .padding()
            List {
                Section("Категории врачей") {
                    ForEach(["Стоматолог","Кардиолог","Гинеколог"], id: \.self) { c in
                        NavigationLink(c) {
                            Text("Список врачей для \(c)")
                        }
                    }
                }
                Section("Клиники") {
                    ForEach(sampleClinics) { clinic in
                        NavigationLink(destination: ClinicDoctorsView(clinic: clinic)) {
                            HStack {
                                Rectangle().fill(Color.surface).frame(width: 48, height: 48).cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(clinic.name).foregroundColor(.textMain)
                                    Text(clinic.address).font(.caption).foregroundColor(.textSecondary)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Поиск")
    }
}
// MARK: - Map View
struct MapView: View {
    var body: some View {
        VStack {
            Text("Карта клиник")
                .font(.title2)
                .padding()
            Spacer()
            Text("(Здесь будет интеграция MapKit)")
                .foregroundColor(.textSecondary)
            Spacer()
        }
        .navigationTitle("Карта")
    }
}
// MARK: - Favorites View
struct FavoritesView: View {
    var body: some View {
        List {
            Section("Врачи и клиники") {
                ForEach(sampleDoctors) { doc in
                    HStack {
                        Text(doc.name)
                        Spacer()
                        Text(doc.price).foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .navigationTitle("Избранное")
    }
}
// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            Circle().fill(Color.primaryBlue.opacity(0.2)).frame(width: 96, height: 96)
            Text("Бауыр Жуков").font(.title2).foregroundColor(.textMain)
            Text("+7 701 234 56 78").foregroundColor(.textSecondary)
            Spacer()
            List {
                NavigationLink("Мои записи") { MyBookingsView() }
                NavigationLink("Медицинская карта") { MedicalRecordView() }
                NavigationLink("Настройки") { SettingsView() }
                NavigationLink("Поддержка") { SupportView() }
            }
        }
        .padding()
        .navigationTitle("Профиль")
    }
}
// MARK: - Doctor Profile View
struct DoctorProfileView: View {
    let doctor: Doctor
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Circle().fill(Color.primaryBlue.opacity(0.2)).frame(width: 84, height: 84)
                    VStack(alignment: .leading) {
                        Text(doctor.name).font(.title2).foregroundColor(.textMain)
                        Text(doctor.speciality).foregroundColor(.textSecondary)
                        HStack { Label(String(format: "%.1f", doctor.rating), systemImage: "star.fill") }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Услуги и цены").font(.headline)
                    VStack(spacing: 8) {
                        HStack {
                            Text("Прием").foregroundColor(.textMain)
                            Spacer()
                            Text(doctor.price).foregroundColor(.textSecondary)
                        }
                        HStack {
                            Text("Консультация онлайн").foregroundColor(.textMain)
                            Spacer()
                            Text("7 500 ₸").foregroundColor(.textSecondary)
                        }
                    }
                    .padding()
                    .background(Color.surface)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                NavigationLink(destination: DoctorScheduleView(doctor: doctor)) {
                    Text("Посмотреть график")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                ReviewsListView(doctorId: doctor.id)
            }
            .padding(.vertical)
        }
        .navigationTitle("Профиль врача")
    }
}
// MARK: - Doctor Schedule
struct DoctorScheduleView: View {
    let doctor: Doctor
    var body: some View {
        VStack(spacing: 12) {
            Text("График врача")
                .font(.title2)
                .padding()
            // Simple slots mock
            VStack(spacing: 8) {
                ForEach(["09:00","10:00","11:00","14:00"], id: \.self) { slot in
                    Button(action: {}) {
                        Text(slot)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.surface)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("График")
    }
}
// MARK: - Reviews List
struct ReviewsListView: View {
    let doctorId: UUID
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Отзывы")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 8) {
                ForEach(0..<3) { i in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack { Text("Пользователь \(i+1)").font(.subheadline).foregroundColor(.textMain); Spacer(); Text("⭐ 4.8").foregroundColor(.yellow) }
                        Text("Очень хороший врач, помог быстро и профессионально.")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    .padding()
                    .background(Color.surface)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
}
// MARK: - Clinic Doctors View
struct ClinicDoctorsView: View {
    let clinic: Clinic
    var body: some View {
        List {
            Section(header: Text(clinic.name)) {
                ForEach(sampleDoctors) { doc in
                    NavigationLink(destination: DoctorProfileView(doctor: doc)) {
                        DoctorRow(doctor: doc)
                    }
                }
            }
        }
        .navigationTitle("Врачи в клинике")
    }
}
// MARK: - My Bookings
struct MyBookingsView: View {
    var body: some View {
        List {
            ForEach(0..<3) { i in
                NavigationLink(destination: BookingDetailsView()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Запись к \(sampleDoctors[i].name)")
                            Text("10 дек 2025, 10:00").font(.caption).foregroundColor(.textSecondary)
                        }
                        Spacer()
                        Text("Подтверждена").font(.caption).foregroundColor(.green)
                    }
                }
            }
        }
        .navigationTitle("Мои записи")
    }
}
// MARK: - Booking Details
struct BookingDetailsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Детали записи")
                .font(.title2)
                .padding()
            VStack(alignment: .leading, spacing: 8) {
                Text("Врач: Алия Жанабева")
                Text("Дата: 10 дек 2025")
                Text("Время: 10:00")
                Text("Клиника: МедЦентр Алматы")
            }
            .padding()
            .background(Color.surface)
            .cornerRadius(12)
            Spacer()
        }
        .navigationTitle("Детали записи")
    }
}
// MARK: - Medical Record
struct MedicalRecordView: View {
    var body: some View {
        VStack {
            Text("Медицинская карта")
                .font(.title2)
                .padding()
            Text("(Опционально: хранение анализов, рецептов и метрик)")
                .foregroundColor(.textSecondary)
                .padding()
            Spacer()
        }
        .navigationTitle("Мед. карта")
    }
}
// MARK: - Settings
struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink("Уведомления") { NotificationsView() }
            NavigationLink("Поддержка") { SupportView() }
            Button("Выйти") {}
        }
        .navigationTitle("Настройки")
    }
}
struct NotificationsView: View {
    var body: some View {
        Text("Уведомления")
            .navigationTitle("Уведомления")
    }
}
struct SupportView: View {
    var body: some View {
        Text("Поддержка и FAQ")
            .navigationTitle("Поддержка")
    }
}
// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
