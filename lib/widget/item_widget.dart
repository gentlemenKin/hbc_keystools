import 'package:flutter/material.dart';
typedef IsItemSelect = Function(String name);

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    Key? key,
    required this.title,
    required this.callback,
  }) : super(key: key);
  final String  title;
  final IsItemSelect callback;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with AutomaticKeepAliveClientMixin {
  // final List<String> ids = [];
  bool select = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4,
        right: 7,
        left: 7,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          Checkbox(
              value: select,
              onChanged: (value) {
                setState(() {
                  select = value ?? false;
                });

                widget.callback(widget.title);
                // if (value ?? false) {
                //   ids.add(widget.bean.id);
                // } else {
                //   ids.remove(widget.bean.id);
                // }
              }),
          const SizedBox(
            width: 16,
          ),
          Text(widget.title,style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}