import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  final List<_ChatMessage> _messages = [];
  late final AnimationController _pulseController;

  final List<String> _suggestions = [
    'Recommend a breakfast recipe',
    'Suggest a quick lunch',
    'Low-carb dinner ideas',
    'Vegetarian protein swaps',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onSuggestionTap(String text) {
    setState(() {
      _messages.add(_ChatMessage(text: text, fromBot: false));
      // Simulate bot response
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _messages.add(_ChatMessage(
              text: 'Got it — here are a few ideas for: "$text"',
              fromBot: true));
        });
      });
    });
  }

  void _openMenu() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const _PlaceholderPage(title: 'Chatbot Menu')));
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE02200);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ChatBOT',
                style: GoogleFonts.poppins(
                    color: Colors.black87, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text('1.0',
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: _openMenu),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // centered bot avatar area
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: ScaleTransition(
                            scale: Tween(begin: 0.95, end: 1.05).animate(
                                CurvedAnimation(
                                    parent: _pulseController,
                                    curve: Curves.easeInOut)),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: red,
                              child: ClipOval(
                                  child: Image.asset(
                                      'assets/images/bot_avatar.png',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = _messages[index - 1];
                    return Align(
                      alignment: msg.fromBot
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: msg.fromBot ? const Color(0xFFF3F4F6) : red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg.text,
                            style: GoogleFonts.poppins(
                                color: msg.fromBot
                                    ? Colors.black87
                                    : Colors.white)),
                      ),
                    );
                  },
                ),
              ),

              // Suggestions strip
              Container(
                height: 96,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final text = _suggestions[i];
                    return GestureDetector(
                      onTap: () => _onSuggestionTap(text),
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text('for a high-protein start to the day',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade500, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool fromBot;

  _ChatMessage({required this.text, this.fromBot = true});
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          Center(child: Text(title, style: GoogleFonts.poppins(fontSize: 18))),
    );
  }
}
