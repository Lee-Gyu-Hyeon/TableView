import UIKit

class AnotherSuggestionTableViewCell: UITableViewCell {
    
    let commentwriterprofileImage: UIImageView = {
        let albumImage = UIImage()
        
        let commentwriterprofileImage = UIImageView()
        commentwriterprofileImage.image = albumImage
        return commentwriterprofileImage
    }()
    
    lazy var MusicInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var SoundPreviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("사운드 미리 듣기", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 195/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var SoundUseButton: UIButton = {
        let button = UIButton()
        button.setTitle("이 사운드 사용", for: .normal)
        button.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var SoundPauseButton: UIButton = {
        let musicClass: UIImage = UIImage(named: "img_btn_sound_pause")!
        
        let button = UIButton()
        button.setTitle("일시정지", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 195/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 1
        button.setImage(musicClass, for: .normal)
        button.isHidden = true
        
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [SoundPreviewButton, SoundUseButton, SoundPauseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        SoundPreviewButton.isHidden = false
        SoundPauseButton.isHidden = true
    }
}


extension AnotherSuggestionTableViewCell {
    func setupUI() {
        
        self.contentView.addSubview(commentwriterprofileImage)
        commentwriterprofileImage.snp.makeConstraints{ (make) in
            make.width.equalTo(67)
            make.height.equalTo(67)
            make.leading.equalTo(11)
            make.top.equalTo(15)
        }
        
        self.contentView.addSubview(MusicInfoLabel)
        MusicInfoLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(15)
            make.leading.equalTo(commentwriterprofileImage.snp.trailing).offset(10)
        }
        
        stackView.addArrangedSubview(SoundPreviewButton)
        SoundPreviewButton.snp.makeConstraints{ (make) in
        }
        
        stackView.addArrangedSubview(SoundUseButton)
        SoundUseButton.snp.makeConstraints{ (make) in
        }
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints{ (make) in
            make.top.equalTo(MusicInfoLabel.snp.bottom).offset(25)
            make.leading.equalTo(commentwriterprofileImage.snp.trailing).offset(10)
            make.trailing.equalTo(-10)
        }
    }
}
