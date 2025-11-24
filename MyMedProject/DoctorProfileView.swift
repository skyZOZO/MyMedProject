import SwiftUI

struct Review: Identifiable {
    let id = UUID()
    let name: String
    let text: String
    let rating: Int
}

let sampleReviews = [
    Review(name: "Алия К.", text: "Очень внимательный и профессиональный врач. Рекомендую!", rating: 5),
    Review(name: "Марат Т.", text: "Приятная консультация, врач объяснил всё подробно.", rating: 4),
    Review(name: "Елена С.", text: "Всё понравилось, буду обращаться снова.", rating: 5)
]

struct DoctorProfileView: View {
    let doctor: (name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)
    
    @State private var isFavorite = false
    @State private var showAppointment = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Верхний блок: фото + информация о клинике/телефоне
                HStack(alignment: .top, spacing: 16) {
                    Image(doctor.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(doctor.name)
                            .font(.system(size: 22, weight: .bold))
                        
                        Text(doctor.speciality)
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(doctor.rating.rounded()) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            Text("• \(doctor.exp) лет опыта")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "building.2.fill")
                                    .foregroundColor(.blue)
                                Text(doctor.clinic)
                                    .font(.system(size: 14))
                            }
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.green)
                                Text(doctor.phone)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Divider()
                
                // О враче
                VStack(alignment: .leading, spacing: 8) {
                    Text("О враче")
                        .font(.headline)
                    Text("Терапевт, стаж работы — \(doctor.exp) лет. Проводит диагностику и лечение острых и хронических заболеваний, составляет индивидуальные планы терапии.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                // Услуги и цены
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Услуги")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Text("Все услуги")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Первичная консультация")
                        Spacer()
                        Text("5 000 тг")
                    }
                    HStack {
                        Text("Повторная консультация")
                        Spacer()
                        Text("3 000 тг")
                    }
                    HStack {
                        Text("ЭКГ с расшифровкой")
                        Spacer()
                        Text("3 000 тг")
                    }
                    HStack {
                        Text("Холтер мониторинг")
                        Spacer()
                        Text("2 000 тг")
                    }
                }
                .font(.system(size: 14))

                Divider()

                // Отзывы
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Отзывы")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Text("Все отзывы")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(sampleReviews) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(review.name)
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 12))
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            Text(review.text)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }

                Divider()

                
                // Кнопка записи
                Button(action: {
                    showAppointment = true
                }) {
                    Text("Записаться на приём")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .background(
                    NavigationLink(
                        destination: AppointmentView(doctorName: doctor.name),
                        isActive: $showAppointment,
                        label: { EmptyView() }
                    )
                    .hidden()
                )
                
                // Пустое пространство внизу
                Spacer()
                    .frame(height: 80)
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("Профиль врача")
        .navigationBarTitleDisplayMode(.inline)
    }
}
