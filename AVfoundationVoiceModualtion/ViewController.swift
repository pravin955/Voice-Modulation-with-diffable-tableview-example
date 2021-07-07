//
//  ViewController.swift
//  AVfoundationVoiceModualtion
//
//  Created by Pravinkumar on 06/07/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var voicesTableView: UITableView!
    
    var synth = AVSpeechSynthesizer()
    var listOfVoices = [Voices]()
    private var voiceTableDataSource: UITableViewDiffableDataSource<section,Voices>!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if #available(iOS 9.0, *) {
                let userVoice = Voices(name: voice.name, identifier: voice.identifier, language: voice.language)
                listOfVoices.append(userVoice)
            }
        }
        createSnapShot(from: listOfVoices)
        
        
        // Do any additional setup after loading the view.
    }

    
    fileprivate func speak(say: String, variousVoices voices: Voices) {
            let utterance = AVSpeechUtterance(string: say)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voices.identifier!)
        //utterance.rate = 0.5
        //utterance.pitchMultiplier = 0.5
            //utterance.preUtteranceDelay = 0
            utterance.volume = 1


            synth.speak(utterance)
        }
    
    private func configureDataSource() {
        
        voiceTableDataSource = UITableViewDiffableDataSource(tableView: voicesTableView, cellProvider: { (voicesTableView, indexpath, voices) -> UITableViewCell? in
            let cell = voicesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexpath)
            cell.textLabel?.text = voices.name
            cell.detailTextLabel?.text = voices.language
            return cell
        })
    }
    private func createSnapShot(from dataToLoad:[Voices]){
        var snapShot = NSDiffableDataSourceSnapshot<section,Voices>()
        snapShot.appendSections([.main])
        snapShot.appendItems(dataToLoad)
        voiceTableDataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
    }


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        guard let selectedVoice = voiceTableDataSource.itemIdentifier(for: indexPath) else {
                self.voicesTableView.deselectRow(at: indexPath, animated: true)
                return
            }
        var updateSelectedVoice = selectedVoice
        updateSelectedVoice.name = updateSelectedVoice.name?.appending(" ★")
        
        var newSnapshot = voiceTableDataSource.snapshot()
        newSnapshot.insertItems([updateSelectedVoice], beforeItem: selectedVoice)
        newSnapshot.deleteItems([selectedVoice])
        voiceTableDataSource.apply(newSnapshot, animatingDifferences: false)
        speak(say: "Go for a walk outside and take some deep breaths.", variousVoices: updateSelectedVoice)
//                if let selectedMovie = self.voiceTableDataSource.itemIdentifier(for: indexPath) {
////                    var currentSnapShot = self.voiceTableDataSource.snapshot()
////                    currentSnapShot.deleteItems([selectedMovie])
////                    self.voiceTableDataSource.apply(currentSnapShot, animatingDifferences: true)
//                    speak(say: "Go for a walk outside and take some deep breaths.", variousVoices: selectedMovie)
//                }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension ViewController {
    
    fileprivate enum section {
        case main
    }
}

struct Voices : Hashable{
    var name: String?
    var identifier: String?
    var language: String?
}
