import SwiftUI

struct DoctorRow: View {
    let doctor: (name: String, speciality: String, rating: Double, exp: Int, image: String, clinic: String, phone: String, price: String)
    @State private var isFavorite = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.system(size: 14))
                        Text("• \(doctor.exp) лет")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.blue)
                        Text(doctor.clinic)
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text(doctor.phone)
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.orange)
                        Text(doctor.price)
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
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
