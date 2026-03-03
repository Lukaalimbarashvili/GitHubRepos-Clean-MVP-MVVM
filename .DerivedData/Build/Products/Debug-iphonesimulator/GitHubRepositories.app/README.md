# GitHub Repositories iOS App

## Overview

The app connects to the **GitHub REST API**, displays a list of public repositories for a given user,
and asynchronously loads the **last commit** for each repository.

The implementation strictly follows the assignment requirements:
- **iOS 15+**
- **UIKit only** (no SwiftUI)
- **No third-party libraries**
- Fully compilable and executable Xcode project

---

## Architecture & Design Decisions

I chose a **MVP-inspired architecture** to keep responsibilities clearly separated:  

- **ViewController:** Handles only UI setup and rendering. 
- **Presenter:** Maintains view state and coordinates async updates.   
- **Use Cases:** Encapsulate network requests for repositories and commits.   
- **NetworkManager:** Centralized networking logic using `URLSession` and generic `Decodable` support. 

Using **protocols and dependency injection** allowed me to keep components loosely coupled and testable.

---

## UI Implementation

I built the interface **programmatically**, without storyboards, to keep the structure explicit and maintainable:  

- Root view controller is configured in **SceneDelegate**.   
- `UITableView` displays repositories using **custom cells**.   
- Each cell shows repository name, description, stars, forks, language, avatar, and last commit.  
- Layout is handled with **Auto Layout in code**.   
- Implemented **asynchronous avatar loading** with caching using `NSCache`. 

---
## App Flow
When the app starts, it fetches the list of public repositories for the given GitHub user.
Each repository is displayed in a table view row with its name, description, stars, forks, language, and avatar.
After the list loads, the app asynchronously fetches the last commit for each repository, showing a shimmer loading animation in the meantime.
Once the commit is ready, the shimmer fades out and the commit message appears smoothly, keeping the UI responsive and scrolling performance smooth.

---

## Networking

All networking is implemented with **URLSession**, no third-party libraries:  

- Generic request method supporting `Decodable`. 
- Centralized error handling 
- Async updates for smooth UI performance 
