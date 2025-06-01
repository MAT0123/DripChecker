//
//  ReviewAnalysisView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI



struct ReviewAnalysisView: View {
    @Environment(\.dismiss) private var dismiss
    let images: [UIImage]

    @StateObject var aiManager:AIManager
    let reviewType: ReviewType
    init(images: [UIImage] , reviewType:ReviewType){
        self.images = images
        self.reviewType = reviewType
        
        _aiManager = StateObject(wrappedValue: AIManager(images: images))
    }
    
    var body: some View {
        NavigationView {
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
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text(reviewType == .single ? "Outfit Analysis" : "Outfit Comparison")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(reviewType == .single ? "AI analyzing your style..." : "AI comparing your outfits...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Images Display
                        if reviewType == .single {
                            singleImageView
                        } else {
                            comparisonImageView
                        }
                        
                        // Analysis Section
                        VStack(spacing: 16) {
                            if aiManager.isAnalyzing {
                                analysisLoadingView
                            } else {
                                switch aiManager.analysis {
                                case .single(let singleOutfitAnalysis):
                                            SingleOutfitAnalysisView(analysis: singleOutfitAnalysis)
                                            
                                        case .comparison(let comparisonAnalysis):
                                            ComparisonAnalysisView(analysis: comparisonAnalysis)
                                            
                                        case .error(let string):
                                            ErrorAnalysisView(errorMessage: string) {
                                                startAnalysis() // Your retry function
                                            }
                                            
                                        case nil:
                                            ReadyToAnalyzeView {
                                                startAnalysis() // Your start analysis function
                                            }
                                        
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                    }
                }
            }
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
            .onAppear {
                startAnalysis()
            }
            .alert("Analysis Error", isPresented: Binding(get: {
                aiManager.showError
            }, set: { value in
                aiManager.showError = value
            })) {
                Button("Try Again") {
                    startAnalysis()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(aiManager.errorMessage)
            }
        }
    }
    
    // MARK: - Image Views
    
    private var singleImageView: some View {
        VStack(spacing: 12) {
            Text("Your Outfit")
                .font(.headline)
                .foregroundColor(.primary)
            
            Image(uiImage: images.first!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
    }
    
    private var comparisonImageView: some View {
        VStack(spacing: 16) {
            Text("Comparing Outfits")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        VStack(spacing: 8) {
                            Text("Outfit \(index + 1)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Analysis Views
    
    private var analysisLoadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(1.2)
            
            Text("AI is analyzing your fashion...")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("This may take a few moments")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
    
    private var analysisResultView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text("AI Analysis")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text("")
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: {
                    startAnalysis()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("Re-analyze")
                    }
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    shareAnalysis()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var analysisPromptView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 40))
                .foregroundColor(.purple)
            
            Text("Ready to Analyze")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Tap the button below to start AI analysis")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                startAnalysis()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("Start Analysis")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .pink]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
    
    // MARK: - Analysis Functions
    
    private func startAnalysis() {
        aiManager.isAnalyzing = true
        
        Task {
            do{
                try await aiManager.performOpenAIAnalysis(reviewType: reviewType)
            }catch{
                print(error)
            }
        }
    }

    
    

    private func shareAnalysis() {
        let activityController = UIActivityViewController(
            activityItems: [],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}


struct ReviewAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewAnalysisView(
            images: [UIImage(systemName: "person.fill")!],
            reviewType: .single
        )
    }
}
