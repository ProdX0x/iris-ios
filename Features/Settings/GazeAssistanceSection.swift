// GazeAssistanceSection.swift
// Layer: Presentation
// Purpose: The settings home of the gaze assistance choice: the detailed picker, its one line of context, and the
// way back to the three introduction screens. The choice itself lives in GazeAssistancePicker, shared with the pause

import SwiftUI

struct GazeAssistanceSection: View {
    @Binding var mode: GazeAssistanceMode
    /// Opens the three introduction screens again.
    let onReviewIntroduction: () -> Void

    var body: some View {
        DSGlassPanel {
            Text("aide au regard").dsEyebrowStyle()
            Text("Le repère montre où Iris estime que vous regardez.")
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.Identity.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            GazeAssistancePicker(mode: $mode, variant: .detailed)
            DSButton("Revoir l'explication", systemImage: "questionmark.circle", variant: .ghost, action: onReviewIntroduction)
        }
    }
}

#Preview {
    ZStack {
        DSBackground(intensity: .calm)
        GazeAssistanceSection(mode: .constant(.guided), onReviewIntroduction: {})
            .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
