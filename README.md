# Knovator Task - Flutter Mobile Application

## Overview

This is a Flutter mobile application that interfaces with the JSONPlaceholder API to display a list of posts. The application allows users to view post details, mark posts as read, and implements a timer functionality for each post item. The app also persists data using local storage and synchronizes in the background with real-time updates from the API.

## Features

- **Post Listing**: Displays a list of posts from [JSONPlaceholder API](https://jsonplaceholder.typicode.com/posts).
- **Post Detail Screen**: Clicking on a post navigates to a detail screen that shows the post's body.
- **Mark as Read**: Posts can be marked as read when clicked, and their background color changes to white.
- **Timer Functionality**: Each post has a timer that counts down and pauses when the post is scrolled off-screen or when the detail screen is opened.
- **Data Persistence**: Posts are saved in local storage (using `SharedPreferences`), and synchronized in the background with API data.

## Architecture

This project follows the **separation of concerns** principle, where the business logic, UI components, and API interactions are separated for maintainability and scalability. Below are the key architectural decisions:

- **Stateless & Stateful Widgets**: 
  - The `HomeScreen` is a `StatefulWidget` as it manages dynamic data such as fetching posts and controlling timers.
  - `TimerWidget` is also stateful because it maintains its own timer state.
- **API Service Layer**: 
  - API calls are handled in the `ApiService` class, which provides methods to fetch posts and post details. This keeps network logic separate from the UI code.
- **Local Storage**:
  - The app uses `SharedPreferences` for local data persistence, ensuring that the posts are available even after the app is closed, with real-time synchronization upon reopening the app.
- **Timer Management**:
  - Each post's timer starts when the post appears on the screen and pauses when the post goes off-screen using the `VisibilityDetector` widget.
  
## Third-Party Libraries Used

1. **`http`**:
   - Used to make HTTP requests to the JSONPlaceholder API for fetching posts and post details.
   - [http package](https://pub.dev/packages/http)
   
2. **`shared_preferences`**:
   - Used for local storage to save the list of posts and persist data across app sessions.
   - [shared_preferences package](https://pub.dev/packages/shared_preferences)

3. **`visibility_detector`**:
   - Detects when an item appears or disappears on the screen, helping to control the timer functionality of the list items.
   - [visibility_detector package](https://pub.dev/packages/visibility_detector)

## Error Handling

- All network requests are wrapped in `try-catch` blocks to ensure that meaningful error messages are shown to the user in case of failures.
- In case of an error during data fetching, a message will be printed, and the app will load data from the local storage if available.

