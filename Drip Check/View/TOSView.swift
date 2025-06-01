//
//  TermsOfServiceView.swift
//  DripCheck
//
//  Created by Matthew Tjoa on 2025-05-31.
//

import SwiftUI

struct TermsOfServiceView: View {
    @State private var hasScrolledToEnd = false
    @State private var hasAccepted = false
    @Environment(\.dismiss) private var dismiss
    @State var showAccept = true
    var onAccept: () -> Void
    var onDecline: () -> Void
    init(showAccept: Bool = true, onAccept: @escaping () -> Void, onDecline: @escaping () -> Void) {
        self.showAccept = showAccept
        self.onAccept = onAccept
        self.onDecline = onDecline
    }
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.95, blue: 0.97),
                        Color(red: 0.90, green: 0.90, blue: 0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Terms of Service")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        if showAccept{
                            Text("Please read and accept to continue")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    // Terms Content
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                termsContent
                                
                                // End marker for scroll detection
                                HStack {
                                    Spacer()
                                    Text("• End of Terms •")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .onAppear {
                                            hasScrolledToEnd = true
                                        }
                                    Spacer()
                                }
                                .id("endOfTerms")
                                .padding(.top, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.8))
                                .padding(.horizontal, 16)
                        )
                        .padding(.top, 20)
                    }
                    
                    // Action Buttons
                    if showAccept {
                        VStack(spacing: 12) {
                            // Accept Button
                            Button(action: {
                                hasAccepted = true
                                onAccept()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle")
                                        .font(.title3)
                                    Text("I Accept")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: hasScrolledToEnd ? [.green, .blue] : [.gray, .gray]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: hasScrolledToEnd ? .green.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                            }
                            .disabled(!hasScrolledToEnd)
                            .animation(.easeInOut(duration: 0.3), value: hasScrolledToEnd)
                            
                            // Decline Button
                            Button(action: {
                                onDecline()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "xmark.circle")
                                        .font(.title3)
                                    Text("Decline")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                        .background(Color.white.opacity(0.5))
                                )
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var termsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                TermsSection(
                    title: "1. Acceptance of Terms",
                    content: "By using DripCheck (\"the App\"), you agree to these Terms of Service. If you do not agree, please do not use the App."
                )
                
                TermsSection(
                    title: "2. Privacy & Photos",
                    content: "• Your photos are processed locally when possible\n• We may use AI services to analyze your fashion\n• Photos are not stored permanently without consent\n• We do not share your images with third parties\n• You retain ownership of your photos"
                )
                
                TermsSection(
                    title: "3. AI Analysis Disclaimer",
                    content: "• Fashion critiques are AI-generated opinions\n• Results are for entertainment and guidance only\n• We do not guarantee accuracy of fashion advice\n• Personal style preferences may vary\n• Use advice at your own discretion"
                )
                
                TermsSection(
                    title: "4. Age Requirements",
                    content: "You must be at least 13 years old to use this App. Users under 18 should have parental consent."
                )
                
                TermsSection(
                    title: "5. Acceptable Use",
                    content: "• Do not upload inappropriate or offensive content\n• Respect others in any community features\n• Do not attempt to reverse engineer AI models\n• Use the App for personal, non-commercial purposes"
                )
            }
            
            Group {
                TermsSection(
                    title: "6. Limitation of Liability",
                    content: "DripCheck is provided \"as is\" without warranties. We are not liable for any damages resulting from use of fashion advice or the App."
                )
                
                TermsSection(
                    title: "7. Data Usage",
                    content: "• We may collect usage analytics\n• Crash reports help improve the App\n• No personal data is sold to advertisers\n• You can request data deletion anytime"
                )
                
                TermsSection(
                    title: "8. Updates to Terms",
                    content: "We may update these terms occasionally. Continued use of the App constitutes acceptance of updated terms."
                )
                
                TermsSection(
                    title: "9. Contact Information",
                    content: "For questions about these terms, contact us at: support@dripcheck.app"
                )
                
                Text("Last updated: May 31, 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
    }
}

struct TermsSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// Preview
struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView(
            onAccept: {
                print("Terms accepted")
            },
            onDecline: {
                print("Terms declined")
            }
        )
    }
}
