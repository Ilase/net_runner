import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/post_request_native/post_request_bloc.dart';
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
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hosts*',
                ),
                const AddHostsDialogue(),
                IconButton(
                  onPressed: (){
                    context.read<PostRequestBloc>().add(const PostRequestGetEvent(endpoint: '/host')); // TODO: remake dynamic
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            Expanded(
              child: BlocListener<PostRequestBloc, PostRequestState>(
                listener: (context, state){
                  if(state is PostRequestLoadFailureState){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
                  }
                },
                child: BlocBuilder<PostRequestBloc, PostRequestState>(
                  builder: (context, state){
                    if(state is PostRequestLoadSuccessState){
                      return ListView.builder(
                        itemCount: state.postData.length,
                        itemBuilder: (context, index){
                          final item = state.postData[index];
                          return ListTile(
                            leading: Text(item["ID"].toString()),
                            title: Text(item["ip"]),
                            subtitle: Text(item["name"] ?? "Unnamed"),
                            trailing: const Text  ("Trail"),
                          );
                        },
                      );
                    }
                    if(state is PostRequestLoadInProgressState){
                      return const Center(child: CircularProgressIndicator());
                    }
                    else {
                      return const Center(child: Text('Unexpected error. Try to reload list*'));
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
