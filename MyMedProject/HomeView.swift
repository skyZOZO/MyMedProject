import SwiftUI
import MapKit

struct HomeView: View {
    @State private var currentBannerIndex = 0
    @State private var openNearbyPlaces = false
    
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F4F8FB").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 26) {
                    
                    Spacer().frame(height: 110)
                    
                    bannerSection
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) { // вместо 26 ставим меньшее значение
                        categoryHeader
                            .padding(.horizontal, 20)

                        scrollCategories
                            .padding(.horizontal, 20)
                    }

                    dailyIndicatorsSection
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) { // вместо 26 ставим меньшее значение

                    recordsHeader
                        .padding(.horizontal, 20)
                    
                    improvedRecordList
                        .padding(.horizontal, 20)
                    }
                    Spacer().frame(height: 100)
                }
            }
            
            topBar
                .padding(.top, 60)
                .padding(.horizontal, 20)
                .background(Color(hex: "#F4F8FB").opacity(0.95))
                .zIndex(1)
        }
        
        .fullScreenCover(isPresented: $openNearbyPlaces) {
            NearbyPlacesView()
        }

    }
    
    // ---------------------------------------------------------
    // MARK: - TOP BAR
    // ---------------------------------------------------------
    private var topBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .foregroundColor(Color(hex: "#064266"))
                    .font(.system(size: 20))
                Text("Караганда")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "#064266"))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.2))
            .cornerRadius(14)
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: "bell.fill")
                    .foregroundColor(Color(hex: "#064266"))
                    .font(.system(size: 20))
            }
        }
    }
    
    // ---------------------------------------------------------
    // MARK: - BANNERS
    // ---------------------------------------------------------
    private var bannerSection: some View {
        TabView(selection: $currentBannerIndex) {
            bannerMap.tag(0)
            
            bannerCardModern(
                title: "Советы по здоровью",
                subtitle: "Ежедневные рекомендации",
                colorStart: "#0B82F4",
                colorEnd: "#064266"
            ).tag(1)
            
            bannerCardModern(
                title: "Лучшие врачи города",
                subtitle: "Только проверенные специалисты",
                colorStart: "#064266",
                colorEnd: "#0B82F4"
            ).tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 180)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut) {
                currentBannerIndex = (currentBannerIndex + 1) % 3
            }
        }
    }
    
    private var bannerMap: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 43.222, longitude: 76.851),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
            .cornerRadius(22)
            .shadow(color: .gray.opacity(0.6), radius: 12, x: 0, y: 6)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Искать поблизости")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "0A2A43"))
                    Text("Ближайшие аптеки и клиники")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "0A2A43").opacity(0.85))
                }
                
                Spacer()
                
                Button(action: {    openNearbyPlaces = true
}) {
                    Image(systemName: "map.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .padding(12)
                        .background(Color(hex: "#0A2A43"))
                        .cornerRadius(12)
                }

            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color.black.opacity(0.25), Color.black.opacity(0.05)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .cornerRadius(16)
            .padding(12)
        }
        .frame(height: 180)
    }
    
    private func bannerCardModern(title: String, subtitle: String, colorStart: String, colorEnd: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: colorStart), Color(hex: colorEnd)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .blue.opacity(0.25), radius: 12, x: 0, y: 6)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(16)
            .background(.ultraThinMaterial.opacity(0.6))
            .cornerRadius(16)
            .padding(16)
        }
    }
    
    // ---------------------------------------------------------
    // MARK: - CATEGORIES
    // ---------------------------------------------------------
    private var categoryHeader: some View {
        HStack {
            Text("Категории врачей")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#064266"))
            Spacer()
            Text("Все")
                .foregroundColor(Color(hex: "#0B82F4"))
                .font(.system(size: 14, weight: .semibold))
        }
    }
    
    private var scrollCategories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                categoryCard(icon: "heart.text.square", title: "Пульмонолог", iconColor: .red)
                categoryCard(icon: "stethoscope", title: "Терапевт", iconColor: .blue)
                categoryCard(icon: "cross.case.fill", title: "Хирург", iconColor: .green)
                categoryCard(icon: "brain", title: "Невролог", iconColor: .purple)
                categoryCard(icon: "tooth.fill", title: "Стоматолог", iconColor: .orange)
            }
            .padding(.horizontal, 10)
        }
    }

    private func categoryCard(icon: String, title: String, iconColor: Color) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(iconColor)
            }

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#0A2A43"))
                .lineLimit(1)
                .frame(width: 80)
        }
        .padding(6)
    }


    // ---------------------------------------------------------
    // MARK: - COMPACT TODAY RECORDS (2x4)
    // ---------------------------------------------------------
    private var dailyIndicatorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Сегодняшние показатели")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "#064266"))
                
                Spacer() // чтобы "Изменить" отодвинулось вправо
                
                Text("Изменить")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#0B82F4"))
            }
            .padding(.top, 10) // по желанию, для отступов

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                CompactIndicator(title: "АД", value: "120/80", color: .green)
                CompactIndicator(title: "Пульс", value: "78", color: .green)
                CompactIndicator(title: "Сахар", value: "5.6", color: .yellow)
                CompactIndicator(title: "Вес", value: "72 кг", color: .green)
                CompactIndicator(title: "SpO₂", value: "97%", color: .green)
                CompactIndicator(title: "Сон", value: "7 ч", color: .blue)
                CompactIndicator(title: "Шаги", value: "4 500", color: .orange)
                CompactIndicator(title: "Симптомы", value: "нет", color: .green)
            }
        }
    }
    
    struct CompactIndicator: View {
        let title: String
        let value: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.footnote)
                    .bold()
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding(6)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }

    
    // ---------------------------------------------------------
    // MARK: - RECORDS LIST
    // ---------------------------------------------------------
    private var recordsHeader: some View {
        HStack {
            Text("Текущие записи")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "#064266"))
            Spacer()
            Text("Мои записи")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#0B82F4"))
        }
        .padding(.top, 10)
    }
    
    private var improvedRecordList: some View {
        VStack(spacing: 16) {
            recordCard(
                date: "23 ноября 2025, 11:30",
                daysLeft: 1,
                name: "Dr. Zaitin Zhanargul",
                speciality: "Кардиолог",
                rating: 4.7,
                exp: 8,
                image: "doctor2"
            )
            recordCard(
                date: "26 ноября 2025, 10:00",
                daysLeft: 3,
                name: "Dr. Kuanysh Aruzhan",
                speciality: "Гинеколог",
                rating: 5.0,
                exp: 12,
                image: "doctor1"
            )
        }
    }
    
    private func recordCard(date: String, daysLeft: Int, name: String, speciality: String, rating: Double, exp: Int, image: String) -> some View {
        
        let color: Color = daysLeft <= 1 ? .red : daysLeft <= 3 ? .orange : .yellow
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(color.opacity(0.85))
                    .frame(width: 4, height: 22)
                
                Text(date)
                    .foregroundColor(color)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("Перейти")
                    .foregroundColor(Color(hex: "#0B82F4"))
                    .font(.system(size: 14, weight: .semibold))
            }
            
            HStack(spacing: 14) {
                Image(image)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4) // чуть сильнее
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 17, weight: .semibold))
                    
                    Text(speciality)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 14))
                        Text("• \(exp) лет")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.15), radius: 12, x: 0, y: 6) // тень сильнее и мягче
        )
    }

}

