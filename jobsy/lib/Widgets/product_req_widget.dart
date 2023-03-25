import 'package:flutter/material.dart';

class ProductReqWidget extends StatefulWidget {

  final String productCategory;
  final String productTitle;
  final String productDescription;
  final String productReqId;
  final String uploadedBy;
  final String productImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const ProductReqWidget({
    required this.productCategory,
    required this.productTitle,
    required this.productDescription,
    required this.productReqId,
    required this.uploadedBy,
    required this.productImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
});

  @override
  State<ProductReqWidget> createState() => _ProductReqWidgetState();
}

class _ProductReqWidgetState extends State<ProductReqWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: (){},
        onLongPress: (){},
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            )
          ),
          child: Image.network(widget.productImage),
        ),
        title: Text(
          widget.productTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.productDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
