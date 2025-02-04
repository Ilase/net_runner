import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/post_request_native/post_request_bloc.dart';
import 'package:net_runner/core/presentation/widgets/dialog_tile.dart';

class AddHostsDialogue extends StatefulWidget {
  const AddHostsDialogue({super.key});

  @override
  State<AddHostsDialogue> createState() => _AddHostsDialogueState();
}

class _AddHostsDialogueState extends State<AddHostsDialogue>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    context
        .read<PostRequestBloc>()
        .add(const PostRequestGetSingleTaskEvent(endpoint: '/ping'));
    return MtOpenDialogButton(
      dialogueTitle: 'Add hosts*',
      buttonTitle: 'Add hosts*',
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              height: MediaQuery.of(context).size.height - 430,
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<PostRequestBloc, PostRequestState>(
                      builder: (context, state) {
                        if (state is PostRequestLoadSingleSuccessState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.postData["activeHosts"].length,
                            itemBuilder: (builder, index) {
                              return CheckboxListTile(
                                title: Text('Host $index'),
                                subtitle: Text(
                                    '${state.postData["activeHosts"][index]}'),
                                value: true,
                                onChanged: (value) {},
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Expanded(child: Placeholder()),
                        Expanded(child: Placeholder()),
                        Expanded(child: Placeholder()),
                      ],
                    ),
                  ),


                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
