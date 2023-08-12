class DeserializationUtils {
  static List<String> toStringList(List<dynamic> dynamicList, {
    bool applyLowerCasing = false
  }) {
    return dynamicList.map((e) => checkApplyLowerCasing(e.toString(), applyLowerCasing)).toList();
  }

  static String checkApplyLowerCasing(String string, bool applyLowerCasing) {
    if (applyLowerCasing) {
      return string.toLowerCase();
    } else {
      return string;
    }
  }
}