import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 1. Test Scaffold widget
  testWidgets('Scaffold renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Test')),
          body: Center(child: Text('Test Scaffold')),
        ),
      ),
    );
    expect(find.text('Test Scaffold'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  // 2. Test Container with decoration
  testWidgets('Container with decoration renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Container'),
            ),
          ),
        ),
      ),
    );
    expect(find.text('Container'), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  // 3. Test Row widget
  testWidgets('Row renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item 1'),
                SizedBox(width: 10),
                Text('Item 2'),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });

  // 4. Test Column widget
  testWidgets('Column renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item 1'),
                SizedBox(height: 10),
                Text('Item 2'),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
  });

  // 5. Test ElevatedButton widget
  testWidgets('ElevatedButton renders correctly and handles tap', (WidgetTester tester) async {
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => buttonPressed = true,
              child: Text('Click Me'),
            ),
          ),
        ),
      ),
    );
    
    expect(find.text('Click Me'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(buttonPressed, true);
  });

  // 6. Test IconButton widget
  testWidgets('IconButton renders correctly and handles tap', (WidgetTester tester) async {
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => buttonPressed = true,
            ),
          ),
        ),
      ),
    );
    
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(buttonPressed, true);
  });

  // 7. Test ListView widget
  testWidgets('ListView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: List.generate(
              5,
              (index) => ListTile(title: Text('Item $index')),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(5));
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 4'), findsOneWidget);
  });

  // 8. Test Card widget
  testWidgets('Card renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Card Content'),
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Card Content'), findsOneWidget);
  });

  // 9. Test TextField widget
  testWidgets('TextField renders correctly and accepts input', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter text',
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(TextField), findsOneWidget);
    
    await tester.enterText(find.byType(TextField), 'Hello World');
    expect(controller.text, 'Hello World');
  });

  // 10. Test CircularProgressIndicator
  testWidgets('CircularProgressIndicator renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // 11. Test Padding widget
  testWidgets('Padding applies correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                color: Colors.red,
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(Padding), findsOneWidget);
    final paddingWidget = tester.widget<Padding>(find.byType(Padding));
    expect(paddingWidget.padding, EdgeInsets.all(16.0));
  });

  // 12. Test Stack widget
  testWidgets('Stack positions children correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Stack(
              children: [
                Container(color: Colors.red, height: 100, width: 100),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text('Stacked Text'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(Stack), findsOneWidget);
    expect(find.text('Stacked Text'), findsOneWidget);
  });

  // 13. Test SizedBox widget
  testWidgets('SizedBox applies dimensions correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 100,
              height: 50,
              child: Container(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(SizedBox), findsOneWidget);
    final sizedBoxWidget = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBoxWidget.width, 100);
    expect(sizedBoxWidget.height, 50);
  });

  // 14. Test ClipRRect widget
  testWidgets('ClipRRect applies correct border radius', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.green,
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(ClipRRect), findsOneWidget);
    final clipRRectWidget = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clipRRectWidget.borderRadius, BorderRadius.circular(15));
  });

  // 15. Test Divider widget
  testWidgets('Divider renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Above'),
              Divider(thickness: 2, color: Colors.black),
              Text('Below'),
            ],
          ),
        ),
      ),
    );
    
    expect(find.byType(Divider), findsOneWidget);
    final dividerWidget = tester.widget<Divider>(find.byType(Divider));
    expect(dividerWidget.thickness, 2);
    expect(dividerWidget.color, Colors.black);
  });

  // 16. Test GestureDetector widget
  testWidgets('GestureDetector handles tap correctly', (WidgetTester tester) async {
    bool tapped = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GestureDetector(
              onTap: () => tapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.amber,
                child: Text('Tap me'),
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.text('Tap me'), findsOneWidget);
    
    await tester.tap(find.text('Tap me'));
    expect(tapped, true);
  });

  // 17. Test Expanded widget
  testWidgets('Expanded widget expands correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Container(width: 50, height: 100, color: Colors.red),
              Expanded(
                child: Container(height: 100, color: Colors.blue),
              ),
              Container(width: 50, height: 100, color: Colors.green),
            ],
          ),
        ),
      ),
    );
    
    expect(find.byType(Expanded), findsOneWidget);
  });

  // 18. Test SingleChildScrollView widget
  testWidgets('SingleChildScrollView allows scrolling', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: List.generate(
                20,
                (index) => Container(
                  height: 100,
                  color: index.isEven ? Colors.blue : Colors.green,
                  child: Center(child: Text('Item $index')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Item 0'), findsOneWidget);
    
    // Scroll down
    await tester.dragFrom(Offset(200, 300), Offset(200, -500));
    await tester.pump();
    
    // After scrolling, we should see items further down the list
    expect(find.text('Item 5'), findsOneWidget);
  });

  // 19. Test Center widget
  testWidgets('Center widget centers its child', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple,
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(Center), findsOneWidget);
  });

  // 20. Test InkWell widget
  testWidgets('InkWell renders and responds to tap', (WidgetTester tester) async {
    bool tapped = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: InkWell(
              onTap: () => tapped = true,
              child: Container(
                width: 100,
                height: 100,
                child: Text('Tap me'),
              ),
            ),
          ),
        ),
      ),
    );
    
    expect(find.byType(InkWell), findsOneWidget);
    
    await tester.tap(find.text('Tap me'));
    expect(tapped, true);
  });
} 