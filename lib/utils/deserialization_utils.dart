class DeserializationUtils {
  static List<String> toStringList(List<dynamic> dynamicList) {
    return dynamicList.map((e) => e.toString()).toList();
  }
}