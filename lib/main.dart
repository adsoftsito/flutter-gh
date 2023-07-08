import 'package:flutter/material.dart';
import 'strings.dart' as strings;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const GHFlutterApp());

class GHFlutter extends StatefulWidget {
  const GHFlutter({super.key});

  @override
  State<GHFlutter> createState() => _GHFlutterState();
}

class _GHFlutterState extends State<GHFlutter> {
  //var _members = <dynamic>[];
  final _members = <Member>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Future<void> _loadData() async {
    const dataUrl =
        'https://api.github.com/orgs/tecnologico-de-monterrey-oficial/members';
    final response = await http.get(Uri.parse(dataUrl));
/*    setState(() {
      _members = json.decode(response.body) as List;
      //print(_members);
    });
*/

    setState(() {
      final dataList = json.decode(response.body) as List;
        for (final item in dataList) {
          final login = item['login'] as String? ?? '';
          final url = item['avatar_url'] as String? ?? '';

	  final member = Member(login, url);
          _members.add(member);
        } 
    });

  }
  
  Widget _buildRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
	title: Text('${_members[i].login}', style: _biggerFont),
	leading: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage(_members[i].avatarUrl),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.appTitle),
      ),
      body: ListView.separated(
          itemCount: _members.length,
          itemBuilder: (BuildContext context, int position) {
            return _buildRow(position);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          }),
    );
  }
}

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.appTitle,
      home: const GHFlutter(),
    );
  }
}

class Member {
  Member(this.login, this.avatarUrl);
  final String login;
  final String avatarUrl;
}

