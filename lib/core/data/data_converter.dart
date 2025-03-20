DateTime convertUnixToDateTime(int timestamp) {
  if (timestamp.toString().length == 10) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  } else {
    return DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  }
}
