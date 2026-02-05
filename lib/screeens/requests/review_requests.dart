import 'package:flutter/material.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ReviewRequests extends StatefulWidget {
  const ReviewRequests({super.key});

  @override
  State<ReviewRequests> createState() => _ReviewRequestsState();
}

class _ReviewRequestsState extends State<ReviewRequests> {
  @override
  Widget build(BuildContext context) {
    return Layout(child: Center(child: Text("Review Requests")));
  }
}
