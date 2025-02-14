import 'package:flutter/material.dart';

void main(){
  runApp(const TestBrowserClient());
}

class TestBrowserClient extends StatefulWidget {
  const TestBrowserClient({super.key});

  @override
  State<TestBrowserClient> createState() => _TestBrowserClientState();
}




class _TestBrowserClientState extends State<TestBrowserClient> {



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
