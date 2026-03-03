# GitHub Repositories iOS App

A UIKit iOS app that fetches public repositories for a GitHub user and then loads each repository's latest commit SHA asynchronously.

## Requirements

- Xcode 15+
- iOS 15+
- Swift 5+
- No third-party dependencies

## What the App Does

- Loads a GitHub user's public repositories from the GitHub REST API.
- Shows each repository in a custom table view cell with:
  - name
  - owner
  - description
  - stars
  - forks
  - language
  - owner avatar
- Fetches the last commit for each repository after the initial list is rendered.
- Uses a shimmer effect for the last-commit field while each row is loading commit data.
- Displays `Git Repository is empty` when commit data is unavailable.

## Architecture

The project is organized in layered modules:

- `Domain`
  - Entities (`Repository`, `Commit`, `RepoWithLastCommit`)
  - Repository protocols
  - `GetReposWithLastCommitUseCase`
- `Data`
  - `NetworkManager` (`URLSession` + `Decodable`)
  - DTOs
  - Repository implementations
  - GitHub endpoint builder (`GitHubAPI`)
- `PresentationMVP`
  - Current default UI flow used at runtime
- `PresentationMVVM`
  - Alternative implementation using the same domain/data layers
- `Components`
  - Reusable UI helpers (`CachedImageView`, shimmer extension)

## Current Runtime Configuration

`SceneDelegate` currently boots the **MVP** screen:

- `ReposMVPConfigurator.getReposVC()` is active.
- `ReposMVVMConfigurator.getReposVC()` is present and commented out.

## Networking

The app uses GitHub REST endpoints:

- `GET /users/{username}/repos`
- `GET /repos/{username}/{repo}/commits`
