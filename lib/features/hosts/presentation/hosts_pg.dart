import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/features/scanning/presentation/widgets/gesture_card.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

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
                Text(
                  'Hosts*',
                ),
                OutlinedButton(
                    onPressed: (){

                    },
                    child: Text('Add host*'),
                ),
                IconButton(
                  onPressed: (){
                    context.read<PostRequestBloc>().add(PostRequestGetEvent(endpoint: '/host'/*"http://192.168.20.140:3001/api/v1/host"*/)); // TODO: remake dynamic
                  },
                  icon: Icon(Icons.refresh),
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
                            trailing: Text  ("Trail"),
                          );
                        },
                      );
                    }
                    if(state is PostRequestLoadInProgressState){
                      return Center(child: CircularProgressIndicator());
                    }
                    else {
                      return Center(child: Text('Unexpected error. Try to reload list*'));
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
