enum ConnectionStatus {
  // connected means there is currently an internet connection
  connected,
  // no internet connection at all, maybe, data or wifi is off
  disconnected,
  // data or wifi is turned on, but no internet
  connecting
}