import 'package:data_medix/providers/provider.dart';
import 'package:data_medix/screens/loginScreen.dart';
import 'package:data_medix/screens/profileInfoS.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountWidget extends ConsumerWidget {
  const AccountWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {

    Future<void> loginS () async {
      if (ref.watch(fetchF).username == null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                      return AlertDialog(
                       backgroundColor: ref.watch(colorF).colorsList["backgroundColor"],
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: ref.watch(colorF).colorsList["secondaryColor"]!,
                          width: 2,
                        ),
                        ),
                        
                        content: SizedBox(
                        width: MediaQuery.of(context).size.width/4, // Adjust this value as needed
                        child: SingleChildScrollView(
                          child: LoginScreen(
                            context2: context,
                          ),
                        ),
                        ),
                        actions: [
                        TextButton(
                          onPressed: () {
                          Navigator.of(context).pop();
                          },
                          child: Text(
                          "Close",
                          style: TextStyle(
                            color: ref
                              .watch(colorF)
                              .colorsList["praimrytext"]),
                          ),
                        ),
                        ],
                      );
                      },
                    );
                    } else {
                    final contextLocal = context;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: ref.watch(colorF).colorsList["secondaryColor"],
                      ),
                      ),
                    );
                    await ref.read(fetchF).signOut();
                    if (contextLocal.mounted) {
                      Navigator.pop(contextLocal);
                    }
                    }
                }
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 800;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ref.watch(fetchF).username ?? "Guest",
                style: GoogleFonts.roboto(
                  fontSize: isWeb ? width * 0.013 : width * 0.03,
                  fontWeight: FontWeight.w600,
                  color: ref.watch(colorF).colorsList["praimrytext"],
                ),
              ),  
                GestureDetector(
                onTap: () async {
                  loginS();
                },
                child: Text(
                  ref.watch(fetchF).username != null ? "sign-out" : "login",
                  style: GoogleFonts.roboto(
                  fontSize: isWeb ? width * 0.012 : width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: ref.watch(colorF).colorsList["praimrytext"],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 5),
            GestureDetector(
             onTap: () {
            if(ref.watch(fetchF).username == null){
            loginS();
               }else {
              showDialog(
              context: context,
              builder: (context) {
              return AlertDialog(
              backgroundColor: ref.watch(colorF).colorsList["backgroundColor"],
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: ref.watch(colorF).colorsList["secondaryColor"]!,
                width: 2,
              ),
              ),
              content: SizedBox(
              width: width/4,
              child: SingleChildScrollView(
                child: ProfileInfoScreen(),
              ),
              ),
              actions: [
              TextButton(
                onPressed: () {
                Navigator.of(context).pop();
                },
                child: Text(
                "Close",
                style: TextStyle(
                color: ref.watch(colorF).colorsList["praimrytext"]
                ),
                ),
              ),
              ],
              );
              },
            );
            }
            }, 
            child: CircleAvatar(radius: isWeb? 30:20,),
            ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
