import 'package:flutter/material.dart';

import '../local/constant.dart';

class InputRowSelectWidget extends StatelessWidget {
  const InputRowSelectWidget({
    Key? key,
    required this.title,
    required this.hint,
    required this.callback,
    required this.showError,
    required this.errorMsg,
  }) : super(key: key);
  final String title;
  final String hint;
  final GestureTapCallback callback;
  final bool showError;
  final String errorMsg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 150,
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          SizedBox(width: 12,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric( horizontal: 16,vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xffE5E7Eb)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hint,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff6B7280)),
                      ),
                      Image.asset(AssetsConstant.moreIcon,height: 16,width: 16,)
                    ],
                  )
                ),
                if (showError)
                  Text(
                    errorMsg,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffE32349),
                      fontWeight: FontWeight.w500,
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
