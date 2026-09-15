// DSGlassSelectionGallery.swift
// Layer: Tests
// Purpose: « Sélection Iris Liquid Glass »: the validated clear control beside candidate panels, chrome and prominent
// actions and two panel radii, on one page and on focused pages; development only, its colours are not tokens

import SwiftUI
@testable import Iris

struct DSGlassSelectionGallery: View {
    enum Page: String, CaseIterable, Sendable {
        case selection
        case largeText
        case panels
        case chrome
        case prominent
    }

    let page: Page
    let ground: GalleryDemoGround.Intensity

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric private var controlSize: CGFloat = 44

    private struct Candidate: Hashable {
        let name: String
        let recipe: DSGlassRecipe
    }

    private struct ChromeItem: Hashable {
        let symbol: String
        let title: String
    }

    private enum Action {
        case current
        case neutral
        case spectral
        case system
    }

    private static let panelCandidates = [Candidate(name: "current", recipe: SelectionRecipes.panelCurrent),
                                          Candidate(name: "airy", recipe: SelectionRecipes.panelAiry),
                                          Candidate(name: "balanced", recipe: SelectionRecipes.panelBalanced)]
    private static let chromeCandidates = [Candidate(name: "current", recipe: SelectionRecipes.chromeCurrent),
                                           Candidate(name: "clear", recipe: SelectionRecipes.chromeClear),
                                           Candidate(name: "balanced", recipe: SelectionRecipes.chromeBalanced)]
    private static let chromeItems = [ChromeItem(symbol: "circle.hexagongrid", title: "chapitres"),
                                      ChromeItem(symbol: "book.closed", title: "carnet"),
                                      ChromeItem(symbol: "gearshape", title: "réglages")]
    private static let longText = "Le verre laisse passer le fond : ce texte doit se lire sans effort, quoi qu'il passe derrière. Le panneau grandit avec son contenu, sans hauteur fixe."

    var body: some View {
        ZStack {
            GalleryDemoGround(intensity: ground).ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("sélection iris liquid glass").dsEyebrowStyle()
                        caption("verre natif \(DSGlassRendering.isNativeGlassAvailable ? "oui" : "non") · transparence réduite \(reduceTransparency ? "oui" : "non") · contraste \(contrast == .increased ? "élevé" : "standard") · fond \(ground.rawValue) · texte \(String(describing: typeSize))")
                    }
                    .dynamicTypeSize(.large)
                    switch page {
                    case .selection: selection
                    case .largeText: largeText
                    case .panels: panels
                    case .chrome: chrome
                    case .prominent: prominent
                    }
                }
                .padding(.horizontal, DSSpacing.gutter)
                .padding(.top, DSSpacing.s)
            }
        }
    }

    private var selection: some View {
        VStack(alignment: .leading, spacing: 8) {
            section("clear control · validé")
            HStack(spacing: 12) {
                control("pause.fill")
                control("xmark")
                control("gearshape")
            }
            section("panneaux")
            HStack(alignment: .top, spacing: 8) {
                ForEach(Self.panelCandidates, id: \.name) { candidate in
                    labelled(candidate.name) { panel(candidate.recipe, compact: true) }
                }
            }
            section("chrome")
            VStack(spacing: 6) {
                ForEach(Self.chromeCandidates, id: \.name) { candidate in
                    HStack(spacing: 8) {
                        caption(candidate.name).dynamicTypeSize(.large).frame(width: 58, alignment: .leading)
                        chromeBar(candidate.recipe, labels: false)
                    }
                }
            }
            section("action principale")
            VStack(spacing: 6) {
                HStack(alignment: .top, spacing: 8) {
                    labelled("current phase 2") { action(.current, height: 44) }
                    labelled("neutral") { action(.neutral, height: 44) }
                }
                HStack(alignment: .top, spacing: 8) {
                    labelled("spectral") { action(.spectral, height: 44) }
                    labelled("système glassProminent") { action(.system, height: 44) }
                }
            }
            section("rayon · panneau balanced")
            HStack(alignment: .top, spacing: 8) {
                labelled("22 pt (actuel)") { panel(SelectionRecipes.panelBalanced, radius: 22, compact: true) }
                labelled("16 pt") { panel(SelectionRecipes.panelBalanced, radius: 16, compact: true) }
            }
        }
    }

    private var largeText: some View {
        VStack(alignment: .leading, spacing: 10) {
            section("panneaux en grande taille de texte")
            ForEach(Self.panelCandidates, id: \.name) { candidate in
                labelled(candidate.name) { panel(candidate.recipe) }
            }
        }
    }

    private var panels: some View {
        VStack(alignment: .leading, spacing: 10) {
            section("panneaux · titre, corps court, corps long")
            ForEach(Self.panelCandidates, id: \.name) { candidate in
                labelled(candidate.name) { panel(candidate.recipe, long: true) }
            }
        }
    }

    private var chrome: some View {
        VStack(alignment: .leading, spacing: 22) {
            section("chrome · future barre flottante, simulée (pas une TabView)")
            ForEach(Self.chromeCandidates, id: \.name) { candidate in
                labelled(candidate.name) { chromeBar(candidate.recipe, labels: true) }
            }
        }
    }

    private var prominent: some View {
        VStack(alignment: .leading, spacing: 18) {
            section("action principale · une seule par écran")
            labelled("current phase 2") { action(.current, height: 52) }
            labelled("neutral glass · accent sur le texte et le contour") { action(.neutral, height: 52) }
            labelled("spectral hint · teinte expérimentale, galerie seulement") { action(.spectral, height: 52) }
            labelled("référence système · glassProminent") { action(.system, height: 52) }
            HStack(spacing: 12) {
                control("xmark")
                caption("à côté du contrôle clair validé")
            }
        }
    }

    private func caption(_ text: String) -> some View {
        Text(text).font(DSFont.caption).foregroundStyle(DSColor.Identity.textSecondary)
    }

    private func section(_ text: String) -> some View {
        Text(text).dsEyebrowStyle().dynamicTypeSize(.large).padding(.top, 4)
    }

    private func labelled<Content: View>(_ name: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            content()
            caption(name).dynamicTypeSize(.large)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func control(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(DSFont.headline)
            .frame(width: controlSize, height: controlSize)
            .dsGlass(.clearControl)
    }

    private func panel(_ recipe: DSGlassRecipe, radius: CGFloat = DSRadius.l, compact: Bool = false, long: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: compact ? 2 : 6) {
            Text("pause").font(compact ? DSFont.headline : DSFont.title)
            Text("III · courants — la brèche")
                .font(compact ? DSFont.caption : DSFont.callout)
                .fixedSize(horizontal: false, vertical: true)
            if long {
                Text(Self.longText).font(DSFont.body).fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(compact ? 12 : DSSpacing.l)
        .modifier(DSGlassModifier(role: .regularPanel, shape: .rounded(radius), recipe: recipe))
    }

    private func chromeBar(_ recipe: DSGlassRecipe, labels: Bool) -> some View {
        HStack(spacing: 0) {
            ForEach(Self.chromeItems, id: \.symbol) { item in
                VStack(spacing: 1) {
                    Image(systemName: item.symbol).font(DSFont.headline)
                    if labels {
                        Text(item.title).font(DSFont.caption)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: labels ? 50 : 40)
            }
        }
        .padding(.horizontal, 8)
        .modifier(DSGlassModifier(role: .chrome, recipe: recipe))
    }

    private func actionLabel(_ height: CGFloat) -> some View {
        Label("Commencer", systemImage: "eye")
            .font(DSFont.headline)
            .frame(maxWidth: .infinity, minHeight: height)
    }

    @ViewBuilder
    private func action(_ kind: Action, height: CGFloat) -> some View {
        switch kind {
        case .current:
            actionLabel(height).modifier(DSGlassModifier(role: .prominentAction, recipe: SelectionRecipes.prominentCurrent))
        case .neutral:
            actionLabel(height).modifier(DSGlassModifier(role: .prominentAction, recipe: SelectionRecipes.prominentNeutral))
        case .spectral:
            actionLabel(height).modifier(DSGlassModifier(role: .prominentAction, recipe: SelectionRecipes.prominentSpectral))
        case .system:
            if #available(iOS 26.0, *) {
                Button {} label: {
                    Label("Commencer", systemImage: "eye")
                        .font(DSFont.headline)
                        .frame(maxWidth: .infinity, minHeight: height - 14)
                }
                .buttonStyle(.glassProminent)
            } else {
                caption("glassProminent indisponible avant iOS 26")
            }
        }
    }
}

/// Candidate recipes compared by the gallery. The "current" ones are the roles' own recipes today; the others exist
/// only here until a human choice, and the spectral colour is exploratory, never a token.
private enum SelectionRecipes {
    static let panelCurrent = DSGlassRole.regularPanel.recipe
    static let panelAiry = DSGlassRecipe(.clear, tint: DSColor.Identity.ground.opacity(0.12))
    static let panelBalanced = DSGlassRecipe(.clear, tint: DSColor.Identity.ground.opacity(0.32))
    static let chromeCurrent = DSGlassRole.chrome.recipe
    static let chromeClear = DSGlassRecipe(.clear)
    static let chromeBalanced = DSGlassRecipe(.clear, tint: DSColor.Identity.ground.opacity(0.2))
    static let prominentCurrent = DSGlassRole.prominentAction.recipe
    static let prominentNeutral = DSGlassRecipe(.clear, foreground: DSColor.Navigation.primary, edge: DSColor.Navigation.primary.opacity(0.5), interactive: true)
    static let spectral = Color(red: 0.58, green: 0.54, blue: 1.0)
    static let prominentSpectral = DSGlassRecipe(.clear, tint: spectral.opacity(0.2), interactive: true)
}
