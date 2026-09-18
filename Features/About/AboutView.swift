// AboutView.swift
// Layer: Presentation
// Purpose: One page, pushed from the settings: which Iris runs, who made it, and the addresses — site, assistance,
// privacy policy, licence. It opens nothing itself: the system does, and Iris keeps no trace of it

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView(showsIndicators: false) {
            // Little text, four panels: the column breathes through the glass itself rather than through gaps.
            // The identity joins the version panel — the page names Iris once, then says who made it.
            VStack(alignment: .leading, spacing: DSSpacing.m) {
                DSGlassPanel {
                    VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                        Text(AboutCopy.appName)
                            .font(DSFont.title2)
                            .foregroundStyle(DSColor.Identity.textPrimary)
                        Text(AboutCopy.versionLine)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(AboutCopy.role)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(AboutCopy.creatorName)
                            .font(DSFont.headline)
                            .foregroundStyle(DSColor.Identity.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                DSGlassPanel {
                    Text(IrisText.interface("about.support.eyebrow", french: "assistance")).dsEyebrowStyle()
                    VStack(alignment: .leading, spacing: DSSpacing.s) {
                        // The address stays readable and selectable: if no mail account can answer the link, it can
                        // still be copied.
                        Text(AboutCopy.contactEmail)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .textSelection(.enabled)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityLabel("Adresse de contact : \(AboutCopy.contactEmail)")
                        opener(AboutCopy.contactAction, systemImage: "envelope", url: AboutCopy.contactURL,
                               hint: IrisText.interface("about.contact.hint", french: "Ouvre un nouveau message vers l'assistance d'Iris"))
                    }
                }
                DSGlassPanel {
                    Text(IrisText.interface("about.links.eyebrow", french: "liens")).dsEyebrowStyle()
                    // Each action keeps the height a finger needs; only the gaps between them give way.
                    VStack(alignment: .leading, spacing: DSSpacing.s) {
                        opener(AboutCopy.siteTitle, systemImage: "safari", url: AboutCopy.siteURL,
                               hint: IrisText.interface("about.site.hint", french: "Ouvre le site officiel d'Iris"))
                        opener(AboutCopy.privacyTitle, systemImage: "hand.raised", url: AboutCopy.privacyURL,
                               hint: IrisText.interface("about.privacy.hint", french: "Ouvre la politique de confidentialité sur le site d'Iris"))
                        opener(AboutCopy.termsTitle, systemImage: "doc.text", url: AboutCopy.termsURL,
                               hint: IrisText.interface("about.terms.hint", french: "Ouvre le contrat de licence standard sur le site d'Apple"))
                    }
                    Text(AboutCopy.termsDetail)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(AboutCopy.copyright)
                    .font(DSFont.caption)
                    .foregroundStyle(DSColor.Identity.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            // The navigation bar already gives the column its top margin: the content starts just under it,
            // so the copyright has a chance of reaching the bottom of the screen without a scroll.
            .padding(.horizontal, DSSpacing.gutter)
            .padding(.top, DSSpacing.s)
            .padding(.bottom, DSSpacing.gutter)
        }
        .dsSoftScrollEdges()
        .background { DSBackground(intensity: .calm) }
        .navigationTitle(IrisText.interface("about.title", french: "à propos"))
        .navigationBarTitleDisplayMode(.inline)
    }

    /// One address, one action. The destination belongs to the system: Iris never renders a page itself.
    @ViewBuilder
    private func opener(_ title: String, systemImage: String, url: URL?, hint: String) -> some View {
        DSButton(title, systemImage: systemImage, variant: .secondary) {
            if let url { openURL(url) }
        }
        .accessibilityHint(hint)
        .disabled(url == nil)
    }
}

// The page is always pushed inside the navigation the settings already own: the preview shows it alone, so that no
// screen outside Navigation/ and the three sheets ever builds navigation chrome of its own (DSGlassTests, test K).
#Preview {
    AboutView()
        .preferredColorScheme(.dark)
}
