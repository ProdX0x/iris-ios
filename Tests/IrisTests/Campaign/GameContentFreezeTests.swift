// GameContentFreezeTests.swift
// Layer: Tests
// Purpose: What the interface phases must never touch keeps its exact sources and values: the engine, game loop,
// audio, haptics, progression and calibration flow, the X·7 level, the data of the 82 levels, the mechanics

import CryptoKit
import Foundation
import Testing
@testable import Iris

@Suite("Game content freeze")
@MainActor
struct GameContentFreezeTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Campaign/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// G. The engine, game loop and clocks, audio, haptics, progression and calibration flow, as the colour-role
    /// separation found them (files already frozen by HistoricalCampaignFingerprintTests or OculoAncreTests are not repeated).
    static let engine: [String: String] = [
        "GameEngine/Campaign/HintTracker.swift": "b1743ff99676c598beaf4ce433eb783ed27c87b2ce5db128416fae1742e6a8d8",
        "GameEngine/Campaign/LevelResolver.swift": "d794df09c96de71bfda39d03d1f9b8c89bfe04649375c07a657d8f29e89f71ff",
        "GameEngine/Campaign/ResolvedLevel.swift": "f8c00261bf132412b94bd42bdbe0dee66565a1da4f04415240ffd750ef60ffb8",
        "GameEngine/Clock/GameClock.swift": "c421d092755821ddd30bf11e2dea2467f9b8412d3319f05cfab02cbf4d4b4735",
        "GameEngine/Clock/ManualGameClock.swift": "ec541cb5d61f3bd74387121c8d04621ce7eba11fc99bcdf1d1221e05faa9d0be",
        "GameEngine/Noise/NoiseSource.swift": "7aa1b82425dd1960480024152a1d24cec31bab9d162169fb6b598e06fa5ecff0",
        "GameEngine/Noise/SilentNoise.swift": "1b1e0287c5f8a764f2716da36ca25361245249cd50125ccca4940ce5f47c4cb7",
        "GameEngine/Noise/ValueNoise1D.swift": "fddce381cb0d4286f951f77573f7d0e0942e7767fe568ccd4231acb232079775",
        "GameEngine/Session/GameEvent.swift": "8c81ee1a195806e326a7cf19abc101550ac327b3fbdf82e034ade926ec0d3e18",
        "GameEngine/Session/GameSession.swift": "e481fe6cfe849b7cf8566f92197959f0dacd1cd0778dea6d8d2f4c6612fdcc9e",
        "GameEngine/Session/SessionMetrics.swift": "48c198a2a7ef9688bdaacf9ab175f1c5bdb39d4016fa420e01631ef4b4420e78",
        "Audio/Policy/AudioCue.swift": "4584b748c9630fdf347ec57418abfacceeb22ad450886ff8847a62b219570928",
        "Audio/Policy/AudioCuePolicy.swift": "adc4cfecbdb90040e1ff8a4f57fed5101a86fb822e9e7675870791800b44c57e",
        "Audio/Services/AVAudioEngineAudioService.swift": "216812ee06b37faaa7c7a918d7086fe4d5123e981dcd82fd775e9135f4c218ba",
        "Audio/Services/AudioService.swift": "66372045a64ab058a3978e220844c12faad467bfd5305d18e30a779f9df25632",
        "Audio/Services/NotificationObserverBag.swift": "821f882bb6adb82aac7e2b1c73d7a665891d21974c0529d46ecc9ffe667cb234",
        "Audio/Services/SilentAudioService.swift": "818aaf636c6bd381fa09297a71b310c3cd919ada75c94ee729f5562a160167e4",
        "Audio/Synth/SineSynth.swift": "161ae2dc01fa36e92652999fc88f51c1e4beb14d2c87d4d0fe5afbb925585db1",
        "Haptics/Policy/HapticCue.swift": "c7a6def7b50bfe75046a0788fdccb8f21a9a0c861570e991110ea0911521819b",
        "Haptics/Policy/HapticCuePolicy.swift": "bd5452fee2fefa767d7740218c4c832cf6fd975a1d9747498cb6781fcbda3501",
        "Haptics/Services/HapticFeedbackService.swift": "c6c0566d839d827bb8e2559e9db53e8748de1ca58f38ea2e328ddba9425f8598",
        "Haptics/Services/SilentHapticFeedbackService.swift": "6605b617304047166a86b53ccd49638da2ec1069161db6053dccfed362ecd658",
        "Haptics/Services/UIKitHapticFeedbackService.swift": "ab6a6f5270ea67037be6c9bbb222a27b584212d708d77ecb7027402d6f7317ff",
        "Domain/Feedback/FeedbackTiming.swift": "2daa59f3867f8fedd64ef9f42dbd6b5756b8ad9284df6e1a8d2d07fdb823bc33",
        "Domain/Progress/CampaignProgress.swift": "ae9b19923159d43b037b31ad881e33f65c5c38addecb37f1a589129b86256de9",
        "Domain/Progress/Eclat.swift": "b1d5e1eb3588469105f25cf2c9c02502b5b5ae4dd4f4a462146fa12ee372644f",
        "Domain/Progress/LevelOutcome.swift": "8b37a415ab6ea71fa193cd8f9eade1c3c829bd9d72c53c76863908e42efdaa38",
        "Domain/Progress/LevelRecord.swift": "32bc9e28fc7f96fbe0d9169bd2259454e678edc0bec1791a26e11d26c1064cf2",
        "Domain/Progress/ProgressStore.swift": "6319eb8305307d18d3562b89a9fc359e242f74728bd1ababd19a051bf07c231a",
        "Features/Game/ViewModels/GameViewModel.swift": "5f7780048921e6dd0880c06658f0c20591beedaae509bea85b30b658d50016a9",
        "Features/GazeSetup/ViewModels/GazeSetupViewModel.swift": "ae1a60cb3d9a28ecbbe3b19449d0e25b252b897056cba54fe5f4b2fe3c09ccbe",
        "App/Platform/DisplayLinkGameClock.swift": "7d2aa0eff275c972af2db3db34567fde506cf29ce13fe323af4844fbe501ee8e",
    ]

    /// H. Level X·7 (Option A): stage machine, data, silhouette, snapshot, DEBUG capture and trace, byte for byte. The renderer
    /// extension was re-hashed once, after the colour-role separation renamed its five colour references to chapter tokens.
    static let ancre: [String: String] = [
        "GameEngine/Oculo/AncreStageState.swift": "e54ccebdb3c5fe79d1f649c262b850abd4032f9210183a7dfbfb9650d151c639",
        "Domain/Campaign/Campaign+FinalGouffres.swift": "00392a1188e4be8fc598cc0cfe84fbe4796cb443422b4061ca4d6adb405775a7",
        "Domain/Campaign/OculoDefinition.swift": "abd4a5502039eea42eb811801e20a2140fb3347685ff9b4b6540bab09ad24b73",
        "Features/Game/Rendering/AncreSilhouette.swift": "b68864b7649407b1d7a39911ca8eca631544defc30ab79f206a813e2e7b031a7",
        "Features/Game/Rendering/AncreSceneSnapshot.swift": "e83c2942199084e421702449f3d0c5f086e10ae4782fef0e4940dba06129e1d9",
        "Features/Game/Rendering/GameSceneRenderer+Ancre.swift": "9edaac53c697ab9a4c6b1b969d038336f6a023391d5ab6cfef9d6d4a592da9ca",
        "Features/Game/Diagnostics/AncreCapture.swift": "803d48fc6ee1f0a2aecc31f5b50b2262a0cfa980ca48d84b79922760e343f1ec",
        "Features/Game/Diagnostics/OculomotorTrace.swift": "46c94a27f068c687d0408a92e048dc18756a4e38a674444a029ebb0547502572",
    ]

    /// I. The campaign data types and assembly not already frozen elsewhere (chapter files and finals are).
    static let levelData: [String: String] = [
        "Domain/Campaign/BaliseSequenceDefinition.swift": "aeaae60d72358d6691fe46f44d0e00429c8c5398fc2271f1abc29e019bac843c",
        "Domain/Campaign/BraiseDefinition.swift": "7e7b5d3cabf026f7c262cde57192a1c4d3dd59dae983666f6dd5dfd3a1b09c34",
        "Domain/Campaign/BraisesPrototype.swift": "9647dfb671f6ae511ae6836bc1fb01512d6bdbb20bbc795f95702a5490b0d48e",
        "Domain/Campaign/Campaign+OculomotorFinals.swift": "b9e3b31e9c86cb6ab6213b60c46a9262a2d89e92e51d32e4e1118950ce0eedde",
        "Domain/Campaign/Campaign.swift": "e51d0442b63eca7f32725cfc5a0d2cdddb58e7fe159175de67c1535891485765",
        "Domain/Campaign/ChapterDefinition.swift": "f57cf6a8fc82267811c8870537657c1b588ae6c3204e43086caab2a42f9f204a",
        "Domain/Campaign/ChapterTheme.swift": "cb9742e387c07cdd10e7db9509793ac99be645bf7ab4efbcef7e9e5e72cafeb5",
        "Domain/Campaign/CurrentDefinition.swift": "70651cb6a5f116dcb590187dd67db60c3282ead9705c9936c36a7739ab1d3175",
        "Domain/Campaign/EchoDefinition.swift": "86d85e764fc08afb59de178a6d092afa3b7bc5427b090eb72731ccdd14a232fe",
        "Domain/Campaign/GameElement.swift": "09cd4cc30acfdae23fbe72d991805969370d8e8e20a2acfa3f072c4aba52e350",
        "Domain/Campaign/GouffreDefinition.swift": "9fd561d56d3cb94afa2195fda6cf9d2544766aad4c1fa67a56c20dfa2fff66f1",
        "Domain/Campaign/IrisMotion.swift": "5ebf61fa53a27222bcd687224021e806650c77e0642194e1df3aecf5d5aafab3",
        "Domain/Campaign/LevelDefinition.swift": "8010a1459e1420ce883384deecc0a79cad9acac80bb3328a28a8ad41e067e16f",
        "Domain/Campaign/LevelHint.swift": "e107e49deea8af5bfcf98baefe84096f6944457f582967ea6921a44deb449105",
        "Domain/Campaign/LevelPar.swift": "bfcc84aebfc548e572e16b44b14746b58bbb015084d9bd76fe5bfd182dd13d54",
        "Domain/Campaign/LueurDefinition.swift": "c2e3afb162aedd8d9ab675de674ac5c340381bb095517c19241edecd3372fc74",
        "Domain/Campaign/SouffleDefinition.swift": "58641e7c79abd7029ade7c49922cb820898b669c2547dc9b101b7ac5c3c5d616",
        "Domain/Campaign/Temperament.swift": "6e4c0936826fdec9c2fbd7bd594adae69e5399e2aac302c22deb5ef6377fa25e",
        "Domain/Campaign/VeilDefinition.swift": "8903b0969b3e22ca0f93473b2b58317fa1f7cc04fe458af591dc4080ec9681f6",
        "Domain/Campaign/VeilleuseDefinition.swift": "a4b45f0b448d88293d1d304c942d687a71cb49bd4fec075639a157ff99c1d0df",
    ]

    /// J. The environment mechanics: currents, veils, souffles, echoes, gouffres, braises, twins, veilleuses, balises.
    static let mechanics: [String: String] = [
        "GameEngine/Environment/BaliseSequenceState.swift": "98700ffea79ebd30da2b8308db78adc18005ab055d4911b8116ed0d4eb561e95",
        "GameEngine/Environment/BraiseState.swift": "576ad1c972417eb936df3489b42c725eb48fcd027d5677718aedb1c3a865bd51",
        "GameEngine/Environment/CurrentField.swift": "03f10cf50bdbc32b7f978c341d930e57a2dadfe89f3567649ca5753f61648e87",
        "GameEngine/Environment/EchoField.swift": "4ba3eaa92fe468cb9df0f3c8755108686b934ab28f35c823e785b7eaa1b4bcf3",
        "GameEngine/Environment/GouffreField.swift": "0e454e520c1a5406f1a8dfc386a77622fbb83894ec4c88d7da44049060a183e3",
        "GameEngine/Environment/IrisPath.swift": "065ff3266f54d7c97f09ce022aaeb2eb8186061ea6fc932b01b9211b0cbca67f",
        "GameEngine/Environment/LevelEnvironment.swift": "7f049bfec5797713c929e8a202ec52e3a0caf1f1cca20a41859a30b18b6547f4",
        "GameEngine/Environment/SouffleField.swift": "af5e34638e1a84cde22864b226bd0a9551d91bd3e42b266d96f3af1b57824655",
        "GameEngine/Environment/TwinState.swift": "c298ce88eefee7523a4d4ea945380cd5383ac96dfecf810932f76b6f3c8af7ca",
        "GameEngine/Environment/VeilSegment.swift": "35e684336d791cd022834e7eabc49e04a259d27a7b4d63872f82e6461f4b338d",
        "GameEngine/Environment/VeilleuseState.swift": "4699c7ac459384706e378ed397bc4f7bcfe7afaccef2a8f60c5218ea6df59b19",
    ]

    private func expectUnchanged(_ table: [String: String]) throws {
        for (path, expected) in table.sorted(by: { $0.key < $1.key }) {
            let data = try Data(contentsOf: Self.projectRoot.appendingPathComponent(path))
            let digest: String = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
            #expect(digest == expected, "\(path) changed")
        }
    }

    @Test("G: the engine, game loop, audio, haptics, progression and calibration flow keep their sources")
    func engineUnchanged() throws {
        #expect(Self.engine.count == 32)
        try expectUnchanged(Self.engine)
    }

    @Test("H: X·7 keeps its stage machine, data, silhouette, capture, par 82, and stays an optional final")
    func ancreUnchanged() throws {
        try expectUnchanged(Self.ancre)
        let level = try #require(Campaign.level(id: "10-7"))
        #expect(level.par == LevelPar(time: 82, intrusions: 2))
        #expect(level.oculo != nil && !level.gatesProgression)
    }

    @Test("I: the 82 levels keep their count, ids and order, and the campaign data sources")
    func levelsUnchanged() throws {
        #expect(Campaign.levels.count == 82)
        #expect(Campaign.chapters.map(\.levels.count) == [6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7])
        for chapter in Campaign.chapters {
            #expect(chapter.levels.map(\.id) == chapter.levels.indices.map { "\(chapter.number)-\($0 + 1)" }, "chapter \(chapter.number)")
        }
        try expectUnchanged(Self.levelData)
    }

    @Test("J: the mechanics keep their sources and the timing constants their values")
    func mechanicsUnchanged() throws {
        try expectUnchanged(Self.mechanics)
        #expect(FeedbackTiming.lossRetriggerInterval == 0.15)
        #expect(GameViewModel.faceLostTimeout == 0.3)
        #expect(GameViewModel.helpDelay == 45)
        #expect(GazeSetupViewModel.readinessHold == 1.0)
        #expect(HintTracker.displayDuration == 4.5)
        #expect(Campaign.oculomotorDwell == 0.25)
    }
}
