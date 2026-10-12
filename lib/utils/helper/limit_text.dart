String limitText(String text, {int maxLength = 12}) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}..';
}
