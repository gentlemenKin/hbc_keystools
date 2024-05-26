


class ChainItemBean{
  String name;
  String valName;
  ChainItemBean({
    required this.name,
    required this.valName,
  });
  factory ChainItemBean.fromJson(Map<String, dynamic> json) => ChainItemBean(
      name: json["name"]??"",
      valName: json["val"]??"",
  );
}