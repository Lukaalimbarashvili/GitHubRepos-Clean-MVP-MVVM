//
//  RepoMVVMTableViewCell.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 03.03.26.
//

import UIKit

final class RepoMVVMTableViewCell: UITableViewCell {

    static let reuseIdentifier = "RepoMVVMTableViewCell"
    private let avatarPlaceholder = UIImage(systemName: "person")?
        .withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
    private var hasShownLastCommit = false

    private let avatarImage: CachedImageView = {
        let view = CachedImageView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private let statsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .center
        return view
    }()

    private let lastCommit: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textColor = .systemBlue
        return label
    }()

    private let starsLabel = RepoMVVMTableViewCell.makeStatLabel()
    private let forksLabel = RepoMVVMTableViewCell.makeStatLabel()
    private let languageLabel = RepoMVVMTableViewCell.makeStatLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        [avatarImage, titleLabel, ownerLabel, descriptionLabel, statsStackView, lastCommit]
            .forEach { contentView.addSubview($0) }
        [starsLabel, forksLabel, languageLabel].forEach { statsStackView.addArrangedSubview($0) }
        setupConstraints()
    }

    private func setupAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.darkGray.cgColor
    }

    private func setupConstraints() {
        [avatarImage, titleLabel, ownerLabel, descriptionLabel, statsStackView, lastCommit]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImage.widthAnchor.constraint(equalToConstant: 30),
            avatarImage.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            ownerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ownerLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            ownerLabel.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            lastCommit.heightAnchor.constraint(equalToConstant: 18),
            lastCommit.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            lastCommit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            lastCommit.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            lastCommit.bottomAnchor.constraint(equalTo: statsStackView.topAnchor, constant: -8),

            statsStackView.topAnchor.constraint(equalTo: lastCommit.bottomAnchor, constant: 8),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statsStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            statsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with model: RepoCellViewModel) {
        avatarImage.loadImage(from: model.avatarURL, placeholder: avatarPlaceholder)
        titleLabel.text = model.title
        ownerLabel.text = "by \(model.owner)"
        descriptionLabel.text = model.description
        starsLabel.text = model.starsText
        forksLabel.text = model.forksText
        languageLabel.text = model.languageText

        if model.isLoadingCommit {
            lastCommit.text = nil
            lastCommit.startShimmer()
        } else if let sha = model.lastCommitSha {
            showLastCommitText(sha)
        } else {
            lastCommit.stopShimmer()
            lastCommit.text = "Git Repository is empty"
        }
    }

    func showLastCommitText(_ sha: String) {
        lastCommit.stopShimmer()
        lastCommit.text = "Last Commit: \(sha)"

        guard !hasShownLastCommit else { return }
        hasShownLastCommit = true
        lastCommit.alpha = 0
        lastCommit.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.8, y: 0.8)

        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut],
            animations: {
                self.lastCommit.alpha = 1
                self.lastCommit.transform = .identity
            }
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hasShownLastCommit = false
        lastCommit.alpha = 0
        lastCommit.transform = .identity
        lastCommit.text = nil
        lastCommit.stopShimmer()
        avatarImage.image = nil
    }
}

extension RepoMVVMTableViewCell {
    private static func makeStatLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }
}

