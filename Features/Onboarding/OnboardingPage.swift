// OnboardingPage.swift
// Layer: Presentation
// Purpose: The four things a new player must understand before the first level, each one a figure and two lines.
// Iris is a game: nothing here promises any medical, therapeutic or clinical effect

import Foundation

struct OnboardingPage: Hashable, Sendable, Identifiable {
    /// Which drawing explains the page.
    enum Figure: Hashable, Sendable, CaseIterable {
        /// The gaze arrives and the lueur moves away from it.
        case repulsion
        /// The gaze sits on the lueur, which is pushed away from where it must go.
        case directStare
        /// The gaze sits beside the lueur, which is guided toward its iris.
        case indirectGaze
        /// The lueur reaches the iris that was waiting for it.
        case destination
    }

    let figure: Figure
    let title: String
    let detail: String
    /// What the drawing shows, for VoiceOver.
    let figureDescription: String

    var id: Figure { figure }

    /// The onboarding, in order. Four pages, no more.
    static let all: [OnboardingPage] = [
        OnboardingPage(figure: .repulsion,
                       title: IrisText.interface("onboarding.repulsion.title", french: "Votre regard repousse les sphères"),
                       detail: IrisText.interface("onboarding.repulsion.detail", french: "Iris suit la direction de votre regard. Là où vous regardez, la sphère s'écarte."),
                       figureDescription: IrisText.interface("onboarding.repulsion.figure", french: "Un regard à gauche, une sphère à droite qui s'éloigne de lui.")),
        OnboardingPage(figure: .directStare,
                       title: IrisText.interface("onboarding.directStare.title", french: "Ne fixez pas la sphère"),
                       detail: IrisText.interface("onboarding.directStare.detail", french: "La regarder droit dessus la chasse — souvent loin de l'endroit où vous vouliez l'emmener."),
                       figureDescription: IrisText.interface("onboarding.directStare.figure", french: "Un regard posé sur la sphère, qui part à l'opposé de l'iris.")),
        OnboardingPage(figure: .indirectGaze,
                       title: IrisText.interface("onboarding.indirectGaze.title", french: "Regardez autour d'elle pour la guider"),
                       detail: IrisText.interface("onboarding.indirectGaze.detail", french: "Posez votre attention à côté de la sphère : elle glisse doucement du côté opposé."),
                       figureDescription: IrisText.interface("onboarding.indirectGaze.figure", french: "Un regard posé à gauche de la sphère, qui glisse vers la droite.")),
        OnboardingPage(figure: .destination,
                       title: IrisText.interface("onboarding.destination.title", french: "Guidez les sphères vers leur iris"),
                       detail: IrisText.interface("onboarding.destination.detail", french: "Chaque sphère a un iris qui l'attend. Amenez-la jusqu'à lui, et le niveau est atteint."),
                       figureDescription: IrisText.interface("onboarding.destination.figure", french: "Une sphère qui rejoint l'iris ouvert au bout de son chemin.")),
    ]
}
