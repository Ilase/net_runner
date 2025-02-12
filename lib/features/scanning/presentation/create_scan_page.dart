import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api/host_list/host_list_cubit.dart';
import 'package:net_runner/core/domain/api_data_controller/api_data_controller_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';

class CreateScanPage extends StatefulWidget {
  const CreateScanPage({super.key});
  static const String route = '/create-scan';

  @override
  State<CreateScanPage> createState() => _CreateScanPageState();
}

class _CreateScanPageState extends State<CreateScanPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _portsController = TextEditingController();
  final TextEditingController _scanTypeController = TextEditingController();
  final Map<String, dynamic> _scanTypeValues = {"pentest": "pentest"};
  double currentSliderValue = 1;

  // List to keep track of selected IPs
  List<String> selectedIPs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New scan'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text('Settings'),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.accessible_forward_sharp),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Scan type: '),
                      Expanded(
                        child: DropdownMenu(
                          controller: _scanTypeController,
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                              value: _scanTypeValues["pentest"],
                              label: 'pentest',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Speed'),
                  Slider(
                    label: '${currentSliderValue.toInt()}',
                    value: currentSliderValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (double value) {
                      setState(() {
                        currentSliderValue = value;
                      },);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _portsController,
                    decoration: const InputDecoration(labelText: 'Ports'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // You can use the selectedIPs list here
                      ntLogger.t('Selected IPs: $selectedIPs');
                      context.read<PostRequestBloc>().add(PostRequestSendEvent(
                        endpoint: '/task',
                        body: {
                          "name": _nameController.text,
                          "hosts": selectedIPs,
                          "type": _scanTypeController.text,
                          "params": {
                            "ports": _portsController.text,
                            "speed": currentSliderValue.toInt().toString()

                          }
                        },
                      ),
                      );
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      offset: Offset(0, 2),
                      color: Colors.black,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Scan targets'),
                        IconButton(
                          onPressed: () {
                            // context.read<PostRequestBloc>().add(const PostRequestGetEvent(endpoint: '/host'));
                            context.read<ApiDataControllerBloc>().add(GetRequestEvent(endpoint: '/host'));
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    Expanded(
                      child: BlocBuilder<HostListCubit, HostListState>(
                        // listener: (listener, state) {
                        //   if (state is PostRequestLoadFailureState) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text(state.error)),
                        //     );
                        //   }
                        // },
                        builder: (context, state) {
                          if (state is EmptyState) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is FullState) {
                            return ListView.builder(
                              itemCount: state.hostList.length,
                              itemBuilder: (context, index) {
                                final item = state.hostList[index];
                                final ip = item['ip'];
                                final isChecked = selectedIPs.contains(ip);
                                return ListTile(
                                  title: Text(ip ?? 'No IP'),
                                  subtitle: Text(item['name'] ?? 'No Name'),
                                  trailing: Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value != null && value) {
                                          selectedIPs.add(ip);
                                        } else {
                                          selectedIPs.remove(ip);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(child: Text('oops'),);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
