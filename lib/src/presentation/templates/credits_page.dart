import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Menu(),
        appBar: AppBarRadio(enableBack: true),
        body:
        Container(
          margin: const EdgeInsets.only(top: 30, left: 30),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              "Créditos",
              style: TextStyle(
                shadows: [
                  Shadow(
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(0, -5))
                ],
                color: Colors.transparent,
                decorationThickness: 2,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decorationColor: Color(0xFFFCDC4D),
                decoration: TextDecoration.underline,
              ),
            ),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("• "),
              Expanded(
                  child: RichText(
                    text:  TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent

                      children: <TextSpan>[
                        TextSpan(
                            text:
                            'Rectora: \n',
                            style:
                            TextStyle(fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                            )),
                        TextSpan(
                            text: 'Dolly Montoya Castaño',
                            style:
                            TextStyle( color: Theme.of(context).primaryColor)
                        ),
                      ],
                    ),
                  )),
            ],
          )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("• "),
                  Expanded(
                      child: RichText(
                        text:  TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent

                          children: <TextSpan>[
                            TextSpan(
                                text:
                                'Rectora: \n',
                                style:
                                TextStyle(fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor
                                )),
                            TextSpan(
                                text: 'Dolly Montoya Castaño',
                                style:
                                TextStyle( color: Theme.of(context).primaryColor)
                            ),
                          ],
                        ),
                      )),
                ],
              )),
        ])
    )
    );
  }
}
