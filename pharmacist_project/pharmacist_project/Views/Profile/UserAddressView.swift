//
//  UserShippingAddressView.swift
//  pharmacist_project
//
//  Created by Long Pham Hoang on 9/9/24.
//

import SwiftUI
import MapKit

struct UserAddressView: View {
    @Binding var user: AppUser
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isEditingAddress = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shipping Address")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text(user.address ?? "Address not specified")
                .font(.body)
                .padding(.horizontal)

            Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: [user]) { user in
                MapPin(coordinate: region.center)
            }
            .frame(height: 300)
            .cornerRadius(10)
            .padding()

            Button("Edit Address") {
                isEditingAddress = true
            }
            .sheet(isPresented: $isEditingAddress) {
                EditAddressView(user: $user, region: $region)
            }

            Spacer()
        }
        .navigationTitle("Shipping Address")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            updateRegionForUserAddress()
        }
    }

    private func updateRegionForUserAddress() {
        guard let address = user.address else { return }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}


struct EditAddressView: View {
    @Binding var user: AppUser
    
    @Binding var region: MKCoordinateRegion
    @State private var newAddress: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter new address", text: $newAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Update Address") {
                    user.address = newAddress
                    updateRegionForNewAddress(newAddress: newAddress)
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Edit Address")
            .navigationBarItems(leading: Button("Cancel") {
                // Dismiss the view
            }, trailing: Button("Save") {
                user.address = newAddress
                updateRegionForNewAddress(newAddress: newAddress)
            })
        }
    }

    private func updateRegionForNewAddress(newAddress: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(newAddress) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}

#Preview {
    @State var exampleUser = AppUser(
        id: "12345",
        email: "ngongocthinh124@gmail.com",
        name: "Thịnh Ngô",
        dob: nil,
        address: "123 Main Street",
        phoneNumber: "555-1234",
        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocKLdbqETPr7YbRy08EwxGboIX9bbnAj5YVOat6OUToFR8NsvGo=s96-c",
        createdDate: Date()
    )
    
    return UserAddressView(user: $exampleUser)
}

