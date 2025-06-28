import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';

class TeamMessagesWidget extends StatefulWidget {
  const TeamMessagesWidget({super.key});

  @override
  State<TeamMessagesWidget> createState() => _TeamMessagesWidgetState();
}

class _TeamMessagesWidgetState extends State<TeamMessagesWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "sender": "Michael Chen",
      "message": "Good morning team! Ready for today's property showings?",
      "timestamp": "9:15 AM",
      "isMe": false,
      "avatar":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "messageType": "text"
    },
    {
      "id": 2,
      "sender": "You",
      "message":
          "Yes! I have 3 showings lined up. The waterfront villa client is very interested.",
      "timestamp": "9:18 AM",
      "isMe": true,
      "avatar": "",
      "messageType": "text"
    },
    {
      "id": 3,
      "sender": "Sarah Johnson",
      "message": "Great! I'll share the new luxury listings we just got.",
      "timestamp": "9:20 AM",
      "isMe": false,
      "avatar":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      "messageType": "text"
    },
    {
      "id": 4,
      "sender": "Sarah Johnson",
      "message": "Downtown Penthouse - \$1.2M",
      "timestamp": "9:21 AM",
      "isMe": false,
      "avatar":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      "messageType": "property_link",
      "propertyImage":
          "https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg",
      "propertyDetails": {
        "title": "Downtown Penthouse",
        "price": "\$1,200,000",
        "bedrooms": 3,
        "bathrooms": 3,
        "sqft": 1800
      }
    },
    {
      "id": 5,
      "sender": "David Wilson",
      "message":
          "I've updated the marketing materials. Here's the new brochure design.",
      "timestamp": "9:25 AM",
      "isMe": false,
      "avatar":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg",
      "messageType": "file",
      "fileName": "Q1_Marketing_Brochure.pdf",
      "fileSize": "2.4 MB"
    },
    {
      "id": 6,
      "sender": "Emily Rodriguez",
      "message":
          "Perfect timing! I have a client who's been looking for exactly this type of property.",
      "timestamp": "9:28 AM",
      "isMe": false,
      "avatar":
          "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
      "messageType": "text"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              })),
      _buildMessageInput(),
    ]);
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message["isMe"] as bool;

    return Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                    radius: 20,
                    backgroundImage: message["avatar"].isNotEmpty
                        ? CachedNetworkImageProvider(message["avatar"] as String)
                        : null,
                    backgroundColor:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    child: message["avatar"].isEmpty
                        ? CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20)
                        : null),
                SizedBox(width: 2.w),
              ],
              Flexible(
                  child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                    if (!isMe)
                      Padding(
                          padding: EdgeInsets.only(bottom: 0.5.h),
                          child: Text(message["sender"],
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w500))),
                    Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                            color: isMe
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12).copyWith(
                                bottomLeft: isMe
                                    ? Radius.circular(12)
                                    : Radius.circular(4),
                                bottomRight: isMe
                                    ? Radius.circular(4)
                                    : Radius.circular(12))),
                        child: _buildMessageContent(message, isMe)),
                    SizedBox(height: 0.5.h),
                    Text(message["timestamp"],
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant)),
                  ])),
              if (isMe) SizedBox(width: 2.w),
            ]));
  }

  Widget _buildMessageContent(Map<String, dynamic> message, bool isMe) {
    final messageType = message["messageType"] as String;
    final textColor = isMe
        ? AppTheme.lightTheme.colorScheme.onPrimary
        : AppTheme.lightTheme.colorScheme.onSurfaceVariant;

    switch (messageType) {
      case "property_link":
        return _buildPropertyLinkMessage(message, textColor);
      case "file":
        return _buildFileMessage(message, textColor);
      default:
        return Text(message["message"],
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: textColor));
    }
  }

  Widget _buildPropertyLinkMessage(
      Map<String, dynamic> message, Color textColor) {
    final propertyDetails = message["propertyDetails"] as Map<String, dynamic>;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(message["message"],
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(color: textColor)),
      SizedBox(height: 1.h),
      Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline, width: 1)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: CustomImageWidget(
                    imageUrl: message["propertyImage"] as String,
                    height: 20.h, 
                    width: double.infinity, 
                    fit: BoxFit.cover)),
            Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(propertyDetails["title"],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 0.5.h),
                      Text(propertyDetails["price"],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w600)),
                      SizedBox(height: 0.5.h),
                      Text(
                          '${propertyDetails["bedrooms"]} bed • ${propertyDetails["bathrooms"]} bath • ${propertyDetails["sqft"]} sqft',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                    ])),
          ])),
    ]);
  }

  Widget _buildFileMessage(Map<String, dynamic> message, Color textColor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(message["message"],
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(color: textColor)),
      SizedBox(height: 1.h),
      Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline, width: 1)),
          child: Row(children: [
            Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    color: AppTheme.accentLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.accentLight,
                    size: 24)),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(message["fileName"],
                      style: AppTheme.lightTheme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  Text(message["fileSize"],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant)),
                ])),
            CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.primaryColor,
                size: 20),
          ])),
    ]);
  }

  Widget _buildMessageInput() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
                top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline, width: 1))),
        child: SafeArea(
            child: Row(children: [
          IconButton(
              onPressed: _showAttachmentOptions,
              icon: CustomIconWidget(
                  iconName: 'attach_file',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24)),
          Expanded(
              child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      fillColor: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h)),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage())),
          SizedBox(width: 2.w),
          Container(
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  shape: BoxShape.circle),
              child: IconButton(
                  onPressed: _sendMessage,
                  icon: CustomIconWidget(
                      iconName: 'send',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20))),
        ])));
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "id": _messages.length + 1,
          "sender": "You",
          "message": _messageController.text.trim(),
          "timestamp": "Now",
          "isMe": true,
          "avatar": "",
          "messageType": "text"
        });
      });
      _messageController.clear();

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 2.h),
              Text('Share Content',
                  style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              _buildAttachmentOption('Property Listing', 'home_work', () {}),
              _buildAttachmentOption('Document', 'description', () {}),
              _buildAttachmentOption('Photo', 'photo_camera', () {}),
              _buildAttachmentOption('Location', 'location_on', () {}),
              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildAttachmentOption(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
        leading: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.primaryColor,
            size: 24),
        title: Text(title, style: AppTheme.lightTheme.textTheme.bodyLarge),
        onTap: () {
          Navigator.pop(context);
          onTap();
        });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}