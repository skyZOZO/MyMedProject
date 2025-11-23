import SwiftUI
import MapKit
import CoreLocation

// =======================================================
// NearbyPlacesView.swift — отображение аптек и клиник
// =======================================================

struct NearbyPlacesView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var selectedCategory: PlaceCategory = .all
    @State private var isOpenOnly: Bool = false

    @State private var allPlaces: [Place] = []
    @State private var filteredPlaces: [Place] = []

    @State private var selectedPlace: Place? = nil // BottomSheet

    private let osmService = OSMService()

    var body: some View {
        ZStack(alignment: .top) {

            // — MAP
            if let userLoc = locationManager.location {
                Map(
                    coordinateRegion: $locationManager.region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow),
                    annotationItems: filteredPlaces
                ) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        VStack(spacing: 6) {
                            Image(systemName: place.iconSystemName)
                                .font(.system(size: 16))
                                .foregroundColor(place.isPharmacy ? .green : .blue)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)

                            Text(place.name ?? "")
                                .font(.caption2)
                                .padding(6)
                                .background(Color.white)
                                .cornerRadius(6)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .onTapGesture { selectedPlace = place }
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    fetchPlaces(center: userLoc.coordinate, radiusMeters: 10000)
                }
            } else {
                ProgressView("Определяем ваше местоположение...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }


            // — TOP SEARCH PANEL
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Поиск аптек и клиник", text: $searchText)
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        categoryChip(.all, title: "Все")
                        categoryChip(.pharmacies, title: "Аптеки")
                        categoryChip(.clinics, title: "Клиники")
                        Divider().frame(width: 1, height: 28).background(Color.gray.opacity(0.2))
                        openToggleChip(title: "Открыто")
                    }
                    .padding(.horizontal)
                }
            }
        }
        // — BottomSheet
        .sheet(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
        }
        .onChange(of: searchText) { _ in applyFilters() }
        .onChange(of: selectedCategory) { _ in applyFilters() }
        .onChange(of: isOpenOnly) { _ in applyFilters() }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    // MARK: — UI CHIPS
    private func categoryChip(_ category: PlaceCategory, title: String) -> some View {
        Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? Color.blue.opacity(0.18) : Color.white)
                .cornerRadius(20)
                .foregroundColor(selectedCategory == category ? Color.blue : Color.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedCategory == category ? Color.clear : Color.gray.opacity(0.06))
                )
                .shadow(color: .black.opacity(selectedCategory == category ? 0.04 : 0.02), radius: 2)
        }
    }

    private func openToggleChip(title: String) -> some View {
        Button {
            isOpenOnly.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isOpenOnly ? Color.green.opacity(0.18) : Color.white)
            .cornerRadius(20)
            .foregroundColor(isOpenOnly ? Color.green : Color.primary)
            .shadow(color: .black.opacity(isOpenOnly ? 0.04 : 0.02), radius: 2)
        }
    }

    // MARK: — NETWORK + FILTERS
    private func fetchPlaces(center: CLLocationCoordinate2D, radiusMeters: Int) {
        osmService.fetchPlacesAround(lat: center.latitude, lon: center.longitude, radius: radiusMeters) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let places):
                    let unique = Dictionary(grouping: places, by: { $0.id }).compactMap { $0.value.first }
                    self.allPlaces = unique.sorted { $0.distance(from: center) < $1.distance(from: center) }
                    applyFilters()
                case .failure(let err):
                    print("OSM fetch error:", err.localizedDescription)
                }
            }
        }
    }

    private func applyFilters() {
        var result = allPlaces

        switch selectedCategory {
        case .all: break
        case .pharmacies: result = result.filter { $0.kind == .pharmacy }
        case .clinics: result = result.filter { $0.kind == .clinic || $0.kind == .hospital }
        }

        if isOpenOnly { result = result.filter { $0.isLikelyOpen } }

        if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                ($0.name?.lowercased().contains(q) ?? false) ||
                ($0.address?.lowercased().contains(q) ?? false)
            }
        }

        filteredPlaces = result
    }
}

// =======================================================
// BottomSheet Detail View
// =======================================================
struct PlaceDetailView: View {
    let place: Place

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(place.name ?? "—")
                    .font(.title)
                    .bold()

                if let kind = place.kindDescription {
                    Text("Тип: \(kind)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if let address = place.address {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(address)
                    }
                }

                if let phone = place.phone {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(phone)
                        Spacer()
                        Button(action: {
                            if let url = URL(string: "tel://\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "arrow.up.right.phone")
                        }
                    }
                }

                if let hours = place.openingHours {
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Часы работы: \(hours)")
                    }
                }

                Spacer()
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
    }
}

// =======================================================
// Place model & helpers
// =======================================================
struct Place: Identifiable {
    let id: String
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let tags: [String: String]
    let kind: OSMKind
    let address: String?
    let phone: String?
    let openingHours: String?

    var isPharmacy: Bool { kind == .pharmacy }
    var isLikelyOpen: Bool {
        if let oh = openingHours?.lowercased() {
            if oh.contains("24") || oh.contains("24/7") || oh.contains("mo-su") || oh.contains("круглосуточ") {
                return true
            }
        }
        if kind == .pharmacy { return true }
        return false
    }

    func distance(from center: CLLocationCoordinate2D) -> CLLocationDistance {
        let a = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let b = CLLocation(latitude: center.latitude, longitude: center.longitude)
        return a.distance(from: b)
    }

    var iconSystemName: String {
        switch kind {
        case .pharmacy: return "cross.case.fill"
        case .clinic: return "building.columns"
        case .hospital: return "cross.fill"
        case .other: return "mappin"
        }
    }

    var kindDescription: String? {
        switch kind {
        case .pharmacy: return "Аптека"
        case .clinic: return "Клиника"
        case .hospital: return "Больница"
        case .other: return nil
        }
    }
}

enum OSMKind { case pharmacy, clinic, hospital, other }
enum PlaceCategory { case all, pharmacies, clinics }

// =======================================================
// OSM Service
// =======================================================
final class OSMService {
    private let endpoint = "https://overpass-api.de/api/interpreter"

    func fetchPlacesAround(lat: Double, lon: Double, radius: Int = 10_000, completion: @escaping (Result<[Place], Error>) -> Void) {
        let query = """
        [out:json][timeout:25];
        (
          node["amenity"="pharmacy"](around:\(radius),\(lat),\(lon));
          way["amenity"="pharmacy"](around:\(radius),\(lat),\(lon));
          relation["amenity"="pharmacy"](around:\(radius),\(lat),\(lon));
          node["amenity"="clinic"](around:\(radius),\(lat),\(lon));
          way["amenity"="clinic"](around:\(radius),\(lat),\(lon));
          relation["amenity"="clinic"](around:\(radius),\(lat),\(lon));
          node["amenity"="hospital"](around:\(radius),\(lat),\(lon));
          way["amenity"="hospital"](around:\(radius),\(lat),\(lon));
          relation["amenity"="hospital"](around:\(radius),\(lat),\(lon));
        );
        out center;
        """

        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "OSMService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid endpoint"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = query.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else {
                completion(.failure(NSError(domain: "OSMService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let resp = try decoder.decode(OverpassResponse.self, from: data)
                let places = resp.elements.compactMap { element -> Place? in
                    let lat = element.lat ?? element.center?.lat
                    let lon = element.lon ?? element.center?.lon
                    guard let la = lat, let lo = lon else { return nil }

                    let amenity = element.tags?["amenity"]?.lowercased()
                    let kind: OSMKind
                    if amenity == "pharmacy" { kind = .pharmacy }
                    else if amenity == "clinic" { kind = .clinic }
                    else if amenity == "hospital" { kind = .hospital }
                    else { kind = .other }

                    let id = "\(element.type ?? "node")-\(element.id)"
                    let name = element.tags?["name"]
                    let address = [element.tags?["addr:street"], element.tags?["addr:housenumber"]]
                        .compactMap { $0 }.joined(separator: " ").trimmingCharacters(in: .whitespaces)
                    let phone = element.tags?["phone"] ?? element.tags?["contact:phone"]
                    let opening = element.tags?["opening_hours"]

                    return Place(
                        id: id,
                        name: name,
                        coordinate: CLLocationCoordinate2D(latitude: la, longitude: lo),
                        tags: element.tags ?? [:],
                        kind: kind,
                        address: address.isEmpty ? nil : address,
                        phone: phone,
                        openingHours: opening
                    )
                }
                completion(.success(places))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private struct OverpassResponse: Codable { let elements: [OverpassElement] }
    private struct OverpassElement: Codable {
        let type: String?; let id: Int; let lat: Double?; let lon: Double?; let center: Center?; let tags: [String: String]?
        struct Center: Codable { let lat: Double; let lon: Double }
    }
}

// =======================================================
// Location Manager
// =======================================================
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
    )
    @Published var location: CLLocation?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Доступ к геолокации запрещён пользователем")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        location = loc
        region.center = loc.coordinate
    }


}
