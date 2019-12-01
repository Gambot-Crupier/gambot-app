import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gambot/components/default_button.dart';
import 'package:gambot/components/raiseBetDialog.dart';
import 'package:gambot/globals.dart';
import 'package:gambot/requests/requests.dart';
import 'package:gambot/style.dart';


class Recognize extends StatefulWidget {
  @override
  _RecognizePageState createState() => _RecognizePageState();
}

class _RecognizePageState extends State<Recognize> {

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        padding: EdgeInsets.only(top: 130, left: 40, right: 40),
        child: ListView(
          children: <Widget>[
            Divider(),
            Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(16.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  margin(DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: Colors.black, fontSize: 25),
                    child: Text(
                      'Rodada de Reconhecimento'
                    )
                  )),
                  margin(SizedBox(
                    width: 160,
                    height: 50, 
                    child: DefaultButton(
                      text: 'Este sou eu!', 
                      fontSize: 20.0, 
                      fontColor: Colors.white,
                      backgroundColor: Colors.green,
                      func: () {
                        message(postPlayerId(), context);
                      },
                    ),
                  )),
                  margin(SizedBox(
                    width: 160,
                    height: 50,
                    child: DefaultButton(
                      text: 'Pular', 
                      fontSize: 20.0, 
                        fontColor: Colors.white,
                        backgroundColor: Colors.blue,
                        func: () {
                          message(skip(), context);
                        },
                    ),
                  )),
                  margin(SizedBox(
                    width: 160,
                    height: 50,
                    child: DefaultButton(
                      text: 'Finalizar', 
                      fontSize: 20.0, 
                        fontColor: Colors.white,
                        backgroundColor: Colors.red,
                        func: () => {
                          message(endRecognition(), context),
                          goToRound(context)
                        },
                    ),
                  )),




                  // Remover depois!
                  margin(SizedBox(
                    width: 160,
                    height: 50,
                    child: DefaultButton(
                      text: 'Aumentar aposta', 
                      fontSize: 20.0, 
                        fontColor: Colors.white,
                        backgroundColor: Colors.red,
                        func: () => {
                          raiseBet(context)
                        },
                    ),
                  )),




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget margin(Widget wid) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: wid,
    );
  }



  void goToRound(BuildContext context) async {
    try{
      await startRound();
    }  on Exception catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Erro"),
              content: Text(error.toString())
            );
          },
        );
      }

    await getRoundId();
    await roundRedirect();
  }



  void message(Future<dynamic> futureFunc, BuildContext context) async {
    var message = await futureFunc;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text("Reconhecimento"),
          content: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: new TextStyle(color: Colors.black, fontSize: 25),
            child: Text( message )
          )
        );
      },
    );                     
  }


  // Remover depois!!
  void raiseBet(BuildContext context) async {
    
    // Recuperar das APIs
    double valorApostaAtual = 1200.0;
    double dinheiroMaximoJogador = 15000.0;
    int divisoes = (dinheiroMaximoJogador - valorApostaAtual)~/100;

    double _value = valorApostaAtual;

    showDialog(
		context: context,
		builder: (BuildContext context) {
			return AlertDialog(
				content: StatefulBuilder(
					builder: (BuildContext context, StateSetter setState) {
						return Container(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  margin(Text('Aumente a aposta!')),
                  margin(Slider(
                        value: _value,
                        min: valorApostaAtual,
                        max: dinheiroMaximoJogador,
                        divisions: divisoes,
                        activeColor: Colors.red,
                        inactiveColor: Colors.black,
                        label: 'R\$ $_value',
                        onChanged: (double newValue) {
                          setState(() {
                            _value = newValue.round().toDouble();
                          });
                        },
                    )),
                    margin(SizedBox(
                    width: 160,
                    height: 50,
                    child: DefaultButton(
                      text: 'Aumentar', 
                      fontSize: 20.0, 
                        fontColor: Colors.white,
                        backgroundColor: DefaultStyle.green,
                        func: () => {
                          Navigator.pop(context)
                        },
                    ))),
                    margin(SizedBox(
                    width: 160,
                    height: 50,
                    child: DefaultButton(
                      text: 'Voltar', 
                      fontSize: 15.0, 
                        fontColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        func: () => {
                          Navigator.pop(context)
                        },
                    ))),
                ]
            ));
					},
				),
			);
		});                 
  }


}