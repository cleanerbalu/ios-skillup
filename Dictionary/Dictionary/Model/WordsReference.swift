//
//  WordsReference.swift
//  Dictionary
//
//  Created by Oleh Sannikov on 18.01.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import Foundation

class WordsReference {
    
    struct Word {
        let word: String
        let translations: [String]
        
        init(word: String, translations: [String]) {
            self.word = word
            self.translations = translations
        }
    }

    private var _words = Dictionary<String, Word>()
    private var _wordsIndex = Array<String>()
    private var _customWordsDict = Dictionary<String, [String]>()
    
    var words: Dictionary<String, Word> { get { return _words } }
    var wordsIndex: [String] { get { return _wordsIndex } }
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("Words", ofType: "json") {
            if let dict = loadDictForPath(path) {
                for (key, translation) in dict {
                    _words[key] = Word(word: key, translations: translation)
                    _wordsIndex.append(key)
                }
            }
        }
        if let path = self.filePathForCustomWords {
            if let dict = loadDictForPath(path) {
                _customWordsDict = dict
                
                for (key, translations) in dict {
                    addWord(Word(word:key, translations:translations), sort: false)
                }
            }
        }
        
        _wordsIndex.sort { $0 < $1 }
    }
    
    func search(searchString: String) -> [Word] {
        
        let resultKeys = wordsIndex.filter({ $0.lowercaseString.rangeOfString(searchString) != nil})
        var result = Array<Word>()
        
        for key in resultKeys  {
            result.append(words[key]!)
        }
        
        return result
    }
    
    var filePathForCustomWords: String? {
        get {
            if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) {
                if paths.count > 0 {
                    let filePath = paths[0] as String
                    return filePath.stringByAppendingPathComponent("customWords.json")
                }
            }
            return nil
        }
    }
    func loadDictForPath(path: String) -> Dictionary<String, [String]>? {
        if let data = NSData(contentsOfFile: path) {
            var error: NSError?
            if let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? Dictionary<String, [String]> {
                return dict
            }
        }
        return nil
    }

    func saveChanges() -> Bool {
        if let path = self.filePathForCustomWords {
            var error: NSError?
            let data = NSJSONSerialization.dataWithJSONObject(_customWordsDict, options: nil, error: &error)
            if data != nil && error == nil {
                return data!.writeToFile(path, atomically:false)
            }
        }
        return false
    }

    private func addWord(word: Word, sort: Bool) {

        if words[word.word] == nil {
            _wordsIndex.append(word.word)
            if sort {
                _wordsIndex.sort {$0 < $1}
            }
        }
        _words[word.word] = word
    }
    
    func addWord(word: Word) {
        
        addWord(word, sort: true)
        _customWordsDict[word.word] = word.translations
    }
    
    func deleteWord(word: String) {
        
        if _customWordsDict[word] != nil {
            _customWordsDict.removeValueForKey(word)

            if let i = find(_wordsIndex, word) {
                _wordsIndex.removeAtIndex(i)
            }
            _words.removeValueForKey(word)
        }
    }
    
    func canDeleteWord(word: String) -> Bool {
        return _customWordsDict[word] != nil
    }
}

