import 'package:flutter/material.dart';

class HostsPg extends StatefulWidget {
  const HostsPg({super.key});

  @override
  State<HostsPg> createState() => _HostsPgState();
}

class _HostsPgState extends State<HostsPg> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(tabs: [
              Tab(
                text: 'Hosts',
              ),
              Tab(
                text: 'Groups',
              ),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHostTab(context),
                  _buildGroupTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTab(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Groups*',
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Add groups'),
            ),
            IconButton(
              onPressed: () {
                // context.read<PostRequestBloc>().add(const PostRequestGetEvent(endpoint: '/host')); // TODO: remake dynamic
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHostTab(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hosts*',
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Add hosts'),
            ),
            IconButton(
              onPressed: () {
                //TODO: remake dynamic
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ],
    );
  }
}
