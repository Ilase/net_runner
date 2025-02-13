import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/base_url.dart';
import 'package:net_runner/core/data/logger.dart';
import 'package:net_runner/core/domain/api_data_controller/api_data_controller_bloc.dart';
import 'package:net_runner/core/domain/connection_init/connection_init_bloc.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitWsConnectionPage extends StatefulWidget {
  static const String route = '/init';
  const InitWsConnectionPage({super.key});

  @override
  State<InitWsConnectionPage> createState() => _InitWsConnectionPageState();
}

class _InitWsConnectionPageState extends State<InitWsConnectionPage> {
  final TextEditingController _uriAddress = TextEditingController();
  List<String> _recentUrls = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadRecentUrls();
  }

  Future<void> _loadRecentUrls() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentUrls = prefs.getStringList('recent_urls') ?? [];
    });
  }

  Future<void> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    if (_recentUrls.contains(url)) {
      _recentUrls.remove(url);
    }
    _recentUrls.insert(0, url);
    if (_recentUrls.length > 5) {
      _recentUrls = _recentUrls.sublist(0, 5);
    }
    await prefs.setStringList('recent_urls', _recentUrls);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;
    return Scaffold(
      body: Center(
        child: BlocListener<ConnectionInitBloc, ConnectionInitState>(
          listener: (context, state) {
            if (state is ConnectionInitOk) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Connected!')));
              Navigator.of(context).pushNamed('/head');
            }
            if (state is ConnectionInitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')));
            }
          },
          child: SizedBox(
            width: 500,
            height: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Server address*'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Enter address with port*',
                      style: AppTextStyle.lightTextTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[\d\.\:]+$')),
                      ],
                      controller: _uriAddress,
                      decoration: const InputDecoration(labelText: 'Address*'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (_recentUrls.isNotEmpty) ...[
                      const Text('Recent URLs:'),
                      DropdownButton<String>(
                        value: _recentUrls.contains(_uriAddress.text) ? _uriAddress.text : null,
                        hint: const Text('Select a recent URL'),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _uriAddress.text = newValue;
                            });
                          }
                        },
                        items: _recentUrls.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_uriAddress.text.isNotEmpty) {
                            if (_uriAddress.text.isNotEmpty) {
                              context.read<ConnectionInitBloc>().add(
                                  ConnectionInitCheckEvent(
                                      uri:
                                          'http://${_uriAddress.text}/api/v1'));
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              if (context.read<ConnectionInitBloc>().state
                                  is ConnectionInitOk) {
                                baseUrl = _uriAddress.text;
                                context
                                    .read<ApiDataControllerBloc>()
                                    .apiService
                                    .updateBaseUrl(
                                        'http://${_uriAddress.text}/api/v1');
                                context.read<WebSocketBloc>().add(
                                    WebSocketConnect(
                                        'ws://${_uriAddress.text}/api/v1/ws'));
                                context.read<PostRequestBloc>().add(
                                    UpdateUriPostRequestEvent(
                                        uri: _uriAddress.text));
                                await _saveUrl(_uriAddress.text);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please fill all fields*')));
                            }
                          }
                        },
                        child: const Text('Connect'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
