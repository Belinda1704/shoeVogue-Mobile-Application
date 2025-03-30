# ShoeVogue App Testing Suite

This directory contains comprehensive tests for the ShoeVogue app, organized into a well-structured hierarchy to ensure maintainability and coverage of critical components.

## Test Structure

```
test/
├── unit/                  # Unit tests for individual components
│   ├── models/            # Tests for data models
│   ├── controllers/       # Tests for GetX controllers
│   └── services/          # Tests for app services
├── widget/                # Widget tests
│   ├── components/        # Tests for reusable UI components
│   ├── responsive/        # Tests specifically targeting responsiveness
│   └── views/             # Tests for screen views
└── integration_test/      # End-to-end tests for user flows
```

## Testing Focus Areas

### Unit Tests
- Model parsing and serialization (JSON handling)
- Controller logic (state management, data processing)
- Service behaviors (API interactions, data transformations)

### Widget Tests
- Component rendering and interaction
- Screen layout and navigation
- Responsiveness across different screen sizes
- Theme switching (dark/light mode)
- Text overflow prevention

### Integration Tests
- Complete user flows (onboarding, navigation, etc.)
- Screen transitions
- Device orientation changes

## Responsiveness Testing

A special focus has been placed on testing responsiveness across various device sizes:
- Small phones (320x480)
- Medium phones (375x667, iPhone 8)
- Large phones (414x896, iPhone 11)
- Tablets (768x1024)
- Large tablets (1024x1366)

Each critical UI component is tested in both portrait and landscape orientations to prevent overflow errors.

## Running Tests

### Running All Tests
Use the provided script:
```
./run_tests.bat  # Windows
```

### Running Individual Test Categories
```
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Responsive tests
flutter test test/widget/responsive/

# Integration tests
flutter test integration_test/
```

## Best Practices

1. **Mock External Dependencies**: Use Mockito to mock Firebase and API services
2. **Test Edge Cases**: Test boundary conditions and error states
3. **Responsive Testing**: Verify UI components at different screen sizes
4. **Golden Tests**: Compare rendered UI against saved "golden" images
5. **Integration Tests**: Test real user flows from end to end

## Future Improvements

- Add network service mocking for offline testing
- Implement screenshot comparison testing
- Expand test coverage for authentication flows
- Add performance testing for critical operations

# Widget Tests for ShoeVogue App

This directory contains widget tests for the ShoeVogue Flutter application. The tests cover at least 20 different Flutter widgets used throughout the app.

## Running the Tests

To run all the widget tests, execute the following command from the project root:

```bash
flutter test test/widget_tests.dart
```

## Test Coverage

The widget tests cover the following 20 widgets:

1. Scaffold
2. Container with BoxDecoration
3. Row
4. Column
5. ElevatedButton
6. IconButton
7. ListView
8. Card
9. TextField
10. CircularProgressIndicator
11. Padding
12. Stack
13. SizedBox
14. ClipRRect
15. Divider
16. GestureDetector
17. Expanded
18. SingleChildScrollView
19. Center
20. InkWell

## Additional Dependencies

To run these tests, make sure you have the following dependencies in your pubspec.yaml:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.0.0
  build_runner: ^2.0.0
```

## Generating Mocks

The tests use mocked services. To regenerate the mocks, run:

```bash
flutter pub run build_runner build
```

## Notes

- These tests are designed to verify the basic functionality and rendering of Flutter widgets.
- They use mock implementations of services to avoid network calls during testing.
- Each test is independent and can be run separately. 