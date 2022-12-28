import UIKit
import SnapKit
import AVFoundation

protocol ViewControllerDelegate: AnyObject {
  func didPressButton(in viewController: UIViewController)
}

class SoundDetailViewController: UIViewController, TableViewDelegate {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let blueBox = UIView()
    let SoundAlbumImage = UIImageView()
    let SoundTitleLabel = UILabel()
    let SoundPreviewButton = UIButton()
    let SoundPauseButton = UIButton()
    let SoundUseButton = UIButton()
    
    var uploadpostlistContainerView = UIView()
    let bottomView = AnotherSuggestionViewController()
    
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    
    let token = UserDefaults.standard.string(forKey: "loginID") ?? "" //로그인 아이디
    let token2 = UserDefaults.standard.string(forKey: "session") ?? "" //로그인 세션
    
    var data: Data!
    
    var noreceivedValueFromBeforeVC = "" //contentMID
    var no2receivedValueFromBeforeVC = "" //soundURL
    var no3receivedValueFromBeforeVC = "" //soundID
    
    var isFinFirst = false
    var isPlaying = false
    var player = AVPlayer()
    
    var selectIndex: Int?
    weak var delegate: TableViewDelegate?
    weak var delegate2: ViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "contentmid")
        UserDefaults.standard.set(noreceivedValueFromBeforeVC, forKey: "contentmid")
        UserDefaults.standard.synchronize()
        
        SoundListApiManager.share.api(token, completion: { data in
            self.bottomView.reloadData(data)
            
            guard let soundlist = try? JSONDecoder().decode(SoundList.self, from: data!) else {
                print(">>>>>>>>>>>>>> sound List decode error")
                return
            }
            
            let url = URL(string: (soundlist.data?.soundListHead?.albumImage)!)
            self.data = try? Data(contentsOf: url!)
            
            if self.data != nil {
                DispatchQueue.main.async {
                    self.SoundAlbumImage.image = UIImage(data: self.data!)
                }
            }
            
            self.SoundTitleLabel.text = soundlist.data?.soundListHead?.title
        })
        
        bottomView.delegate = self
        
        
        self.view.backgroundColor = UIColor.white
        
        navigationItem.title = "사운드"
        navigationController?.navigationBar.isTranslucent = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        
        
        
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        
        
        self.contentView.addSubview(blueBox)
        self.contentView.addSubview(SoundAlbumImage)
        self.contentView.addSubview(SoundTitleLabel)
        self.contentView.addSubview(SoundPreviewButton)
        self.contentView.addSubview(SoundPauseButton)
        
        self.contentView.addSubview(uploadpostlistContainerView)
        
        self.contentView.addSubview(view1)
        self.contentView.addSubview(view2)
        self.contentView.addSubview(view3)
        
        
        
        
        blueBox.backgroundColor = UIColor.white
        blueBox.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 195/255, alpha: 1.0).cgColor
        blueBox.layer.borderWidth = 1.0
        
        blueBox.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(134)
            make.top.equalToSuperview()
        }
        
        
        SoundAlbumImage.image = UIImage()
        SoundAlbumImage.clipsToBounds = true
        blueBox.addSubview(SoundAlbumImage)
        
        SoundAlbumImage.snp.makeConstraints { make in
            make.width.height.equalTo(113)
            make.leading.equalTo(11)
            make.centerY.equalToSuperview()
        }
        
        
        SoundTitleLabel.textColor = UIColor.black
        SoundTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        SoundTitleLabel.isUserInteractionEnabled = true
        
        SoundTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(SoundAlbumImage.snp.trailing).offset(13)
            make.top.equalToSuperview().offset(10)
        }
        
        
        
        SoundPreviewButton.setTitle("사운드 미리 듣기", for: .normal)
        SoundPreviewButton.backgroundColor = UIColor.white
        SoundPreviewButton.setTitleColor(UIColor.black, for: .normal)
        SoundPreviewButton.contentHorizontalAlignment = .center
        SoundPreviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        SoundPreviewButton.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 195/255, alpha: 1.0).cgColor
        SoundPreviewButton.layer.borderWidth = 1
        SoundPreviewButton.isHidden = false
        SoundPreviewButton.layer.cornerRadius = 2
        SoundPreviewButton.addTarget(self, action: #selector(self.SoundPreviewButtonpressed), for: .touchUpInside)
        blueBox.addSubview(SoundPreviewButton)
        
        SoundPreviewButton.snp.makeConstraints { make in
            make.leading.equalTo(SoundAlbumImage.snp.trailing).offset(11)
            make.trailing.equalTo(-11)
            make.height.equalTo(30)
            make.top.equalTo(SoundTitleLabel.snp.bottom).offset(25)
        }
        
        
        
        
        let musicClass: UIImage = UIImage(named: "img_btn_sound_pause")!
        
        SoundPauseButton.setTitle("일시정지", for: .normal)
        SoundPauseButton.backgroundColor = UIColor.white
        SoundPauseButton.setTitleColor(UIColor.black, for: .normal)
        SoundPauseButton.contentHorizontalAlignment = .center
        SoundPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        SoundPauseButton.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 195/255, alpha: 1.0).cgColor
        SoundPauseButton.layer.borderWidth = 1
        SoundPauseButton.layer.cornerRadius = 2
        SoundPauseButton.setImage(musicClass, for: .normal)
        SoundPauseButton.addTarget(self, action: #selector(self.SoundPauseButtonTapped), for: .touchUpInside)
        SoundPauseButton.isHidden = true
        
        SoundPauseButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        SoundPauseButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        SoundPauseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        blueBox.addSubview(SoundPauseButton)
        
        SoundPauseButton.snp.makeConstraints { make in
            make.leading.equalTo(SoundAlbumImage.snp.trailing).offset(13)
            make.trailing.equalTo(-11)
            make.height.equalTo(30)
            make.top.equalTo(SoundTitleLabel.snp.bottom).offset(25)
        }
        
        
        SoundUseButton.setTitle("이 사운드 사용", for: .normal)
        SoundUseButton.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        SoundUseButton.setTitleColor(UIColor.white, for: .normal)
        SoundUseButton.contentHorizontalAlignment = .center
        SoundUseButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        SoundUseButton.layer.borderColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0).cgColor
        SoundUseButton.layer.borderWidth = 1
        SoundUseButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        SoundUseButton.isHidden = false
        SoundUseButton.layer.cornerRadius = 2
        SoundUseButton.addTarget(self, action: #selector(self.SoundUseButtonpressed), for: .touchUpInside)
        blueBox.addSubview(SoundUseButton)
        
        SoundUseButton.snp.makeConstraints { make in
            make.leading.equalTo(SoundAlbumImage.snp.trailing).offset(13)
            make.trailing.equalTo(-11)
            make.height.equalTo(30)
            make.top.equalTo(SoundPreviewButton.snp.bottom).offset(10)
        }
        
        
        
        
        
        uploadpostlistContainerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(blueBox.snp.bottom)
            make.bottom.equalTo(self.view)
        }
        
        
        addChild(bottomView)
        bottomView.view.frame = uploadpostlistContainerView.bounds
        uploadpostlistContainerView.isHidden = false
        uploadpostlistContainerView.addSubview(bottomView.view)
        
        
       
        
        view1.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(uploadpostlistContainerView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        view2.snp.makeConstraints { (make) in
            make.top.equalTo(view1.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        view3.snp.makeConstraints { (make) in
            make.top.equalTo(view2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SoundDetailViewController의 view가 화면에 나타남")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SoundDetailViewController의 view가 사라지기 전")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("SoundDetailViewController의 view가 사라짐")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("SoundDetailViewController의 SubView를 레이아웃 하려함")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("SoundDetailViewController의 SubView를 레이아웃 함")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SoundDetailViewController의 view가 Load됨")
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    @objc func SoundPreviewButtonpressed(_ sender: UIButton) {
        let url = URL(string: no2receivedValueFromBeforeVC)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        self.view.layer.addSublayer(playerLayer)
        
        didPressButton(in: AnotherSuggestionViewController())
        
        SoundPreviewButton.isHidden = true
        SoundPauseButton.isHidden = false
        
        self.player.play()
    }
    
    @objc func SoundPauseButtonTapped(_ sender: UIButton) {
        
        SoundPreviewButton.isHidden = false
        SoundPauseButton.isHidden = true
        
        //selectIndex = sender.tag
        //didPressButton(in: AnotherSuggestionViewController())
        
        self.player.pause()
    }
    
    @objc func SoundUseButtonpressed(_ sender: UIButton) {
        let vc = SelfMadeVideoUploadViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.noreceivedValueFromBeforeVC = no2receivedValueFromBeforeVC
        vc.no2receivedValueFromBeforeVC = no3receivedValueFromBeforeVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.player.pause()
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if self.isFinFirst == false {
            SoundPreviewButton.isHidden = false
            SoundPauseButton.isHidden = true
            
            self.player.pause()
        }
    }
    
    func didPressButton(in tableViewController: UITableViewController) {
        print("didPressButton1")
        
        SoundPreviewButton.isHidden = false
        SoundPauseButton.isHidden = true
    }
}
