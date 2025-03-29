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