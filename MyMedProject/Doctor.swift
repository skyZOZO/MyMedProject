import Foundation

struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let speciality: String
    let rating: Double
    let experience: Int        // стаж
    let description: String     // описание врача
    let image: String           // имя изображения в Assets
}
