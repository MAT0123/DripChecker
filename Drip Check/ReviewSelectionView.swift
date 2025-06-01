//
//  ReviewSelectionView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI
import PhotosUI

struct ReviewSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var stackPath = NavigationPath()
    var onSingleReview: ([UIImage]) -> Void
    var onComparison: ([UIImage]) -> Void
    
    var body: some View {
        NavigationStack(path: $stackPath) {
            

            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.95, blue: 0.97),
                        Color(red: 0.90, green: 0.90, blue: 0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Section
                        VStack(spacing: 16) {
                            Text("Choose Review Type")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("How would you like your fashion analyzed?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Photo Selection Section
                        VStack(spacing: 16) {
                            Text("Select Your Photos")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            // Photo Picker Button
                            PhotosPicker(
                                selection: $selectedPhotos,
                                maxSelectionCount: 3,
                                matching: .images
                            ) {
                                HStack(spacing: 12) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.title3)
                                    
                                    Text(selectedPhotos.isEmpty ? "Choose Photos" : "Change Photos (\(selectedPhotos.count))")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.indigo, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: .indigo.opacity(0.3), radius: 6, x: 0, y: 3)
                            }
                            .onChange(of: selectedPhotos) { newPhotos in
                                loadImages(from: newPhotos)
                            }
                            
                            // Selected Photos Preview
                            if !selectedImages.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 80, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                                                    )
                                                
                                                Text("\(index + 1)")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .frame(width: 20, height: 20)
                                                    .background(Circle().fill(Color.purple))
                                                    .offset(x: -6, y: 6)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                Text("\(selectedImages.count) photo\(selectedImages.count == 1 ? "" : "s") selected")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        // Review Options
                        VStack(spacing: 24) {
                            // Single Review Option
                            ReviewOptionCard(
                                icon: "person.fill",
                                title: "Single Outfit Review",
                                subtitle: "Get detailed feedback on one outfit",
                                features: [
                                    "Complete style analysis",
                                    "Improvement suggestions",
                                    "Fashion score with explanations",
                                    "Color & fit recommendations"
                                ],
                                buttonText: "Review My Outfit",
                                buttonColors: [.purple, .pink],
                                isEnabled: selectedImages.count >= 1,
                                action: {
                                    stackPath.append("single")
                                }
                            )
                            
                            // Comparison Option
                            ReviewOptionCard(
                                icon: "person.2.fill",
                                title: "Outfit Comparison",
                                subtitle: "Compare 2-3 outfits side by side",
                                features: [
                                    "Side-by-side analysis",
                                    "Which outfit works better",
                                    "Strengths of each look",
                                    "Best outfit recommendation"
                                ],
                                buttonText: "Compare Outfits",
                                buttonColors: [.blue, .cyan],
                                isEnabled: selectedImages.count >= 2,
                                action: {
                                    stackPath.append("multiple")

                                },
                                requiresMultiple: true
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationDestination(for: String.self, destination: { value in
                if value == "single" {
                    ReviewAnalysisView(images: selectedImages, reviewType: .single)
                        .navigationBarBackButtonHidden()
                }else{
                    ReviewAnalysisView(images: selectedImages, reviewType: .comparison)
                        .navigationBarBackButtonHidden()

                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.body)
                    }
                    .foregroundColor(.purple)
                }
            )
        }
    }
    
    // Helper function to load images from PhotosPicker items
    private func loadImages(from items: [PhotosPickerItem]) {
        selectedImages = []
        
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImages.append(image)
                        }
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

struct ReviewOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let features: [String]
    let buttonText: String
    let buttonColors: [Color]
    let isEnabled: Bool
    let action: () -> Void
    let requiresMultiple: Bool
    
    init(icon: String, title: String, subtitle: String, features: [String], buttonText: String, buttonColors: [Color], isEnabled: Bool = true, action: @escaping () -> Void, requiresMultiple: Bool = false) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.features = features
        self.buttonText = buttonText
        self.buttonColors = buttonColors
        self.isEnabled = isEnabled
        self.action = action
        self.requiresMultiple = requiresMultiple
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with icon
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: buttonColors.map { $0.opacity(0.2) }),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: icon)
                        .font(.system(size: 32))
                        .foregroundColor(buttonColors.first ?? .purple)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Features list
            VStack(spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(buttonColors.first ?? .purple)
                            .font(.system(size: 16))
                        
                        Text(feature)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Requirement notice for comparison
            if requiresMultiple {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .foregroundColor(isEnabled ? .orange : .gray)
                        .font(.system(size: 14))
                    
                    Text(isEnabled ? "Requires 2-3 outfit photos" : "Please select at least 2 photos")
                        .font(.caption)
                        .foregroundColor(isEnabled ? .orange : .gray)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill((isEnabled ? Color.orange : Color.gray).opacity(0.1))
                )
            }
            
            // Action button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: requiresMultiple ? "photo" : "camera")
                        .font(.system(size: 16))
                    
                    Text(buttonText)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: isEnabled ? buttonColors : [.gray, .gray]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: isEnabled ? (buttonColors.first?.opacity(0.3) ?? .clear) : .clear, radius: 6, x: 0, y: 3)
            }
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

// Preview
struct ReviewSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSelectionView(
            onSingleReview: { images in
                print("Single review selected with \(images.count) images")
            },
            onComparison: { images in
                print("Comparison selected with \(images.count) images")
            }
        )
    }
}
