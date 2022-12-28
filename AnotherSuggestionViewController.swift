import UIKit
import Alamofire
import SnapKit
import SwiftyJSON
import Kingfisher
import SwiftyGif
import AVFoundation

protocol TableViewDelegate: AnyObject {
    func didPressButton(in tableViewController: UITableViewController)
}

class AnotherSuggestionViewController: UITableViewController {
    
    let cellId = "cellId"
    
    let headerView = UIView()
    let CommentCountLabel = UILabel()
    
    var heroes = [SoundListHeadElement]()
    var heroes2: SoundListHeadElement!
    
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    var isFinFirst = false
    var isPlaying = false
    var player = AVPlayer()
    
    var selectIndex: Int?
    weak var delegate: TableViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        tableView.register(AnotherSuggestionTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset.left = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .always
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30)
        headerView.backgroundColor = UIColor.white
        tableView.tableHeaderView = headerView
        
        CommentCountLabel.text = "다른 추천 음악"
        CommentCountLabel.font = UIFont.systemFont(ofSize: 15)
        CommentCountLabel.textColor = UIColor.black
        headerView.addSubview(CommentCountLabel)
        
        CommentCountLabel.snp.makeConstraints{ (make) in
            make.leading.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) < scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList2()
        }
        
        if currentPage == 0 {
            currentPage = 1
        }
        
        self.load2()
    }
    
    
    
    func reloadData(_ data:Data?) {
        if data == nil {
            print(" ------ 데이터 에러 관련 처리 --- ")
            return
        }
        
        do {
            let json = try JSONDecoder().decode(SoundList.self, from: data!)
            print("sound list json1:", json)
            
            self.heroes = json.data!.soundListDetail!
            print("sound list self.heroes:", self.heroes)
            
            self.heroes2 = json.data!.soundListHead!
            print("sound list self.heroes2:", self.heroes2 as Any)
            
            self.heroes.forEach { e in
            }
            
            self.tableView.reloadData()
            
        } catch {
            print("catch error:", error)
            print(" ------ 서버 데이터 에러 관련 처리 --- ")
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AnotherSuggestionTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        DispatchQueue.main.async {
            let imageValue = self.heroes[indexPath.row].albumImage
            let url : URL! = URL(string: imageValue)
            cell.commentwriterprofileImage.kf.setImage(with: url)
        }
        
        cell.MusicInfoLabel.text = self.heroes[indexPath.row].title
        
        cell.SoundPreviewButton.addTarget(self, action: #selector(self.SoundPreviewButtonTapped), for: .touchUpInside)
        cell.SoundPreviewButton.tag = indexPath.row
        
        cell.SoundPauseButton.addTarget(self, action: #selector(self.SoundPauseButtonTapped), for: .touchUpInside)
        cell.SoundPauseButton.tag = indexPath.row
        
        cell.SoundUseButton.addTarget(self, action: #selector(self.SoundUseButtonTapped), for: .touchUpInside)
        cell.SoundUseButton.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    
    func getListFromServer(_ pageNumber: Int){
        self.isLoadingList = false
    }
    
    func loadMoreItemsForList(){
        currentPage += 1
        getListFromServer(currentPage)
    }
    
    func loadMoreItemsForList2(){
        currentPage -= 1
        getListFromServer(currentPage)
    }
    
    
    
    
    
    
    //스크롤이 끝나면 개 데이터 보여줌
    func loadMoreData(datas: [SoundListHeadElement]) {
        if !self.isLoadingList {
            self.isLoadingList = true
            
            let data = SoundListHeadElement(albumImage: self.heroes.first!.albumImage, id: self.heroes.first!.id, title: self.heroes.first!.title, soundURL: self.heroes.first!.soundURL)
            
            print("heroes.count2:", heroes.count)
            print("datas2:", datas)
            print("datas2.count:", datas.count)
            print("data2:", data)
            
            if heroes.count > 0 {
                self.heroes.append(contentsOf: datas)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoadingList = false
                    
                    print("selectIndex222", self.selectIndex as Any)
                    if self.selectIndex == nil {
                        
                    } else {
                        let indexPath = IndexPath(row: self.selectIndex!, section: 0)
                        let cell = self.tableView.cellForRow(at: indexPath) as? AnotherSuggestionTableViewCell
                        
                        cell?.SoundPreviewButton.isHidden = true
                        cell?.SoundPauseButton.isHidden = false
                    }
                }
            }
        }
    }
    
    
    
    func load2() {
        let url = ""
        
        /*let headers: HTTPHeaders = [
         "Content-type": "application/json",
         "Authorization": token
         ]
         print("mypage upload list headers:", headers)*/
        
        let parameters: Parameters = [
            "contentMId": UserDefaults.standard.string(forKey: "contentmid")!,
            "page": "\(currentPage)",
        ]
        print("sound list parameters:", parameters)
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: nil).responseJSON(completionHandler: { response in
            
            let json = response.result
            print("sound list json:", json)
            
            switch response.result {
            case .success(let res):
                print(res)
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    print("sound list jsonData:", jsonData)
                    
                    let json = try JSONDecoder().decode(SoundList.self, from: jsonData)
                    print("sound list json:", json)
                    
                    self.loadMoreData(datas: json.data?.soundListDetail ?? [])
                    
                    self.heroes.forEach { e in
                    }
                    
                } catch {
                    
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    
    
    
    @objc func SoundPreviewButtonTapped(_ sender: UIButton) {
        self.player.pause()
        
        let url = URL(string: self.heroes[sender.tag].soundURL)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        self.view.layer.addSublayer(playerLayer)
        
        let cell = tableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! AnotherSuggestionTableViewCell
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            
            let cell = tableView.cellForRow(at: NSIndexPath(row: i, section: 0) as IndexPath) as? AnotherSuggestionTableViewCell
            cell?.SoundPreviewButton.isHidden = false
            cell?.SoundPauseButton.isHidden = true
            
            selectIndex = sender.tag
        }
        
        selectIndex = sender.tag
        delegate?.didPressButton(in: self)
        
        cell.SoundPreviewButton.isHidden = true
        cell.SoundPauseButton.isHidden = false
        
        self.player.play()
    }
    
    @objc func SoundPauseButtonTapped(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: NSIndexPath(row: sender.tag, section: 0) as IndexPath) as! AnotherSuggestionTableViewCell
        
        selectIndex = sender.tag
        
        cell.SoundPauseButton.isHidden = true
        cell.SoundPreviewButton.isHidden = false
        
        self.player.pause()
    }
    
    @objc func SoundUseButtonTapped(_ sender: UIButton) {
        let x: Int? = self.heroes[sender.tag].id
        let b1 = x.map(String.init) ?? ""
        
        let vc = SelfMadeVideoUploadViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.noreceivedValueFromBeforeVC = self.heroes[sender.tag].soundURL
        vc.no2receivedValueFromBeforeVC = b1
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.player.pause()
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if self.isFinFirst == false {
            for i in 0..<tableView.numberOfRows(inSection: 0) {
                let cell = tableView.cellForRow(at: NSIndexPath(row: i, section: 0) as IndexPath) as? AnotherSuggestionTableViewCell
                cell?.SoundPreviewButton.isHidden = false
                cell?.SoundPauseButton.isHidden = true
            }
            self.player.pause()
        }
    }
}
