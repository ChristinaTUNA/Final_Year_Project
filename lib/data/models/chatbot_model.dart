class ChatMessage {
  final String text;
  final bool fromBot;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.fromBot,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
