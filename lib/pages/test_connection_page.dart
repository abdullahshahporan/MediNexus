import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestConnectionPage extends StatefulWidget {
  const TestConnectionPage({super.key});

  @override
  State<TestConnectionPage> createState() => _TestConnectionPageState();
}

class _TestConnectionPageState extends State<TestConnectionPage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading messages...';
    });

    try {
      final response = await _supabase
          .from('test_connection')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _messages = List<Map<String, dynamic>>.from(response);
        _statusMessage = 'Loaded ${_messages.length} messages';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _insertTestMessage() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Inserting message...';
    });

    try {
      await _supabase.from('test_connection').insert({
        'message': 'Test message at ${DateTime.now().toIso8601String()}',
      });

      setState(() {
        _statusMessage = 'Message inserted successfully!';
      });

      // Reload messages after insert
      await _loadMessages();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error inserting: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAllMessages() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing messages...';
    });

    try {
      await _supabase.from('test_connection').delete().neq('id', 0);

      setState(() {
        _statusMessage = 'All messages cleared!';
      });

      await _loadMessages();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Connection Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Connection Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage.isEmpty
                          ? 'Ready to test connection'
                          : _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _statusMessage.contains('Error')
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(height: 8),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _insertTestMessage,
              icon: const Icon(Icons.add),
              label: const Text('Insert Test Message'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _loadMessages,
              icon: const Icon(Icons.refresh),
              label: const Text('Reload Messages'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _clearAllMessages,
              icon: const Icon(Icons.delete),
              label: const Text('Clear All Messages'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Messages in Database:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Text('No messages yet. Insert one to test!'),
                    )
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${message['id']}'),
                            ),
                            title: Text(message['message'] ?? ''),
                            subtitle: Text(
                              'Created: ${message['created_at']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
