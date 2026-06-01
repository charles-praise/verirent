// ── Mock data ──────────────────────────────────────────────────────────────

import '../ui/cubit/message_state.dart';

List<ChatThread> mockThreads() {
  final now = DateTime.now();
  return [
    ChatThread(
      id: 'thread_1',
      participantName: 'Greenfield Estates',
      participantRole: 'Agency',
      initials: 'GE',
      lastMessage:
          'The property is available from 1st July. Would you like to arrange a viewing?',
      lastMessageTime: now.subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
      isVerifiedAgency: true,
      propertyTitle: '3 Bedroom Flat, GRA Phase 2',
      messages: [
        ChatMessage(
          id: 'm1',
          senderId: 'thread_1',
          text:
              'Hello! Thank you for your interest in the GRA Phase 2 property.',
          timestamp: now.subtract(const Duration(hours: 1)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'm2',
          senderId: 'me',
          text:
              'Hi, I would like to know more about the property. Is it still available?',
          timestamp: now.subtract(const Duration(minutes: 50)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'm3',
          senderId: 'thread_1',
          text:
              'Yes, it is still available! The asking rent is ₦1,800,000 per annum.',
          timestamp: now.subtract(const Duration(minutes: 45)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'm4',
          senderId: 'me',
          text: 'Great. Are utilities included?',
          timestamp: now.subtract(const Duration(minutes: 20)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'm5',
          senderId: 'thread_1',
          text:
              'The property is available from 1st July. Would you like to arrange a viewing?',
          timestamp: now.subtract(const Duration(minutes: 5)),
          status: MessageStatus.delivered,
        ),
      ],
    ),
    ChatThread(
      id: 'thread_2',
      participantName: 'Apex Realty NG',
      participantRole: 'Agency',
      initials: 'AR',
      lastMessage:
          'Documents are ready. Please visit our office at your convenience.',
      lastMessageTime: now.subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
      isVerifiedAgency: true,
      propertyTitle: 'Executive Duplex, Trans-Amadi',
      messages: [
        ChatMessage(
          id: 'a1',
          senderId: 'thread_2',
          text:
              'Good day! This is Apex Realty regarding the Trans-Amadi duplex.',
          timestamp: now.subtract(const Duration(hours: 3)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'a2',
          senderId: 'me',
          text:
              'Yes, I\'m very interested. What are the title documents available?',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'a3',
          senderId: 'thread_2',
          text:
              'Documents are ready. Please visit our office at your convenience.',
          timestamp: now.subtract(const Duration(hours: 2)),
          status: MessageStatus.read,
        ),
      ],
    ),
    ChatThread(
      id: 'thread_3',
      participantName: 'HomeFinders NG',
      participantRole: 'Agency',
      initials: 'HF',
      lastMessage:
          'We have two other options in Rumuola that match your budget.',
      lastMessageTime: now.subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: true,
      isVerifiedAgency: false,
      propertyTitle: 'Studio Apartment, Rumuola',
      messages: [
        ChatMessage(
          id: 'h1',
          senderId: 'thread_3',
          text: 'Hello! We noticed you saved our Rumuola studio listing.',
          timestamp: now.subtract(const Duration(days: 1, hours: 2)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'h2',
          senderId: 'me',
          text: 'Yes, I\'m looking for something around that price range.',
          timestamp: now.subtract(const Duration(days: 1, hours: 1)),
          status: MessageStatus.read,
        ),
        ChatMessage(
          id: 'h3',
          senderId: 'thread_3',
          text: 'We have two other options in Rumuola that match your budget.',
          timestamp: now.subtract(const Duration(days: 1)),
          status: MessageStatus.delivered,
        ),
      ],
    ),
    ChatThread(
      id: 'thread_4',
      participantName: 'VeriRent Support',
      participantRole: 'Admin',
      initials: 'VR',
      lastMessage:
          'Your account has been verified. You can now access all features.',
      lastMessageTime: now.subtract(const Duration(days: 3)),
      unreadCount: 0,
      isOnline: true,
      isVerifiedAgency: false,
      messages: [
        ChatMessage(
          id: 'sys1',
          senderId: 'thread_4',
          text: 'Welcome to VeriRent NG! Your account has been created.',
          timestamp: now.subtract(const Duration(days: 4)),
          status: MessageStatus.read,
          isSystem: true,
        ),
        ChatMessage(
          id: 'sys2',
          senderId: 'thread_4',
          text:
              'Your account has been verified. You can now access all features.',
          timestamp: now.subtract(const Duration(days: 3)),
          status: MessageStatus.read,
          isSystem: true,
        ),
      ],
    ),
  ];
}
