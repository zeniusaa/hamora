part of 'pages.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage(this.user);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  String profilePath = '';
  bool isDataEdited = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<ThemeBloc>()
        .add(ChangeTheme(ThemeData().copyWith(primaryColor: accentColor2)));

    return WillPopScope(
      onWillPop: () async {
        context.read<PageBloc>().add(GoToProfilePage());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Text(
                        "Edit Your\nProfile",
                        textAlign: TextAlign.center,
                        style: blackTextFont.copyWith(fontSize: 20),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 22, bottom: 10),
                        width: 90,
                        height: 104,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 90,
                              height: 90,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: TextEditingController(text: widget.user.id),
                        style: whiteNumberFont.copyWith(color: accentColor3),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "User ID",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller:
                            TextEditingController(text: widget.user.email),
                        style: greyTextFont,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Email Address",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        style: blackTextFont,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Full Name",
                          hintText: "Full Name",
                        ),
                      ),
                      const SizedBox(height: 46),
                      if (isUpdating)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDataEdited
                                ? const Color(0xFF3E9D9D)
                                : const Color(0xFFE4E4E4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isDataEdited
                              ? () async {
                                  setState(() {
                                    isUpdating = true;
                                  });
                                  context
                                      .read<PageBloc>()
                                      .add(GoToProfilePage());
                                }
                              : null,
                          child: Text(
                            "Update My Profile",
                            style: whiteTextFont.copyWith(fontSize: 16),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: defaultMargin),
                child: GestureDetector(
                  onTap: () {
                    context.read<PageBloc>().add(GoToProfilePage());
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFlushbar(BuildContext context, String message) {
    Flushbar(
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color(0xFFFF5C83),
      message: message,
    ).show(context);
  }
}
