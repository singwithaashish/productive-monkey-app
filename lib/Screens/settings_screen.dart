import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(child: Text("Dark Mode ")),
                  Checkbox(
                      value: boxList[6].get("DarkMode") ?? false,
                      onChanged: (v) {
                        boxList[6].put("DarkMode", v);
                      })
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return GridView.count(
                    crossAxisCount: 4,
                    children: List.generate(
                      9,
                      (index) => Container(
                        decoration: BoxDecoration(
                            border: index ==
                                    boxList[4]
                                        .values
                                        .cast<Misc>()
                                        .first
                                        .avatarIndex
                                ? Border.all(color: Colors.red, width: 10)
                                : null,
                            borderRadius: BorderRadius.circular(50)),
                        child: GestureDetector(
                          onTap: () {
                            Misc gl = boxList[4].values.cast<Misc>().first;
                            gl.avatarIndex = index;

                            boxList[4].putAt(0, gl);
                            setState(() {});
                            Provider.of<BLoC>(context, listen: false).jnl();
                          },
                          child: Image.asset(
                            avatars[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Consumer<BLoC>(builder: (context, bl, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        avatars[
                            boxList[4].values.cast<Misc>().first.avatarIndex],
                        fit: BoxFit.cover,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            boxList[4].values.cast<Misc>().first.username,
                            // style: aLittleBetter,
                          ),
                          IconButton(
                              onPressed: () {
                                Misc gl = boxList[4].values.cast<Misc>().first;
                                gl.username = "awesome user";
                                boxList[4].putAt(0, gl);

                                Provider.of<BLoC>(context, listen: false).jnl();
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),

                        // if awesome user, they haven't se;ected it
                        child: TextField(
                          controller: unTex,
                          onSubmitted: (v) {
                            v = v == "" ? "Awesome user" : v;
                            Misc gl = boxList[4].values.cast<Misc>().first;
                            gl.username = v;
                            boxList[4].putAt(0, gl);
                            unTex.clear();
                            Provider.of<BLoC>(context, listen: false).jnl();
                          },
                          decoration: InputDecoration(
                            labelText: "I am ...",
                            hintText: "Awesome user",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
