//
//  Alphabet.swift
//  Dictionary
//
//  Created by Oleh Sannikov on 18.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import Foundation

class Alphabet {
    
    struct Letter {
        let char: Character
        let transcript: String
        let ipaTranscript: String
        let isVowel: Bool
        
        init?(character: Character, description:[String]) {
            if description.count < 2 { return nil }
            
            self.char = character
            self.transcript = description[0]
            self.ipaTranscript = description[1]
            
            self.isVowel = description.count > 2 ? (description[2] == "vowel") : false
        }
    }
    
    let letters: Array<Letter>
    
    init() {
        var loadedLetters = Array<Letter>()
        
        if let path = NSBundle.mainBundle().pathForResource("Letters", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                var error: NSError?
                if let lettersDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? Dictionary<String, AnyObject> {
                    
                    for (key, value) in lettersDict {
                        if let description = value as? Array<String> {
                            let char = Character(key)
                            if let letter = Letter(character: char, description: description) {
                                loadedLetters.append(letter)
                            }
                        }
                    }
                }
            }
        }
        
        letters = loadedLetters.sorted {$0.char < $1.char}
    }
}
