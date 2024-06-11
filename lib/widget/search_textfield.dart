import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hbc_keystools/local/constant.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.type = 'noborder', // noborder, border
    this.width = 240,
    this.height = 30,
    this.fontSize = 14,
    this.hintText = '',
    required this.onSearch,
    this.onInput,
  });

  final String type;
  final double width;
  final double height;
  final double fontSize;
  final String hintText;
  final Function onSearch;
  final Function? onInput;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      widget.onSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: 260,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: widget.type == 'noborder'
            ? const Color(0xffF3F4F6)
            : const Color(0xffffffff),
        borderRadius: BorderRadius.circular(widget.type == 'noborder' ? 20 : 4),
        border: Border.all(
          width: 1,
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (widget.onInput != null) {
                  widget.onInput!(value);
                }
              },
              onSubmitted: (value) {
                // print(value);
            
              },
              style: TextStyle(
                // fontSize: 14,
                fontSize: widget.fontSize,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                // border: InputBorder.none,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  // fontSize: 14,
                  fontSize: widget.fontSize,
                  color: const Color(0xffAAAAAA),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                print("object");
                widget.onSearch(searchController.text);
              },
              child: Image.asset(
                AssetsConstant.searchIcon,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
