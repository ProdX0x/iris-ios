// DSGlassGallery.swift
// Layer: Tests
// Purpose: Development gallery of the Liquid Glass roles over a plain ground and a richer demonstration ground, shown
// by the test host for screenshots (the phase 2 reference pages); never reachable in the app

import SwiftUI
@testable import Iris

struct DSGlassGallery: View {
    enum Page: String, CaseIterable, Sendable {
        case roles
        case comparaison
        case texte
    }

    enum Ground: String, CaseIterable, Sendable {
        case simple
        case riche
    }

    let page: Page
    let ground: Ground

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric private var controlSize: CGFloat = 48

    private let longText = "Le verre laisse passer le fond : ce texte doit se lire sans effort, quoi qu'il passe derrière. Le panneau grandit avec son contenu, sans hauteur fixe."

    var body: some View {
        ZStack {
            switch ground {
            case .simple: DSColor.Identity.ground.ignoresSafeArea()
            case .riche: GalleryDemoGround().ignoresSafeArea()
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("galerie liquid glass · développement").dsEyebrowStyle()
                        label(stateLine)
                    }
                    .dynamicTypeSize(.large)
                    switch page {
                    case .roles: roles
                    case .comparaison: comparison
                    case .texte: text
                    }
                }
                .padding(.horizontal, DSSpacing.gutter)
                .padding(.top, DSSpacing.s)
            }
        }
    }

    private var stateLine: String {
        "verre natif \(DSGlassRendering.isNativeGlassAvailable ? "oui" : "non") · transparence réduite \(reduceTransparency ? "oui" : "non") · contraste \(contrast == .increased ? "élevé" : "standard") · fond \(ground.rawValue)"
    }

    private func label(_ text: String) -> some View {
        Text(text).font(DSFont.footnote).foregroundStyle(DSColor.Identity.textSecondary)
    }

    private func control(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(DSFont.headline)
            .frame(width: controlSize, height: controlSize)
            .dsGlass(.clearControl)
    }

    private func chromeItem(_ symbol: String, _ title: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: symbol).font(DSFont.headline)
            Text(title).font(DSFont.footnote)
        }
        .frame(maxWidth: .infinity, minHeight: 48)
    }

    private var roles: some View {
        VStack(alignment: .leading, spacing: 12) {
            label("1 · contrôles clairs, séparés")
            HStack(spacing: 16) {
                control("pause.fill")
                control("xmark")
                control("gearshape")
            }
            label("5 · contrôles réunis dans un DSGlassGroup")
            DSGlassGroup(spacing: 8) {
                HStack(spacing: 8) {
                    control("backward.end.fill")
                    control("pause.fill")
                    control("forward.end.fill")
                }
            }
            label("2 · panneau régulier, texte court")
            VStack(alignment: .leading, spacing: 4) {
                Text("pause").font(DSFont.title)
                Text("III · courants — la brèche").font(DSFont.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DSSpacing.l)
            .dsGlass(.regularPanel)
            label("7 · panneau régulier, texte long")
            Text(longText)
                .font(DSFont.body)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DSSpacing.l)
                .dsGlass(.regularPanel)
            label("3 · chrome")
            HStack(spacing: 0) {
                chromeItem("circle.hexagongrid", "chapitres")
                chromeItem("book.closed", "carnet")
                chromeItem("gearshape", "réglages")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .dsGlass(.chrome)
            label("4 · action proéminente")
            Text("Commencer")
                .font(DSFont.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .dsGlass(.prominentAction)
        }
    }

    @ViewBuilder
    private func sample(_ role: DSGlassRole) -> some View {
        switch role {
        case .clearControl:
            Image(systemName: "pause.fill").font(DSFont.headline).frame(width: controlSize, height: controlSize)
        case .regularPanel:
            Text("Aa").font(DSFont.title).frame(width: 96, height: 72)
        case .chrome:
            HStack(spacing: 14) {
                Image(systemName: "book.closed")
                Image(systemName: "gearshape")
            }
            .font(DSFont.headline)
            .frame(width: 96, height: 44)
        case .prominentAction:
            Text("Aller").font(DSFont.headline).frame(width: 96, height: 44)
        }
    }

    private var comparison: some View {
        VStack(alignment: .leading, spacing: 14) {
            label("colonne 1 : le rendu que le système choisit ici · colonnes 2 et 3 : surfaces de repli affichées directement, forcées pour comparaison")
            HStack(spacing: 8) {
                label("choisi ici").frame(maxWidth: .infinity)
                label("repli iOS 17–25").frame(maxWidth: .infinity)
                label("opaque (forcé)").frame(maxWidth: .infinity)
            }
            ForEach(DSGlassRole.allCases, id: \.self) { role in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        sample(role).dsGlass(role).frame(maxWidth: .infinity)
                        sample(role).modifier(DSGlassSurface(role: role, shape: role.defaultShape, rendering: .translucent)).frame(maxWidth: .infinity)
                        sample(role).modifier(DSGlassSurface(role: role, shape: role.defaultShape, rendering: .opaque)).frame(maxWidth: .infinity)
                    }
                    label(String(describing: role))
                }
            }
            label("référence système, hors rôles : .buttonStyle(.glass), .glassProminent teinté, .glass en cercle")
            systemReference
        }
    }

    @ViewBuilder
    private var systemReference: some View {
        if #available(iOS 26.0, *) {
            HStack(spacing: 12) {
                Button("Verre") {}.buttonStyle(.glass)
                Button("Proéminent") {}.buttonStyle(.glassProminent).tint(DSColor.Navigation.primary)
                Button {} label: { Image(systemName: "xmark") }.buttonStyle(.glass).buttonBorderShape(.circle)
            }
        } else {
            label("boutons système Liquid Glass indisponibles avant iOS 26")
        }
    }

    private var text: some View {
        VStack(alignment: .leading, spacing: 14) {
            label("taille de texte appliquée à la vue : \(String(describing: typeSize))").dynamicTypeSize(.large)
            VStack(alignment: .leading, spacing: 8) {
                Text("résultat").font(DSFont.title)
                Text(longText).font(DSFont.body).fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DSSpacing.l)
            .dsGlass(.regularPanel)
            HStack(spacing: 12) {
                control("xmark")
                Text("Chapitre suivant")
                    .font(DSFont.headline)
                    .padding(.horizontal, DSSpacing.m)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .dsGlass(.prominentAction)
            }
        }
    }
}
