



















extension StringExtention on String {

  String rstrip(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    } else {
      return this;
    }
  }

  int? tryParseInt(){
    return int.tryParse(this);
  }
}