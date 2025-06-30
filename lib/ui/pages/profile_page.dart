part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<PageBloc>().add(GoToMainPage());
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ListView(
                children: <Widget>[
                  BlocBuilder<UserBloc, UserState>(
                    builder: (_, userState) {
                      if (userState is UserLoaded) {
                        User user = userState.user;

                        return Column(
                          children: <Widget>[
                            // Logo di tengah atas
                            Container(
                              margin: EdgeInsets.only(top: 40, bottom: 20),
                              width: 180,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage("assets/logo2.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                              child: Text(
                                user.name ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                style: blackTextFont.copyWith(fontSize: 18),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                              margin: EdgeInsets.only(top: 8, bottom: 30),
                              child: Text(
                                user.email,
                                textAlign: TextAlign.center,
                                style: greyTextFont.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                          ],
                        );
                      } else
                        return SizedBox();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 16),
                        child: generateDashedDivider(
                          MediaQuery.of(context).size.width - 2 * defaultMargin,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          context.read<UserBloc>().add(SignOut());
                          AuthServices.signOut();
                        },
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(5, 3, 9, 3),
                                    color: accentColor2,
                                  ),
                                  Icon(
                                    MdiIcons.logout,
                                    color: mainColor,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Sign Out",
                              style: blackTextFont.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 16),
                        child: generateDashedDivider(
                          MediaQuery.of(context).size.width - 2 * defaultMargin,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 20, left: defaultMargin),
                child: GestureDetector(
                  onTap: () {
                    context.read<PageBloc>().add(GoToMainPage());
                  },
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
