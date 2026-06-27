// =============================================================================
//  VeriRent NG — Messages Cubit
//  Manages: chat thread list  +  active chat screen
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:verirent/core/repo/local_repo.dart';

import '../../../../core/models/property_model.dart';
import 'message_state.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState()) {
    loadThreads();
  }

  final _localRepository = GetIt.I<LocalRepository>();

  Future<void> loadThreads() async {
    emit(state.copyWith(status: MessagesStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        state.copyWith(
          status: MessagesStatus.loaded,
          threads: _sortThreadsByRecent(await _localRepository.chatThreads()),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MessagesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<PropertyModel?> getPropertyForThread(ChatThread thread) async {
    if (thread.propertyTitle == null) return null;

    final properties = await _localRepository.all();

    try {
      return properties.firstWhere(
        (p) => p.title?.trim() == thread.propertyTitle!.trim(),
      );
    } catch (_) {
      return null;
    }
  }

  List<ChatThread> _sortThreadsByRecent(List<ChatThread> threads) {
    final sorted = [...threads];

    sorted.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    return sorted;
  }

  void clearSelection() {
    emit(state.copyWith(selectedChatId: {}, isSelected: false));
  }

  Future<void> deleteSelectedChats() async {
    final updatedThreads = state.threads
        .where((thread) => !state.selectedChatId.contains(thread.id))
        .toList();

    emit(
      state.copyWith(
        threads: updatedThreads,
        selectedChatId: {},
        isSelected: false,
        activeChatId: updatedThreads.any((t) => t.id == state.activeChatId)
            ? state.activeChatId
            : null,
      ),
    );
  }

  void markSelectedAsRead() {
    final updatedThreads = state.threads.map((thread) {
      if (!state.selectedChatId.contains(thread.id)) {
        return thread;
      }

      return thread.copyWith(unreadCount: 0);
    }).toList();

    emit(
      state.copyWith(
        threads: updatedThreads,
        selectedChatId: {},
        isSelected: false,
      ),
    );
  }

  void markSelectedAsUnread() {
    final updatedThreads = state.threads.map((thread) {
      if (!state.selectedChatId.contains(thread.id)) {
        return thread;
      }

      return thread.copyWith(unreadCount: 1);
    }).toList();

    emit(
      state.copyWith(
        threads: _sortThreadsByRecent(updatedThreads),
        selectedChatId: {},
        isSelected: false,
      ),
    );
  }

  void toggleChatSelection(String threadId) {
    final selected = {...state.selectedChatId};

    if (selected.contains(threadId)) {
      selected.remove(threadId);
    } else {
      selected.add(threadId);
    }

    emit(
      state.copyWith(selectedChatId: selected, isSelected: selected.isNotEmpty),
    );
  }

  Future<void> openChatFromListingPage(
    AgencyModel agency,
    PropertyModel property,
  ) async {
    final existing = state.threads.where((t) => t.id == agency.id);

    if (existing.isNotEmpty) {
      openChat(agency.id ?? '');
      return;
    }

    final thread = ChatThread(
      id: agency.id ?? '',
      participantName: agency.name ?? 'Agency',
      participantRole: agency.verificationTier?.name ?? 'Agency',
      initials: agency.name?.substring(0, 2).toUpperCase() ?? 'AG',
      lastMessage: '',
      lastMessageTime: DateTime.now(),
      isVerifiedAgency: agency.verificationTier != VerificationTier.basic,
      propertyTitle: property.title,
      avatarUrl: agency.agentAvatarUrl ?? '',
      isOnline: true,
    );
    final List<ChatThread> sortedThread = [...state.threads, thread];
    emit(state.copyWith(threads: sortedThread, activeChatId: thread.id));
  }

  /// Open a chat thread (navigate to chat screen)
  void openChat(String threadId) {
    // Mark as read
    final updatedThreads = state.threads.map((t) {
      if (t.id == threadId) return t.copyWith(unreadCount: 0);
      return t;
    }).toList();
    emit(
      state.copyWith(
        activeChatId: threadId,
        threads: updatedThreads,
        composingText: '',
      ),
    );
  }

  /// Close chat (go back to list)
  void closeChat() => emit(state.copyWith(activeChatId: null));

  void updateComposingText(String text) =>
      emit(state.copyWith(composingText: text));

  Future<void> sendMessage() async {
    final text = state.composingText.trim();
    if (text.isEmpty || state.activeChatId == null) return;

    emit(state.copyWith(isSending: true, composingText: ''));

    final newMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    final updatedThreads = state.threads.map((t) {
      if (t.id == state.activeChatId) {
        return t.copyWith(
          messages: [...t.messages, newMsg],
          lastMessage: text,
          lastMessageTime: DateTime.now(),
        );
      }
      return t;
    }).toList();

    emit(
      state.copyWith(
        threads: _sortThreadsByRecent(updatedThreads),
        isSending: false,
      ),
    );

    // Simulate delivery status after 1s
    await Future.delayed(const Duration(seconds: 1));
    _updateMessageStatus(
      state.activeChatId!,
      newMsg.id,
      MessageStatus.delivered,
    );

    // Simulate a reply after 2s
    await Future.delayed(const Duration(seconds: 2));
    _simulateReply(state.activeChatId!);
  }

  void _updateMessageStatus(
    String threadId,
    String msgId,
    MessageStatus status,
  ) {
    final updatedThreads = state.threads.map((t) {
      if (t.id != threadId) return t;
      final updatedMsgs = t.messages.map((m) {
        if (m.id == msgId) return m.copyWith(status: status);
        return m;
      }).toList();
      return t.copyWith(messages: updatedMsgs);
    }).toList();
    emit(state.copyWith(threads: updatedThreads));
  }

  void _simulateReply(String threadId) {
    final thread = state.threads.firstWhere(
      (t) => t.id == threadId,
      orElse: () => state.threads.first,
    );
    const replies = [
      'Thank you for your interest! Please let us know a convenient time for a viewing.',
      'The property is still available. Would you like to schedule a viewing?',
      'We appreciate your inquiry. Our agent will be in touch shortly.',
      'Great news — the landlord is flexible on move-in dates. When are you available?',
    ];
    final replyText = replies[DateTime.now().millisecond % replies.length];

    final replyMsg = ChatMessage(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      senderId: thread.id,
      text: replyText,
      timestamp: DateTime.now(),
      status: MessageStatus.read,
    );

    final updatedThreads = state.threads.map((t) {
      if (t.id != threadId) return t;
      return t.copyWith(
        messages: [...t.messages, replyMsg],
        lastMessage: replyText,
        lastMessageTime: DateTime.now(),
      );
    }).toList();
    emit(state.copyWith(threads: _sortThreadsByRecent(updatedThreads)));
  }
}
