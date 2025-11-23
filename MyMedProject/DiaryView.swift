import SwiftUI
import Charts

// --------------------------------------
// Структура данных для графиков
struct HealthData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
    let color: Color
}

// --------------------------------------
// Главный экран дневника
struct DiaryView: View {
    @State private var expandedCategories: Set<String> = []
    @State private var expandedDays: Set<String> = [] // Для истории показателей
    @State private var showAllGraphs = false

    // Пример данных для графиков
    let bloodPressureData: [HealthData] = [
        HealthData(day: "21.11", value: 118, color: .green),
        HealthData(day: "22.11", value: 120, color: .green),
        HealthData(day: "23.11", value: 122, color: .yellow),
        HealthData(day: "24.11", value: 119, color: .green),
        HealthData(day: "25.11", value: 121, color: .green)
    ]

    let sugarData: [HealthData] = [
        HealthData(day: "21.11", value: 5.9, color: .yellow),
        HealthData(day: "22.11", value: 5.8, color: .yellow),
        HealthData(day: "23.11", value: 5.6, color: .green),
        HealthData(day: "24.11", value: 5.7, color: .yellow),
        HealthData(day: "25.11", value: 5.5, color: .green)
    ]

    let weightData: [HealthData] = [
        HealthData(day: "21.11", value: 72, color: .green),
        HealthData(day: "22.11", value: 71.5, color: .green),
        HealthData(day: "23.11", value: 72, color: .green),
        HealthData(day: "24.11", value: 71.8, color: .green),
        HealthData(day: "25.11", value: 72.2, color: .green)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                Spacer().frame(height: 20)

                // Заголовок
                HStack {
                    Text("Ваш дневник самоконтроля")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)

                // --------------------------------------
                // Категории дневников
                VStack(spacing: 16) {
                    DiaryCategoryView(
                        title: "Сердечно-сосудистые заболевания",
                        indicators: [
                            "Артериальное давление (утро / вечер)",
                            "Пульс",
                            "Уровень стресса",
                            "Вес",
                            "Симптомы",
                            "Приём препаратов при АГ",
                            "Риск SCORE2",
                            "Отёки / самочувствие",
                            "Физическая активность"
                        ],
                        expandedCategories: $expandedCategories
                    )
                    
                    DiaryCategoryView(
                        title: "Повышенный / пониженный сахар",
                        indicators: [
                            "Глюкоза (до еды)",
                            "Глюкоза (после еды)",
                            "Инсулин",
                            "Хлебные единицы",
                            "Эпизоды гипо-/гипергликемии",
                            "Физическая нагрузка",
                            "Вес",
                            "Симптомы"
                        ],
                        expandedCategories: $expandedCategories
                    )
                    
                    DiaryCategoryView(
                        title: "Дополнительные дневники",
                        indicators: [
                            "Астма — пикфлоуметрия, приступы",
                            "ХОБЛ — сатурация, ЧДД",
                            "Беременность — движения плода, симптомы риска",
                            "Дневник ребёнка",
                            "Контроль сна",
                            "Контроль жидкости"
                        ],
                        expandedCategories: $expandedCategories
                    )
                }
                .padding(.horizontal)
                
                // --------------------------------------
                // История показателей (новый дизайн с белым фоном)
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("История показателей")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Text("Все дни")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            HistoricalDayCompactCard(date: "23.11", indicators: [
                                ("АД", "120/80", .green),
                                ("Пульс", "78", .green),
                                ("Сахар", "5.6", .yellow),
                                ("Вес", "72 кг", .green),
                                ("Сон", "7ч", .blue)
                            ])

                            HistoricalDayCompactCard(date: "22.11", indicators: [
                                ("АД", "118/79", .green),
                                ("Пульс", "80", .green),
                                ("Сахар", "5.8", .yellow),
                                ("Вес", "71.5 кг", .green),
                                ("Сон", "6.5ч", .blue)
                            ])

                            HistoricalDayCompactCard(date: "21.11", indicators: [
                                ("АД", "122/82", .yellow),
                                ("Пульс", "77", .green),
                                ("Сахар", "6.0", .orange),
                                ("Вес", "72 кг", .green),
                                ("Сон", "7ч", .blue)
                            ])
                        }
                        .padding(.horizontal)
                    }
                }

                

                // --------------------------------------
                // Мои препараты
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Мои препараты")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button(action: {
                            // Добавление препарата
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        MedicationCard(name: "Витамин Д", dosage: "10 мг", time: "08:00", taken: true)
                        MedicationCard(name: "Омега", dosage: "5 мг", time: "12:00", taken: true)
                        MedicationCard(name: "Кальций", dosage: "20 мг", time: "20:00", taken: false)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // --------------------------------------
                // Моя динамика (горизонтальные графики)
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Моя динамика")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button(action: {
                            showAllGraphs.toggle()
                        }) {
                            Text(showAllGraphs ? "Скрыть" : "Показать всё")
                                .bold()
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            GraphCard(title: "Давление", data: bloodPressureData)
                                .frame(width: 280)
                            GraphCard(title: "Сахар", data: sugarData)
                                .frame(width: 280)
                            GraphCard(title: "Вес", data: weightData)
                                .frame(width: 280)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 40) // дополнительное место снизу
                }

                Spacer().frame(height: 60)
            }
        }
    }
}

// --------------------------------------
// Разворачивающаяся категория дневника
struct DiaryCategoryView: View {
    let title: String
    let indicators: [String]
    @Binding var expandedCategories: Set<String>
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: expandedCategories.contains(title) ? "chevron.up" : "chevron.down")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .onTapGesture {
                if expandedCategories.contains(title) {
                    expandedCategories.remove(title)
                } else {
                    expandedCategories.insert(title)
                }
            }
            
            if expandedCategories.contains(title) {
                VStack(spacing: 8) {
                    ForEach(indicators, id: \.self) { indicator in
                        Button(action: {}) {
                            Text(indicator)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// --------------------------------------
// Карточка истории (компактная, горизонтальная с белым фоном)
struct HistoricalDayCompactCard: View {
    let date: String
    let indicators: [(String, String, Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(date)
                .font(.headline)
                .foregroundColor(.black)
            ForEach(indicators, id: \.0) { title, value, color in
                HStack(spacing: 4) {
                    Text(title.prefix(3))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(value)
                        .bold()
                        .foregroundColor(color)
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(width: 160)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
    }
}

// --------------------------------------
// Карточка препарата
struct MedicationCard: View {
    let name: String
    let dosage: String
    let time: String
    let taken: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name).bold()
                Text("\(dosage) • \(time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Circle()
                .fill(taken ? Color.green : Color.gray.opacity(0.4))
                .frame(width: 20, height: 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

// --------------------------------------
// График с линиями
struct GraphCard: View {
    let title: String
    let data: [HealthData]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold().padding(.bottom, 4)

            Chart {
                ForEach(data) { point in
                    LineMark(
                        x: .value("День", point.day),
                        y: .value("Значение", point.value)
                    )
                    .foregroundStyle(point.color)
                    .symbol(Circle())
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 140)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

// --------------------------------------
// Превью
struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
