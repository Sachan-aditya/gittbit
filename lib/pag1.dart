import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GithubUserPage extends StatefulWidget {
  const GithubUserPage({Key? key}) : super(key: key);

  @override
  State<GithubUserPage> createState() => _GithubUserPageState();
}

class _GithubUserPageState extends State<GithubUserPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  bool _isLoading = false;
  Map<String, dynamic>? _userData;
  String _errorMessage = '';

  Future<void> _fetchUserData(String username) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://api.github.com/users/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _userData = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub User Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter GitHub Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
                onSaved: (value) => setState(() => _username = value!),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50.0),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await _fetchUserData(_username);
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Search User'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_userData != null) _buildUserDetails(_userData!),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails(Map<String, dynamic> userData) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userData['avatar_url']),
              radius: 50.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              userData['login'],
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            if (userData['name'] != null)
              _buildDetailRow('Name:', userData['name']),
            if (userData['bio'] != null)
              _buildDetailRow('Bio:', userData['bio']),
            _buildDetailRow(
                'Public Repositories:', userData['public_repos'].toString()),
            _buildDetailRow('Followers:', userData['followers'].toString()),
            _buildDetailRow('Following:', userData['following'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5.0),
          Text(value),
        ],
      ),
    );
  }
}
