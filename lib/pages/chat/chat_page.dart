import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';

/// Conversations List Page - Shows all chat conversations
class ConversationsListPage extends StatefulWidget {
  const ConversationsListPage({super.key});

  @override
  State<ConversationsListPage> createState() => _ConversationsListPageState();
}

class _ConversationsListPageState extends State<ConversationsListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock conversations data
  final List<_MockConversation> _conversations = [
    _MockConversation(
      id: '1',
      name: 'Dr. Sarah Ahmed',
      lastMessage: 'Thank you doctor! I\'ll follow the prescription.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      avatarIcon: Icons.medical_services_rounded,
    ),
    _MockConversation(
      id: '2',
      name: 'Dr. Karim Rahman',
      lastMessage: 'Your test results are ready. Please visit the clinic.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 2,
      avatarIcon: Icons.science_rounded,
    ),
    _MockConversation(
      id: '3',
      name: 'Dr. Fatima Khan',
      lastMessage: 'How are you feeling today?',
      time: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      avatarIcon: Icons.psychology_rounded,
    ),
  ];

  List<_MockConversation> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;
    return _conversations.where((c) =>
        c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isDark = themeProvider.isDarkMode;
    final isDoctor = authProvider.isDoctor;
    
    final primaryColor = isDoctor ? AppColors.doctorAccent : AppColors.patientAccent;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg1, AppColors.darkBg2, AppColors.darkBg1]
                : [AppColors.lightBg1, AppColors.lightBg2, AppColors.lightBg3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langProvider.translate('messages'),
                              style: AppTextStyles.displaySmall(textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_conversations.length} ${langProvider.translate('conversations')}',
                              style: AppTextStyles.bodySmall(textSecondary),
                            ),
                          ],
                        ),
                        // New message button
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDoctor
                                  ? [AppColors.doctorAccent, AppColors.secondary]
                                  : [AppColors.patientAccent, AppColors.primary],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: New conversation
                            },
                            icon: const Icon(Icons.edit_rounded, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Search bar
                    _buildSearchBar(isDark, langProvider, textSecondary),
                  ],
                ),
              ),
              
              // Conversations list
              Expanded(
                child: _filteredConversations.isEmpty
                    ? _buildEmptyState(langProvider, textSecondary)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _filteredConversations[index];
                          return _ConversationTile(
                            conversation: conversation,
                            isDark: isDark,
                            isDoctor: isDoctor,
                            textColor: textColor,
                            textSecondary: textSecondary,
                            primaryColor: primaryColor,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  conversationId: conversation.id,
                                  recipientName: conversation.name,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, LanguageProvider langProvider, Color textSecondary) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkGlassWhite
                : AppColors.lightGlassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
            ),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: langProvider.translate('search_conversations'),
              hintStyle: TextStyle(color: textSecondary),
              prefixIcon: Icon(Icons.search_rounded, color: textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider langProvider, Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            langProvider.translate('no_conversations'),
            style: AppTextStyles.titleMedium(textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Conversation tile widget
class _ConversationTile extends StatelessWidget {
  final _MockConversation conversation;
  final bool isDark;
  final bool isDoctor;
  final Color textColor;
  final Color textSecondary;
  final Color primaryColor;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.isDark,
    required this.isDoctor,
    required this.textColor,
    required this.textSecondary,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = conversation.unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDoctor
                        ? [AppColors.doctorAccent, AppColors.secondary]
                        : [AppColors.patientAccent, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  conversation.avatarIcon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            style: AppTextStyles.titleMedium(textColor).copyWith(
                              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(conversation.time),
                          style: AppTextStyles.labelSmall(
                            hasUnread ? primaryColor : textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage,
                            style: AppTextStyles.bodySmall(
                              hasUnread ? textColor : textSecondary,
                            ).copyWith(
                              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${conversation.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    return 'now';
  }
}

/// Mock conversation class
class _MockConversation {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime time;
  final int unreadCount;
  final IconData avatarIcon;

  _MockConversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.avatarIcon,
  });
}

/// Chat Page - Individual conversation
class ChatPage extends StatefulWidget {
  final String conversationId;
  final String recipientName;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.recipientName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  
  // Mock messages
  final List<_MockMessage> _messages = [
    _MockMessage(
      id: '1',
      text: 'Hello doctor, I\'ve been having headaches for the past few days.',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    _MockMessage(
      id: '2',
      text: 'I understand. Can you describe the pain? Is it constant or intermittent?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
    ),
    _MockMessage(
      id: '3',
      text: 'It\'s mostly on the left side and comes and goes. Sometimes it\'s worse in the morning.',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    _MockMessage(
      id: '4',
      text: 'Based on what you\'ve described, it sounds like tension headaches. I recommend getting adequate rest and staying hydrated. If it persists, please schedule an appointment.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
    ),
    _MockMessage(
      id: '5',
      text: 'Thank you doctor! I\'ll follow the prescription.',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(_MockMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _messageController.text.trim(),
        isMe: true,
        time: DateTime.now(),
      ));
      _messageController.clear();
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    final isDoctor = authProvider.isDoctor;
    
    final primaryColor = isDoctor ? AppColors.doctorAccent : AppColors.patientAccent;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg1, AppColors.darkBg2, AppColors.darkBg1]
                : [AppColors.lightBg1, AppColors.lightBg2, AppColors.lightBg3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(isDark, primaryColor, textColor, textSecondary, isDoctor),
              
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _MessageBubble(
                      message: message,
                      isDark: isDark,
                      primaryColor: primaryColor,
                      textColor: textColor,
                      textSecondary: textSecondary,
                    );
                  },
                ),
              ),
              
              // Input
              _buildMessageInput(isDark, langProvider, primaryColor, textColor, textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color primaryColor, Color textColor, 
      Color textSecondary, bool isDoctor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_rounded, color: textColor),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkGlassWhite
                  : AppColors.lightGlassWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDoctor
                    ? [AppColors.doctorAccent, AppColors.secondary]
                    : [AppColors.patientAccent, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          
          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipientName,
                  style: AppTextStyles.titleMedium(textColor),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.online,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online',
                      style: AppTextStyles.labelSmall(textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Video call button
          IconButton(
            onPressed: () {
              // TODO: Video call
            },
            icon: Icon(Icons.videocam_rounded, color: primaryColor),
            style: IconButton.styleFrom(
              backgroundColor: primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark, LanguageProvider langProvider,
      Color primaryColor, Color textColor, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {
              // TODO: Attach file
            },
            icon: Icon(Icons.attach_file_rounded, color: textSecondary),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkGlassWhite
                  : AppColors.lightGlassWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Text field
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkGlassWhite
                        : AppColors.lightGlassWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: langProvider.translate('type_message'),
                      hintStyle: TextStyle(color: textSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Send button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final _MockMessage message;
  final bool isDark;
  final Color primaryColor;
  final Color textColor;
  final Color textSecondary;

  const _MessageBubble({
    required this.message,
    required this.isDark,
    required this.primaryColor,
    required this.textColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? primaryColor
                    : (isDark ? AppColors.darkGlassWhite : AppColors.lightGlassWhite),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 20),
                ),
                border: message.isMe
                    ? null
                    : Border.all(
                        color: isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
                      ),
              ),
              child: Text(
                message.text,
                style: AppTextStyles.bodyMedium(
                  message.isMe ? Colors.white : textColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.time),
                  style: AppTextStyles.labelSmall(textSecondary),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: primaryColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Mock message class
class _MockMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;

  _MockMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}
