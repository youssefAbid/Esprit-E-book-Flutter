import 'package:esprit_ebook_app/constants.dart';
import 'package:flutter/material.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Container(
      height: 170,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Sub Total :",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                RichText(
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  text: TextSpan(
                    text: '\$ ',
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(text: '33.50', style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Delivery Fee :",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),

                RichText(
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  text: TextSpan(
                    text: '\$ ',
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(text: '5.00', style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                )

              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '15 (20%)',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                RichText(
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  text: TextSpan(
                    text: '\$ ',
                    style: Theme.of(context).textTheme.subtitle1,
                    children: <TextSpan>[
                      TextSpan(text: '3.5', style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.centerEnd,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: FlatButton(
                    onPressed: () {

                    },
                    disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    color: kProgressIndicator,
                    shape: StadiumBorder(),
                    child: Text(
                      "Check out",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                    RichText(
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      text: TextSpan(
                        text: '\$ ',
                        style: Theme.of(context).textTheme.subtitle1,
                        children: <TextSpan>[
                          TextSpan(text: '1.5', style: Theme.of(context).textTheme.subtitle1 ),
                        ],
                      ),
                    )


                )
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
