import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? actionText;
  final String? actionUrl;
  final bool isActive;
  final int priority;
  final DateTime? startDate;
  final DateTime? endDate;
  
  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.actionText,
    this.actionUrl,
    required this.isActive,
    required this.priority,
    this.startDate,
    this.endDate,
  });
  
  factory BannerModel.fromMap(Map<String, dynamic> map, String docId) {
    return BannerModel(
      id: docId,
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
      actionText: map['actionText'],
      actionUrl: map['actionUrl'],
      isActive: map['isActive'] ?? false,
      priority: map['priority'] ?? 999,
      startDate: map['startDate'] != null ? (map['startDate'] as Timestamp).toDate() : null,
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'actionText': actionText,
      'actionUrl': actionUrl,
      'isActive': isActive,
      'priority': priority,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
    };
  }
  
  bool isCurrentlyActive() {
    final now = DateTime.now();
    
    // Check if banner is active
    if (!isActive) return false;
    
    // Check date range if specified
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    
    return true;
  }
} 