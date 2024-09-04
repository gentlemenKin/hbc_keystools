

// class ResultBean{
//   List<ItemBean> datas;
//   ResultBean({
//     required this.datas
// });
//   factory ResultBean.fromJson(List json) {
//     json.map((e) => ItemBean.fromJson(e)).toList();
//
//
//   }
// }



class ItemBean{

  int valutIndex;
  String Chain;
  String Address;
  String PrivKey;
  ItemBean({
    required this.valutIndex,
    required this.Chain,
    required this.Address,
    required this.PrivKey,
});
  factory ItemBean.fromJson(Map<String, dynamic> json) => ItemBean(
    valutIndex: json["VaultIndex"],
      Chain: json["Chain"],
    Address: json['Address'],
    PrivKey: json['PrivKey']
  );
}