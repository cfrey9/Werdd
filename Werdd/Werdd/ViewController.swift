//
//  ViewController.swift
//  Werdd
//
//  Created by Caroline Frey on 10/4/22.
//

import UIKit

struct Word {
    let word: String
    let partOfSpeech: String
    let definition: String
}

var wordArray: [Word] = [
    Word(word: "Programming", partOfSpeech: "noun", definition: "creating a sequence of instructions to enable the computer to do something"),
    Word(word: "Algorithm", partOfSpeech: "noun", definition: "specific procedures used to solve computational problems"),
    Word(word: "Compile", partOfSpeech: "verb", definition: "convert (a program) into a machine-code or lower-level form in which the program can be executed."),
    Word(word: "Latency", partOfSpeech: "noun", definition: "measure of time between entering an input and the returned output"),
    Word(word: "Syntax", partOfSpeech: "noun", definition: "the rules that dictate the structure of a language"),
    Word(word: "Bug", partOfSpeech: "noun", definition: "a programming error that causes unexpected glitches or problems for a program's end user"),
    Word(word: "CPU", partOfSpeech: "noun", definition: "stands for the Central Processing Unit. It is the processing chip that serves as the brains of a device that interprets (or processes) the digital instructions provided by applications"),
    Word(word: "Bit", partOfSpeech: "noun", definition: "an abbreviation for “binary digit,” the smallest piece of information used by a computer"),
    Word(word: "Conditional statements", partOfSpeech: "noun", definition: "another fundamental piece of programming instructions, set the terms for when a program moves forward"),
    Word(word: "Bandwidth", partOfSpeech: "noun", definition: "the amount of information that hard-wired or wireless connections can process or transmit"),
]
let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
let buttonSymbol = UIImage(systemName: "arrow.triangle.2.circlepath.circle", withConfiguration: largeConfig)

class ViewController: UIViewController {
    
    let werddTitle: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "Rubik-Bold", size: 36)
        text.text = "Werdd."
        text.textAlignment = .left
        
        return text
    }()
    
    let definitionBoxView: DefinitionBoxView = {
        let definitionBoxView = DefinitionBoxView()
        definitionBoxView.translatesAutoresizingMaskIntoConstraints = false
        return definitionBoxView
    }()
    
    let newWordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(buttonSymbol, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(newWordButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.clipsToBounds = true
        table.layer.cornerRadius = 30
        table.rowHeight = 70

        return table
    }()
    
    var allWords: [Word] = [] //create empty array to be populated and passed into tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allWords = wordArray //populate array to be passed into tableView
        view.backgroundColor = UIColor.init(named: "Color5")
        setUpUI()
    }
    
    private func setUpUI() {
        
        view.addSubview(werddTitle)
        NSLayoutConstraint.activate([
            werddTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            werddTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        setUpDefinitionBox()
        
        view.addSubview(newWordButton)
        NSLayoutConstraint.activate([
            newWordButton.trailingAnchor.constraint(equalTo: definitionBoxView.trailingAnchor, constant: -40),
            newWordButton.bottomAnchor.constraint(equalTo: definitionBoxView.bottomAnchor),
        ])
        
        setUpTableView()
    }
    
    private func setUpDefinitionBox() {
        
        view.addSubview(definitionBoxView)
        
        NSLayoutConstraint.activate([
            definitionBoxView.topAnchor.constraint(equalTo: werddTitle.bottomAnchor),
            definitionBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            definitionBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            definitionBoxView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        ])
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self //self means the current class (in this case the class is ViewController) conforms to the protocol
        tableView.delegate = self //NOT used in V3, might need for V5
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: definitionBoxView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func newWordButtonPressed() {
        let randomWord = randomizedWord()
        updateDefinitionBox(withword: randomWord)
    }
    
    private func randomizedWord() -> Word? {
        return wordArray.randomElement()
    }
    
    private func updateDefinitionBox(withword wordChoice: Word?) {
        definitionBoxView.word.text = wordChoice?.word
        definitionBoxView.partOfSpeech.text = wordChoice?.partOfSpeech
        definitionBoxView.definition.text = wordChoice?.definition
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Two methods required for UITableViewDataSource conformance
    //1. How many cells am I showing?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count //number of rows in table
    }
    
    //2. What cells am I showing?
    //   ** This function gets called REPEATEDLY as you scroll down the list. It loads the next cell that is about to show on the screen.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier) as! CustomTableViewCell //gives us access to methods
        let currentWord = wordArray[indexPath.row]
        cell.set(word: currentWord)
        
        return cell
    }
}
