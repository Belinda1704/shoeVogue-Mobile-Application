import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AiFeaturesController extends GetxController {
  final RxBool isProcessing = false.obs;
  final RxString footSize = ''.obs;
  final RxString selectedShoeImage = ''.obs;
  final RxString virtualTryOnImage = ''.obs;
  final RxBool hasError = false.obs;
  
  final ImagePicker _picker = ImagePicker();
  late FaceDetector _faceDetector;
  late ObjectDetector _objectDetector;
  
  @override
  void onInit() {
    super.onInit();
    _initializeDetectors();
  }
  
  Future<void> _initializeDetectors() async {
    try {
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableLandmarks: true,
          performanceMode: FaceDetectorMode.accurate,
        ),
      );
      
      _objectDetector = ObjectDetector(
        options: ObjectDetectorOptions(
          mode: DetectionMode.single,
          classifyObjects: true,
          multipleObjects: false,
        ),
      );
    } catch (e) {
      print('Error initializing detectors: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize AI features. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> measureFootSize() async {
    try {
      isProcessing.value = true;
      hasError.value = false;
      
      // Get image from camera
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      
      if (image != null) {
        // Process image to detect foot
        final inputImage = InputImage.fromFilePath(image.path);
        final faces = await _faceDetector.processImage(inputImage);
        
        if (faces.isNotEmpty) {
          // Calculate foot size based on face detection
          // This is a simplified example - you would need more sophisticated measurements
          footSize.value = 'US 10'; // Replace with actual calculation
        } else {
          Get.snackbar(
            'No Detection',
            'Please ensure your foot is clearly visible in the image',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Cancelled',
          'Image capture was cancelled',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      hasError.value = true;
      print('Error measuring foot size: $e');
      Get.snackbar(
        'Error',
        'Failed to measure foot size. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }
  
  Future<void> virtualTryOn(String shoeImagePath) async {
    try {
      isProcessing.value = true;
      hasError.value = false;
      
      // First verify the shoe image exists
      if (!await File(shoeImagePath).exists() && !shoeImagePath.startsWith('assets/')) {
        throw Exception('Shoe image not found');
      }
      
      selectedShoeImage.value = shoeImagePath;
      
      // Get user's photo
      final XFile? userImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      
      if (userImage != null) {
        // Create temporary directory if it doesn't exist
        final directory = await getTemporaryDirectory();
        final fileName = 'virtual_try_on_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = path.join(directory.path, fileName);
        
        // For now, we'll just copy the user's image
        // In a real implementation, this would be where the AI processing happens
        await File(userImage.path).copy(filePath);
        virtualTryOnImage.value = filePath;
      } else {
        Get.snackbar(
          'Cancelled',
          'Image capture was cancelled',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      hasError.value = true;
      print('Error in virtual try-on: $e');
      Get.snackbar(
        'Error',
        'Failed to process virtual try-on. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reset the images on error
      selectedShoeImage.value = '';
      virtualTryOnImage.value = '';
    } finally {
      isProcessing.value = false;
    }
  }
  
  @override
  void onClose() {
    _faceDetector.close();
    _objectDetector.close();
    super.onClose();
  }
} 