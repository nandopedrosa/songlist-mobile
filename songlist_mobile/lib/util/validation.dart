class Validation {
  bool isValid;
  List<String> messages;

  Validation({
    required this.isValid,
    required this.messages,
  });

  String getMessagesMultiline() {
    String multiLineMessage = '';
    for (String message in messages) {
      multiLineMessage += message;
      multiLineMessage += "\n\n";
    }
    return multiLineMessage;
  }
}
