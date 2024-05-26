

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
  String CoinType;
  String Address;
  String PrivKey;
  ItemBean({
    required this.valutIndex,
    required this.CoinType,
    required this.Address,
    required this.PrivKey,
});
  factory ItemBean.fromJson(Map<String, dynamic> json) => ItemBean(
    valutIndex: json["VaultIndex"],
    CoinType: json["Chain"],
    Address: json['Address'],
    PrivKey: json['PrivKey']
  );
}