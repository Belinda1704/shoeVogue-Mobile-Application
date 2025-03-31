# ShoeVogue - Flutter Mobile Application (App)

## Overview
ShoeVogue is a mobile application dedicated to providing a seamless shoe shopping experience. The app uses **GetX for state management** and follows best practices in Flutter development.

## Features
- **User Authentication**: Onboarding, Login, Signup, Email Verification, and Password Reset
- **Navigation**: Bottom Navigation Bar, Custom AppBar
- **Product Discovery**: Search Bar, Categories, Carousel Slider, and GridView for Shoe Listings
- **Shopping Experience**: Product Detail Page, Ratings & Reviews, Favorites, Shopping Cart, and Checkout
- **User Profile & Orders**: Profile Management, Account Settings, Address Management, and Order History
- **Brand & Category Browsing**: Shops/Brands Screen, Subcategories

## Future Implementations
- **AR Try-On**: Virtual shoe fitting experience
- **AI Sizing Tool**: Smart shoe size recommendations
- **Sustainability Scoring**: Insights on eco-friendly shoe choices

## Project Structure
- **`lib/`**: Contains all Dart source code
- **`lib/controllers/`**: GetX controllers for state management
- **`lib/models/`**: Data models used in the app
- **`lib/views/`**: UI components and screens
- **`lib/routes/`**: Navigation management using GetX
- **`lib/utils/`**: Utility functions, themes, and validators
- **`assets/`**: Images, icons, banners, logos, and fonts

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  get:
  flutter_svg:
  carousel_slider:
  cached_network_image:
  shared_preferences:
  intl:
  flutter_rating_bar:
```

## Installation Guide
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/yourusername/shoevogue.git
   ```
2. **Navigate to Project Directory:**
   ```sh
   cd shoevogue
   ```
3. **Install Dependencies:**
   ```sh
   flutter pub get
   ```
4. **Run the Application:**
   ```sh
   flutter run
   ```

## Best Practices Followed
- **State Management:** GetX for efficient navigation and state handling
- **Code Modularity:** Well-structured components and controllers
- **Performance Optimization:** Image caching and async data handling
- **Security Measures:** Input validation and secure storage

## Deadline
The project needs to be completed by **March 28, 2025**.

## Contributors
- **[Your Name]** - Flutter Developer

## License
This project is licensed under the **MIT License**.

