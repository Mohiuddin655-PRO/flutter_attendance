import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_attendence/card_helper.dart';

class EmployeeDetailsCard extends StatelessWidget {
  const EmployeeDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Row(
        children: [
          ImageView(
            image: "",
            background: Colors.grey.withOpacity(0.5),
            width: 40,
            shape: ViewShape.circular,
          ),
          LinearLayout(
            marginStart: 16,
            children: [
              const TextView(
                text: "Sachin Raut",
                textColor: Colors.black,
                textSize: 18,
                textFontWeight: FontWeight.w600,
              ),
              LinearLayout(
                orientation: Axis.horizontal,
                children: [
                  const IconView(
                    icon: Icons.date_range_outlined,
                  ),
                  TextView(
                    text: "Saturday 21 June 2019",
                    textColor: Colors.black.withOpacity(0.8),
                    textSize: 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
