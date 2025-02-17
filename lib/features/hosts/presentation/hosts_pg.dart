import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/api_data_controller/api_data_controller_bloc.dart';
import 'package:net_runner/core/domain/api_data_controller/api_request.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/add_hosts_dialog/presentation/add_hosts_dialogue.dart';

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
              onPressed: () {
                // context
                //     .read<ApiDataControllerBloc>()
                //     .add(GetRequestEvent(endpoint: '/ping'));
                // //context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(endpoint: '/ping')); //prefire
                // Navigator.of(context).pushNamed('/add-host');
              },
              child: Text('Add groups'),
            ),
            IconButton(
              onPressed: () {
                context
                    .read<ApiDataControllerBloc>()
                    .add(GetRequestEvent(endpoint: '/host'));
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
              onPressed: () {
                context
                    .read<ApiDataControllerBloc>()
                    .add(GetRequestEvent(endpoint: '/ping'));
                //context.read<PostRequestBloc>().add(PostRequestGetSingleTaskEvent(endpoint: '/ping')); //prefire
                Navigator.of(context).pushNamed('/add-host');
              },
              child: Text('Add hosts'),
            ),
            IconButton(
              onPressed: () {
                context
                    .read<ApiDataControllerBloc>()
                    .add(GetRequestEvent(endpoint: '/host'));
                // context.read<PostRequestBloc>().add(const PostRequestGetEvent(endpoint: '/host')); // TODO: remake dynamic
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        Expanded(
          child: Container(
            height: 1000,
            child: BlocListener<PostRequestBloc, PostRequestState>(
              listener: (context, state) {
                if (state is PostRequestLoadFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')));
                }
              },
              child: BlocBuilder<HostListCubit, HostListState>(
                builder: (context, state) {
                  if (state is FullState) {
                    return ListView.builder(
                      itemCount: state.hostList.length,
                      itemBuilder: (context, index) {
                        ntLogger.w(state.hostList.length);
                        final item = state.hostList[index];
                        if (state.hostList.length != 1) {
                          return ListTile(
                              leading: Text(item["ID"].toString()),
                              title: Text(item["ip"]),
                              subtitle: Text(item["name"] ?? "Unnamed"),
                              trailing: Container(
                                width: 400,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          context.read<PostRequestBloc>().add(
                                              PostRequestDeleteHostEvent(
                                                  hostId: item["ID"]));
                                          context.read<PostRequestBloc>().add(
                                              const PostRequestGetEvent(
                                                  endpoint: '/host'));
                                        },
                                        icon: Icon(Icons.delete_forever))
                                  ],
                                ),
                              ));
                        }
                      },
                    );
                  } else if (state is EmptyState) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.blue, size: 100),
                    );
                  } else {
                    return Placeholder();
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
