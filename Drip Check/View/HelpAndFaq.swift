//
//  HelpAndFaq.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI


struct HelpFAQView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var expandedSections: Set<String> = []
    
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
                        VStack(spacing: 16) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.purple)
                            
                            Text("Help & FAQ")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Find answers to common questions about DripCheck")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search FAQ...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                        )
                        .padding(.horizontal, 16)
                        
                        // FAQ Sections
                        LazyVStack(spacing: 16) {
                            ForEach(filteredFAQSections, id: \.title) { section in
                                FAQSectionView(
                                    section: section,
                                    isExpanded: expandedSections.contains(section.title),
                                    onToggle: {
                                        toggleSection(section.title)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Contact Support Section
                        ContactSupportView()
                            .padding(.horizontal, 16)
                        
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
        }
    }
    
    private var filteredFAQSections: [FAQSection] {
        if searchText.isEmpty {
            return faqSections
        } else {
            return faqSections.compactMap { section in
                let filteredItems = section.items.filter { item in
                    item.question.localizedCaseInsensitiveContains(searchText) ||
                    item.answer.localizedCaseInsensitiveContains(searchText)
                }
                
                if !filteredItems.isEmpty {
                    return FAQSection(title: section.title, icon: section.icon, items: filteredItems)
                }
                return nil
            }
        }
    }
    
    private func toggleSection(_ sectionTitle: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if expandedSections.contains(sectionTitle) {
                expandedSections.remove(sectionTitle)
            } else {
                expandedSections.insert(sectionTitle)
            }
        }
    }
}

// MARK: - FAQ Section View

struct FAQSectionView: View {
    let section: FAQSection
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Header
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    Image(systemName: section.icon)
                        .foregroundColor(.purple)
                        .font(.system(size: 20))
                        .frame(width: 24)
                    
                    Text(section.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
            )
            
            // Section Content
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(section.items, id: \.question) { item in
                        FAQItemView(item: item)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

// MARK: - FAQ Item View

struct FAQItemView: View {
    let item: FAQItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Question Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundColor(isExpanded ? .orange : .purple)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.purple.opacity(0.1))
            )
            
            // Answer Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.answer)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                    
                    // Additional tips if available
                    if !item.tips.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💡 Tips:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            ForEach(item.tips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(.purple)
                                        .fontWeight(.bold)
                                    
                                    Text(tip)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.6))
                )
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Contact Support View

struct ContactSupportView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Still Need Help?")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Can't find what you're looking for? Our support team is here to help!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button(action: {
                    // Handle email support
                    if let url = URL(string: "mailto:matthewaureliustjoa@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                        Text("Email Support")
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
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - FAQ Data Models

struct FAQSection {
    let title: String
    let icon: String
    let items: [FAQItem]
}

struct FAQItem {
    let question: String
    let answer: String
    let tips: [String]
    
    init(question: String, answer: String, tips: [String] = []) {
        self.question = question
        self.answer = answer
        self.tips = tips
    }
}

// MARK: - FAQ Data

extension HelpFAQView {
    private var faqSections: [FAQSection] {
        [
            FAQSection(
                title: "Getting Started",
                icon: "play.circle.fill",
                items: [
                    FAQItem(
                        question: "How do I take my first fashion photo?",
                        answer: "Simply tap the 'Start Fashion Review' button on the home screen and select photos from your gallery or take new ones with your camera. Make sure you have good lighting and the full outfit is visible.",
                        tips: [
                            "Use natural lighting when possible",
                            "Stand against a plain background",
                            "Make sure your full outfit is visible"
                        ]
                    ),
                    FAQItem(
                        question: "What makes a good outfit photo?",
                        answer: "The best photos are well-lit, show your complete outfit from head to toe, and are taken against a clean background. Avoid blurry or dark photos for the most accurate analysis."
                    ),
                    FAQItem(
                        question: "Do I need to create an account?",
                        answer: "No account is required to use DripCheck! Your analyses are saved locally on your device."
                    )
                ]
            ),
            
            FAQSection(
                title: "AI Analysis",
                icon: "brain.head.profile",
                items: [
                    FAQItem(
                        question: "How accurate is the AI fashion analysis?",
                        answer: "Our AI uses OpenAI's advanced models to analyze fashion and style. While the insights are helpful, fashion is still a matter of personal taste.",
                        tips: [
                            "Use AI feedback as guidance, not absolute rules",
                            "Consider your personal style and comfort",
                            "Fashion is about expressing yourself!"
                        ]
                    ),
                    FAQItem(
                        question: "What's the difference between single review and comparison?",
                        answer: "Single review analyzes one outfit in detail with styling tips and scores. Comparison analyzes 2-3 outfits side by side to help you choose the best option for your occasion."
                    ),
                    FAQItem(
                        question: "Why did my analysis take so long?",
                        answer: "Analysis time depends on image size and server load. Most analyses complete within 30 seconds. Large images or poor internet connection may cause delays."
                    ),
                    FAQItem(
                        question: "Can I analyze multiple outfits at once?",
                        answer: "Yes! Use the comparison feature to analyze up to 3 outfits simultaneously. This is perfect for choosing between different outfit options."
                    )
                ]
            ),
            
            FAQSection(
                title: "Photos & Privacy",
                icon: "lock.shield.fill",
                items: [
                    FAQItem(
                        question: "Are my photos stored on your servers?",
                        answer: "Photos are only temporarily processed for analysis and are not permanently stored on our servers. Your privacy is our priority.",
                        tips: [
                            "Photos are processed securely",
                            "No permanent storage without consent",
                            "You can delete local history anytime"
                        ]
                    ),
                    FAQItem(
                        question: "Can I delete my fashion history?",
                        answer: "Yes! You can delete individual analyses or clear your entire history from the History tab. This action cannot be undone."
                    ),
                    FAQItem(
                        question: "Who can see my fashion analyses?",
                        answer: "Only you can see your analyses unless you choose to share them. We never share your photos or analyses with third parties without explicit permission."
                    )
                ]
            ),
            
            FAQSection(
                title: "Troubleshooting",
                icon: "wrench.and.screwdriver.fill",
                items: [
                    FAQItem(
                        question: "The app crashed during analysis. What should I do?",
                        answer: "Try restarting the app and ensure you have a stable internet connection. If the problem persists, contact support with details about when the crash occurred."
                    ),
                    FAQItem(
                        question: "My photos aren't uploading. Help!",
                        answer: "Check that DripCheck has permission to access your photos in Settings > Privacy > Photos. Also ensure you have sufficient storage space and internet connectivity.",
                        tips: [
                            "Check photo permissions in iOS Settings",
                            "Ensure stable internet connection",
                            "Free up storage space if needed"
                        ]
                    ),
                    FAQItem(
                        question: "The AI analysis seems wrong. Why?",
                        answer: "AI analysis works best with clear, well-lit photos showing complete outfits. Poor lighting, partial views, or unclear images may affect accuracy. Try retaking the photo with better conditions."
                    ),
                    FAQItem(
                        question: "Can I use screenshots or downloaded images?",
                        answer: "Yes, but results may vary. The AI works best with original photos taken in good lighting. Screenshots or heavily filtered images may not provide optimal analysis results."
                    )
                ]
            ),
            
            FAQSection(
                title: "Features & Tips",
                icon: "lightbulb.fill",
                items: [
                    FAQItem(
                        question: "How can I improve my fashion scores?",
                        answer: "Pay attention to the AI's specific feedback about color coordination, fit, and styling. Experiment with different combinations and use the tips provided in each analysis.",
                        tips: [
                            "Focus on proper fit and proportions",
                            "Pay attention to color harmony",
                            "Consider the occasion and dress code"
                        ]
                    ),
                    FAQItem(
                        question: "Can I share my fashion analysis with friends?",
                        answer: "Yes! Use the share button in your analysis results to send your fashion insights via message, email, or social media."
                    ),
                    FAQItem(
                        question: "Does the app work offline?",
                        answer: "You can view your saved analyses offline, but creating new analyses requires an internet connection for AI processing."
                    )
                ]
            )
        ]
    }
}

// MARK: - Preview

struct HelpFAQView_Previews: PreviewProvider {
    static var previews: some View {
        HelpFAQView()
    }
}
