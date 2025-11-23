//
//  временно.swift
//  MyMedProject
//
//  Created by Аружан Куаныш on 23.11.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var currentBannerIndex = 0
    let banners = ["banner1", "banner2", "banner3"]
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F4F8FB").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Spacer().frame(height: 100)

                    bannerSection
                    categoryHeader
                    scrollCategories
                    monitoringHeader
                    monitoringSection
                    recordsHeader
                    improvedRecordList

                    Spacer().frame(height: 120)
                }
                .padding(.horizontal, 20)
            }

            topBar
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .background(Color(hex: "#F4F8FB").opacity(0.95))
        }
    }
}

/////////////////////////////////////////////////////////
// MARK: TOP BAR
/////////////////////////////////////////////////////////

extension HomeView {
    private var topBar: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .foregroundColor(Color(hex: "#064266"))
                Text("Караганда")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#064266"))
            }
            Spacer()
            Image(systemName: "bell.fill")
                .font(.system(size: 21))
                .foregroundColor(Color(hex: "#064266"))
        }
    }
}

/////////////////////////////////////////////////////////
// MARK: BANNER
/////////////////////////////////////////////////////////

extension HomeView {
    private var bannerSection: some View {
        TabView(selection: $currentBannerIndex) {
            bannerCard(image: "banner1", title: "Добро пожаловать!", subtitle: "Запишитесь к врачу за 1 минуту.")
            bannerCard(image: "banner2", title: "Следите за здоровьем", subtitle: "Ежедневный мониторинг доступен здесь.")
            bannerCard(image: "banner3", title: "Лучшие врачи города", subtitle: "Только проверенные специалисты.")
        }
        .frame(height: 155)   // УМЕНЬШИЛ
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                currentBannerIndex = (currentBannerIndex + 1) % 3
            }
        }
    }

    private func bannerCard(image: String, title: String, subtitle: String) -> some View {
        ZStack(alignment: .leading) {
            Color.white
                .cornerRadius(22)
                .shadow(color: .gray.opacity(0.15), radius: 6)
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 155)
                .cornerRadius(22)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.leading, 16)
            .padding(.top, 18)
        }
    }
}

/////////////////////////////////////////////////////////
// MARK: CATEGORY SCROLL
/////////////////////////////////////////////////////////

extension HomeView {
    private var categoryHeader: some View {
        HStack {
            Text("Категории врачей")
                .font(.system(size: 22, weight: .bold))
            Spacer()
            Text("Все")
                .foregroundColor(Color(hex: "#064266"))
        }
    }

    private var scrollCategories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                categoryCard(icon: "heart.text.square", title: "Пульмонолог")
                categoryCard(icon: "stethoscope", title: "Терапевт")
                categoryCard(icon: "cross.case.fill", title: "Хирург")
                categoryCard(icon: "brain", title: "Невролог")
                categoryCard(icon: "tooth.fill", title: "Стоматолог")
            }
        }
    }

    private func categoryCard(icon: String, title: String) -> some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .frame(width: 75, height: 75)
                .shadow(color: .gray.opacity(0.12), radius: 6)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundColor(Color(hex: "#064266"))
                )

            Text(title)
                .font(.system(size: 14))
        }
    }
}

/////////////////////////////////////////////////////////
// MARK: MONITORING – 6 БЛОКОВ!
/////////////////////////////////////////////////////////

extension HomeView {
    private var monitoringHeader: some View {
        Text("Самочувствие сегодня")
            .font(.system(size: 22, weight: .bold))
            .padding(.top, 4)
    }

    private var monitoringSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                monitorCard(icon: "heart.fill", title: "Пульс", value: "72", unit: "уд/мин")
                monitorCard(icon: "chart.bar", title: "Давление", value: "120/80", unit: "мм рт.ст.")
            }
            HStack(spacing: 12) {
                monitorCard(icon: "thermometer", title: "Темп.", value: "36.6", unit: "℃")
                monitorCard(icon: "figure.walk", title: "Шаги", value: "6 530", unit: "шагов")
            }
            HStack(spacing: 12) {
                monitorCard(icon: "bed.double.fill", title: "Сон", value: "7.4", unit: "час")
                monitorCard(icon: "drop.fill", title: "Вода", value: "1.8", unit: "л")
            }

            Button(action: {}) {
                Text("Добавить данные")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#064266"))
                    .cornerRadius(14)
            }
        }
    }

    private func monitorCard(icon: String, title: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title).font(.system(size: 14)).foregroundColor(.gray)
                Spacer()
                Image(systemName: icon).font(.system(size: 18))
            }
            Text(value).font(.system(size: 26, weight: .bold))
            Text(unit).font(.system(size: 12)).foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 5)
    }
}

/////////////////////////////////////////////////////////
// MARK: !!! ЗАПИСИ !!! (с ЦВЕТОМ ПО СРОКАМ)
/////////////////////////////////////////////////////////

extension HomeView {
    private var recordsHeader: some View {
        HStack {
            Text("Текущие записи")
                .font(.system(size: 22, weight: .bold))
            Spacer()
            Button("Мои записи") { }
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.top, 10)
    }

    private var improvedRecordList: some View {
        VStack(spacing: 14) {
        
            record(
                date: "23 ноября 2025, 11:30",
                daysLeft: 1,
                name: "Dr. Zaitin Zhanargul",
                speciality: "Кардиолог", rating: 4.7, exp: 8, image: "doctor2")
            
            record(
                date: "25 ноября 2025, 10:00",
                daysLeft: 1,
                name: "Dr. Kuanysh Aruzhan",
                speciality: "Гинеколог", rating: 5.0, exp: 12, image: "doctor1")
            
            record(
                date: "28 ноября 2025, 15:00",
                daysLeft: 6,
                name: "Dr. Saniya Samatqyzy",
                speciality: "Невролог", rating: 4.9, exp: 10, image: "doctor1")

        }
    }

    // Блок записи с ЦВЕТОМ
    private func record(date: String, daysLeft: Int, name: String, speciality: String, rating: Double, exp: Int, image: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            let color: Color = daysLeft <= 1 ? .red :
                               daysLeft <= 3 ? .orange :
                               .yellow

            HStack {
                Text(date).foregroundColor(color)
                Spacer()
                Text("Перейти")
            }
            .font(.system(size: 14))

            HStack(spacing: 14) {
                Image(image)
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    Text(name).font(.system(size: 18, weight: .semibold))
                    Text(speciality).foregroundColor(.gray)
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", rating)) +
                        Text(" • \(exp) лет").foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(18)
        .shadow(color: .gray.opacity(0.1), radius: 6)
    }
}
