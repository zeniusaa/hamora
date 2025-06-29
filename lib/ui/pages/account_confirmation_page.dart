part of 'pages.dart';

class AccountConfirmationPage extends StatefulWidget {
  final RegistrasionData registrationData;

  AccountConfirmationPage(this.registrationData);

  @override
  _AccountConfirmationPageState createState() =>
      _AccountConfirmationPageState();
}

class _AccountConfirmationPageState extends State<AccountConfirmationPage> {
  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context
            .read<PageBloc>()
            .add(GoToRegistrasionPage(widget.registrationData));
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 90),
                  height: 56,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            context.read<PageBloc>().add(GoToSplashPage());
                          },
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Confirm\nNew Account",
                          style: blackTextFont.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(bottom: 20),
                ),
                Text(
                  "Welcome",
                  style: blackTextFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "${widget.registrationData.name}",
                  textAlign: TextAlign.center,
                  style: blackTextFont.copyWith(fontSize: 20),
                ),
                SizedBox(height: 110),
                (isSigningUp)
                    ? SpinKitFadingCircle(
                        color: Color(0xFFF3E9D9D),
                        size: 45,
                      )
                    : SizedBox(
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF3E9D9D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isSigningUp = true;
                            });

                            SignInSignUpResult result =
                                await AuthServices.signUp(
                              widget.registrationData.email,
                              widget.registrationData.password,
                              widget.registrationData.name
                            );

                            if (result.user == null) {
                              setState(() {
                                isSigningUp = false;
                              });

                              Flushbar(
                                duration: Duration(milliseconds: 1500),
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Color(0xFFFF5C83),
                                message: result.message,
                              ).show(context);
                            }
                          },
                          child: Text(
                            "Create My Account",
                            style: whiteTextFont.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
