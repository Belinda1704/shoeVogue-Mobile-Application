# ShoeVogue - AI-Powered Shoe Shopping App

ShoeVogue is a modern Flutter-based mobile application that combines traditional e-commerce functionality with cutting-edge AI features to provide an enhanced shoe shopping experience.

## Features

### Core Features
- User authentication (Email, Phone, Google, Facebook)
- Product browsing and searching
- Shopping cart management
- Favorites/Wishlist
- User profile management
- Secure checkout process
- Order tracking

### AI-Powered Features
1. **AI Foot Size Measurement**
   - Accurate foot size measurement using camera
   - AI-powered size recommendations using Google ML Kit
   - Personalized fit suggestions based on ML analysis

2. **Virtual Try-On**
   - Try shoes virtually using your camera
   - Real-time visualization with ML Kit Object Detection
   - Multiple shoe options available
   - Interactive shoe selection interface

## Technologies & APIs Used

### Google Services
- **Firebase Authentication**
  - Email/Password authentication
  - Phone number verification
  - Google Sign-In integration
  - Facebook authentication

- **Firebase Firestore**
  - Real-time database for product data
  - User profiles and preferences
  - Order management
  - Shopping cart synchronization

- **Google ML Kit**
  - Face Detection API for size measurements
  - Object Detection API for shoe recognition
  - Image processing capabilities
  - Real-time camera feed analysis

### Development Framework
- Flutter 3.x
- GetX for state management
- Camera integration
- Stripe payment integration

### API Keys and Setup
To use these APIs, you need to:
1. Create a Firebase project and add your own `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Enable required Firebase services (Authentication, Firestore, Storage)
3. Configure Google ML Kit in your Firebase project
4. Set up OAuth 2.0 credentials for Google Sign-In

## Prerequisites

- Flutter SDK (>=3.6.1)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase project setup
- Physical device or emulator with camera support

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Belinda1704/shoeVogue-Mobile-Application.git
```

2. Navigate to project directory:
```bash
cd shoevogue-flutter-mobile-app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── app/
│   ├── modules/           # Feature modules
│   │   ├── ai_features/  # AI functionality
│   │   ├── auth/         # Authentication
│   │   ├── cart/         # Shopping cart
│   │   ├── home/         # Home screen
│   │   └── profile/      # User profile
│   ├── data/             # Data models
│   ├── routes/           # App routes
│   ├── theme/            # App theming
│   ├── translations/     # Internationalization
│   └── utils/            # Utility functions
├── assets/               # Images, fonts, etc.
└── test/                 # Unit & widget tests
```

## AI Features Usage

### Foot Size Measurement
1. Navigate to AI Features section
2. Select "Measure Foot Size"
3. Follow on-screen instructions
4. Get your accurate foot size measurement

### Virtual Try-On
1. Navigate to AI Features section
2. Select a shoe from the horizontal list
3. Click "Try On Selected Shoe"
4. Take a photo using your camera
5. View the virtual try-on result

## Dependencies

Key dependencies include:
- get: ^4.6.6
- camera: ^0.10.5+9
- google_mlkit_face_detection: ^0.9.0
- google_mlkit_object_detection: ^0.11.0
- image_picker: ^1.0.7
- path_provider: ^2.1.2

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Acknowledgments

- Flutter team for the amazing framework
- GetX team for the state management solution
- Google ML Kit team for AI capabilities
- All contributors and testers

## Future Implementation

### Admin Panel
- Dashboard with analytics, user management, and inventory control
- Product management system with bulk operations and stock monitoring
- User management tools for activity tracking and support

### Deployment & Infrastructure
- Cloud infrastructure (AWS/GCP) with load balancing and CDN
- CI/CD pipeline with automated testing and deployment
- Enhanced security features including GDPR compliance and 2FA

### Additional Features
- Social integration with sharing and community features
- Advanced AI features (recommendations, chatbot, AR customization)
- International expansion with multi-language and payment support

### Performance & Analytics
- Mobile optimization (offline mode, battery efficiency)
- Advanced analytics and A/B testing capabilities

## Collaborators

1. Belinda Larose [b.larose@alustudent.com]
2. Valentine Kalu [v.kalu@alustudent.com]
3. Gabriel Pawuoi [g.pawuoi@alustudent.com]
4. Lina Iratwe [i.lina@alustudent.com]
5. Amelie Umutoni [a.umutoni@alustudent.com]

Project Link: [https://github.com/Belinda1704/shoeVogue-Mobile-Application]

## Screenshots

### User Onboarding & Authentication
![Onboarding Page](assets/prototype/Onboarding%20page.png)
![Login Page](assets/prototype/login%20page.png)
![Sign Up Page](assets/prototype/sign%20up%20page.png)

### Main Features
![Home Page](assets/prototype/Home%20page.png)
![Homepage Menu](assets/prototype/Homepage%20menu.png)
![Product Detail Page](assets/prototype/product%20detail%20page.png)

### Shopping Experience
![Cart Page](assets/prototype/cart%20page.png)
![Checkout Page](assets/prototype/checkout%20page.png)
![Favorites Page](assets/prototype/Favorites%20page.png)

### User Profile & Settings
![Profile Page](assets/prototype/Profile%20page.png)
![Edit Profile Page](assets/prototype/Edit%20profile%20page.png)
![Settings Page](assets/prototype/settings%20page.png)
![Notifications Page](assets/prototype/notifications%20page.png)
![Privacy Settings Page](assets/prototype/privacy%20settings%20page.png)

### Support & Information
![Help Center Page](assets/prototype/help%20center%20page.png)
![About Us Page](assets/prototype/about%20us%20page.png)

