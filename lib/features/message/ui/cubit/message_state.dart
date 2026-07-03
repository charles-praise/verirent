// ── Models ─────────────────────────────────────────────────────────────────────

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:verirent/core/theme/agents_theme.dart';

enum MessageStatus { sent, delivered, read }

class ChatMessage extends Equatable {
  final String id;
  final String senderId; // 'me' or participant id
  final String text;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isSystem;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isSystem = false,
  });

  ChatMessage copyWith({MessageStatus? status}) => ChatMessage(
    id: id,
    senderId: senderId,
    text: text,
    timestamp: timestamp,
    status: status ?? this.status,
    isSystem: isSystem,
  );

  bool get isMe => senderId == 'me';

  @override
  List<Object?> get props => [id, senderId, text, timestamp, status];
}

class ChatThread extends Equatable {
  final String id;
  final String participantName;
  final String participantRole; // 'Agency', 'Landlord', 'Admin'
  final String? avatarUrl;
  final String initials;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isVerifiedAgency;
  final String? propertyTitle; // Context: which listing this chat is about
  final List<ChatMessage> messages;
  final Color tierColor;

  const ChatThread({
    required this.id,
    required this.participantName,
    required this.participantRole,
    this.avatarUrl,
    required this.initials,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isVerifiedAgency = false,
    this.propertyTitle,
    this.messages = const [],
    this.tierColor = VeriRentColors.tierVerified,
  });

  ChatThread copyWith({
    List<ChatMessage>? messages,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    Color? tierColor,
  }) => ChatThread(
    id: id,
    participantName: participantName,
    participantRole: participantRole,
    avatarUrl: avatarUrl,
    initials: initials,
    lastMessage: lastMessage ?? this.lastMessage,
    lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    unreadCount: unreadCount ?? this.unreadCount,
    isOnline: isOnline,
    isVerifiedAgency: isVerifiedAgency,
    propertyTitle: propertyTitle,
    messages: messages ?? this.messages,
    tierColor: tierColor ?? this.tierColor,
  );

  @override
  List<Object?> get props => [
    id,
    participantName,
    lastMessage,
    lastMessageTime,
    unreadCount,
    messages,
    tierColor,
  ];
}

// ── State ─────────────────────────────────────────────────────────────────────

enum MessagesStatus { initial, loading, loaded, error }

class MessagesState extends Equatable {
  final Set<String> selectedChatId;
  final bool isSelected;
  final MessagesStatus status;
  final List<ChatThread> threads;
  final String? activeChatId;
  final String composingText;
  final bool isSending;
  final String? errorMessage;

  const MessagesState({
    this.selectedChatId = const {},
    this.isSelected = false,
    this.status = MessagesStatus.initial,
    this.threads = const [],
    this.activeChatId,
    this.composingText = '',
    this.isSending = false,
    this.errorMessage,
  });

  ChatThread? get activeThread => activeChatId == null
      ? null
      : threads.firstWhere(
          (t) => t.id == activeChatId,
          orElse: () => threads.first,
        );

  int get totalUnread => threads.fold(0, (sum, t) => sum + t.unreadCount);

  MessagesState copyWith({
    Set<String>? selectedChatId,
    bool? isSelected,
    MessagesStatus? status,
    List<ChatThread>? threads,
    Object? activeChatId = _sentinel,
    String? composingText,
    bool? isSending,
    String? errorMessage,
  }) => MessagesState(
    status: status ?? this.status,
    threads: threads ?? this.threads,
    activeChatId: activeChatId == _sentinel
        ? this.activeChatId
        : activeChatId as String?,
    composingText: composingText ?? this.composingText,
    isSending: isSending ?? this.isSending,
    errorMessage: errorMessage ?? this.errorMessage,
    selectedChatId: selectedChatId ?? this.selectedChatId,
    isSelected: isSelected ?? this.isSelected,
  );

  @override
  List<Object?> get props => [
    status,
    threads,
    activeChatId,
    composingText,
    isSending,
    errorMessage,
    selectedChatId,
    isSelected,
  ];
}

// Sentinel for nullable copyWith
const _sentinel = Object();
