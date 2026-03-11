import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_bloc.dart';
import 'package:vikas_app/bloc_management/notices/notice_event.dart';
import 'package:vikas_app/screeens/models/response/notice_response.dart';

class NoticeDetailPage extends StatefulWidget {
  final NoticeResponse notice;

  const NoticeDetailPage({super.key, required this.notice});

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {

  @override
  void initState() {
    super.initState();

    context.read<NoticeBloc>().add(
      MarkNoticeReadEvent(widget.notice.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.notice.title ?? 'Notice Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(widget.notice.description ?? 'No description available.'),
      ),
    );
  }
}