import Foundation

struct SongInfo {
    let artist: String
    let title: String
    let lyrics: Lyrics

    struct Lyrics {
        let sentences: [Sentence]
    }

    struct Sentence: Identifiable {
        let id = UUID()
        let text: String
        let timestamp: TimeInterval
    }
}

enum Songs {
//    static let imagine = SongInfo(artist: "John Lennon", title: "Imagine", lyrics: .init(sentences: [
//        .init(lines: [.init(text: "Imagine there's no heaven", timestamp: 13)]),
//        .init(lines: [.init(text: "It's easy if you try", timestamp: 19)]),
//        .init(lines: [.init(text: "No hell below us", timestamp: 25)]),
//        .init(lines: [.init(text: "Above us only sky", timestamp: 33)]),
//        .init(lines: [.init(text: "Imagine all the people", timestamp: 38),
//                      .init(text: "Living for today... Aha-ah...", timestamp: 44)]),
//
//        .init(lines: [.init(text: "Imagine there's no countries", timestamp: 52)]),
//        .init(lines: [.init(text: "It isn't hard to do", timestamp: 57)]),
//        .init(lines: [.init(text: "Nothing to kill or die for", timestamp: 63)]),
//        .init(lines: [.init(text: "And no religion, too", timestamp: 69)]),
//        .init(lines: [.init(text: "Imagine all the people", timestamp: 75),
//                      .init(text: "Living life in peace... You...", timestamp: 82)]),
//
//        .init(lines: [.init(text: "You may say I'm a dreamer", timestamp: 89),
//                      .init(text: "But I'm not the only one", timestamp: 95)]),
//        .init(lines: [.init(text: "I hope someday you'll join us", timestamp: 101),
//                      .init(text: "And the world will be as one", timestamp: 105)]),
//
//        .init(lines: [.init(text: "Imagine no possessions", timestamp: 113)]),
//        .init(lines: [.init(text: "I wonder if you can", timestamp: 120)]),
//        .init(lines: [.init(text: "No need for greed or hunger", timestamp: 125)]),
//        .init(lines: [.init(text: "A brotherhood of man", timestamp: 131)]),
//        .init(lines: [.init(text: "Imagine all the people", timestamp: 137),
//                      .init(text: "Sharing all the world... You...", timestamp: 143)]),
//
//        .init(lines: [.init(text: "You may say I'm a dreamer", timestamp: 150),
//                      .init(text: "But I'm not the only one", timestamp: 157)]),
//        .init(lines: [.init(text: "I hope someday you'll join us", timestamp: 162),
//                      .init(text: "And the world will live as one", timestamp: 169)])
//    ]))
    static let iWantItThatWay = SongInfo(artist: "Backstreet Boys", title: "I Want It That Way", lyrics: .init(sentences: [
        .init(text: "Yeah", timestamp: 2),
        .init(text: "You are my fire", timestamp: 8),
        .init(text: "The one desire", timestamp: 14),
        .init(text: "Believe when I say", timestamp: 19),
        .init(text: "I want it that way", timestamp: 24),
        .init(text: "But we are two worlds apart", timestamp: 28),
        .init(text: "Can't reach to your heart", timestamp: 35),
        .init(text: "When you say", timestamp: 40),
        .init(text: "That I want it that way", timestamp: 43),
        .init(text: "Tell me why", timestamp: 47),
        .init(text: "Ain't nothin' but a heartache", timestamp: 49),
        .init(text: "Tell me why", timestamp: 52),
        .init(text: "Ain't nothin' but a mistake", timestamp: 54),
        .init(text: "Tell me why I never wanna hear you say", timestamp: 58),
        .init(text: "I want it that way", timestamp: 63),
//        .init(text: "", timestamp: 0)]),
        
//        Am I your fire?
//        Your one desire?
//        Yes I know, it's too late
//        But I want it that way
//
//        Tell me why
//        Ain't nothin' but a heartache
//        Tell me why
//        Ain't nothin' but a mistake
//        Tell me why
//        I never wanna hear you say
//        I want it that way
//
//        Now I can see that we've fallen apart
//        From the way that it used to be, yeah
//        No matter the distance
//        I want you to know
//        That deep down inside of me
//
//        You are my fire
//        The one desire
//        You are (You are, you are, you are)
//        Don't wanna hear you say
//
//        Ain't nothin' but a heartache
//        Ain't nothin' but a mistake
//        Don't wanna hear you say
//        I never wanna hear you say
//        Aww, yeah
//        I want it that way
//
//        Tell me why
//        Ain't nothin' but a heartache
//        Tell me why
//        Ain't nothin' but a mistake
//        Tell me why
//        I never wanna hear you say
//        Don't wanna hear you say
//        I want it that way
//
//        Tell me why
//        Ain't nothin' but a heartache
//        Ain't nothin' but a mistake
//        Tell me why
//        I never wanna hear you say
//        I want it that way
//        'Cause I want it that way
    ]))
}
