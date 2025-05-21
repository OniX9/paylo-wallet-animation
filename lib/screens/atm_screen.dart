import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:paylo_wallet_animation/custom_page_route.dart';
import 'package:paylo_wallet_animation/screens/receipt_screen.dart';
import 'package:paylo_wallet_animation/widgets/atm_card.dart';
import 'package:paylo_wallet_animation/widgets/custom_button.dart';

class AtmScreen extends StatefulWidget {
  const AtmScreen({super.key});

  @override
  State<AtmScreen> createState() => _AtmScreenState();
}

class _AtmScreenState extends State<AtmScreen> with TickerProviderStateMixin {
  static const cardAnimationTime = 580;
  bool isCardInserted = false;
  bool isCardInserting = false;
  double cardPositionTop = 370;
  double cardPositionRight = 0;
  double cardWidth = 40;
  double cardImageWidth = 63;
  double receiptHeight = 0;
  int atmTextIndex = 0;

  late AnimationController cardIntoATMController;
  late AnimationController printReceiptController;
  final amountController = TextEditingController();

  Future<void> animateCard() async {
    if (!isCardInserting) {
      isCardInserting = true;
      // 1. Animate card from riqht to left
      setState(() => cardPositionRight = 108);
      // 2. Then bottom to top
      await Future.delayed(const Duration(milliseconds: cardAnimationTime + 50),
          () {
        setState(() {
          cardWidth = 22;
          cardPositionTop = 120;
        });
      });
      // 3. Put card into the machine
      await Future.delayed(
          const Duration(milliseconds: cardAnimationTime + 500), () {
        cardIntoATMController.forward();
        setState(() {});
      });

      // 4. Enter amount text
      animateAtmText(2, msDelay: 1000);
    }
  }

  /// Animate the text on the ATM.
  /// Search this AtmTextWidgets variable for the index-widget pair
  void animateAtmText(int index, {int msDelay = 0}) async {
    Future.delayed(Duration(milliseconds: msDelay), () {
      setState(() => atmTextIndex = index);
    });
  }

  printReceipt() async {
    // Print receipt
    await Future.delayed(const Duration(milliseconds: cardAnimationTime + 50),
            () {
          printReceiptController.forward();
        });
    // Go to page.
    await Future.delayed(const Duration(milliseconds: cardAnimationTime + 1000),
            () {
          Navigator.pushReplacement(
            context,
            CustomPageRoute(
              child: ReceiptScreen(),
            ),
          );
        });
  }

  initAnimationControllers() {
    //  Puts card into machine
    cardIntoATMController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    cardIntoATMController.addListener(() {
      setState(() {
        cardImageWidth =
            cardImageWidth - (cardImageWidth * cardIntoATMController.value);
        if (cardIntoATMController.value >= 0.9) {
          debugPrint("Card is inserted in machine");
          isCardInserting = false;
          isCardInserted = true;
        }
      });
    });

    // Prints out Recipt
    printReceiptController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    printReceiptController.addListener(() {
      setState(() {
        double maxReceiptHeight = 30;
        receiptHeight = maxReceiptHeight * printReceiptController.value;
      });
    });
  }

  @override
  void initState() {
    initAnimationControllers();
    animateAtmText(1, msDelay: 3000); // Insert card atm text
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> AtmTextWidgets = [
      AtmText(
        key: ValueKey(1),
        upperText: "Welcome to",
        lowerText: "Paylo",
      ),
      AtmText(
        key: ValueKey(2),
        upperText: "Please insert",
        lowerText: "Your Card",
        disableTextOut: true,
      ),
      SizedBox(
        key: ValueKey(3),
        height: 80,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Amount",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
              ),
            ),
            TextField(
              controller: amountController,
              onChanged: (amount) {},
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
              ),
              // autofocus: true,
              decoration: InputDecoration(
                prefix: Text(
                  "\$",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10),
              ),
            ),
          ],
        ),
      ),
      Center(
        key: ValueKey(4),
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.grey.shade400,
              Colors.grey.shade400,
              Colors.grey.shade800,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            amountController.text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Money',
            style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. ATM WIDGETs
            SizedBox(
              height: 440,
              width: 370,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/atm.png',
                    height: 440,
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: cardAnimationTime),
                    top: cardPositionTop,
                    right: cardPositionRight,
                    curve: Curves.easeOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: cardAnimationTime),
                      width: cardWidth,
                      alignment: Alignment.topCenter,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: AtmCard(
                          index: 1,
                          width: cardImageWidth,
                          height: 37.5,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 130,
                    child: SizedBox(
                      height: 100,
                      width: 140,
                      child: AtmTextWidgets[atmTextIndex],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: cardAnimationTime),
                    top: 83,
                    right: 108.5,
                    curve: Curves.easeOut,
                    child: Hero(
                      tag: "receipt",
                      child: Image.asset(
                        'assets/receipt.png',
                        height: receiptHeight,
                        width: 20,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(width: double.maxFinite),
                ],
              ),
            ),

            // 2. FIXED AMOUNT WIDGETs
            Container(
              height: 35,
              margin: EdgeInsets.only(top: 40, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildMoneyButton("\$ 100", onPressed: () {
                    setState(() => amountController.text = "100");
                  }),
                  buildMoneyButton("\$ 500", onPressed: () {
                    setState(() => amountController.text = "500");
                  }),
                  buildMoneyButton("\$ 1000", onPressed: () {
                    setState(() => amountController.text = "1000");
                  }),
                ],
              ),
            ),
            // 3. CONTINUE BUTTON
            !isCardInserted
                ? CustomButton(
                    title: "Insert Card",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      animateCard();
                    },
                  )
                : CustomButton(
                    title: "Add Money",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      processPayment();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void processPayment() async {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Please enter an amount")),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          // behavior: SnackBarBehavior.floating,
          // margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        ),
      );
      return;
    }
    animateAtmText(3);
    await Future.delayed(const Duration(milliseconds: 1000), () {
      printReceipt();
    });
  }

  TextButton buildMoneyButton(String text, {void Function()? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[300],
            size: 12,
          ),
        ],
      ),
    );
  }
}

// ***SCREEN-ONLY WIDGETs***
class AtmText extends StatefulWidget {
  final String upperText;
  final String lowerText;
  final bool disableTextOut;

  const AtmText({
    super.key,
    required this.upperText,
    required this.lowerText,
    this.disableTextOut = false,
  });

  @override
  State<AtmText> createState() => _AtmTextState();
}

class _AtmTextState extends State<AtmText> {
  double animatedValue = 1;
  int duration = 800;

  animateText() async {
    // 1. Animate text in
    await Future.delayed(Duration(milliseconds: 200), () {
      setState(() => animatedValue = 0);
    });
    // 2. Animate text out
    if (!widget.disableTextOut)
      await Future.delayed(Duration(milliseconds: duration + 1000), () {
        setState(() => animatedValue = 1);
      });
  }

  @override
  void initState() {
    animateText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 140,
      child: AnimatedOpacity(
        opacity: 1 - animatedValue,
        duration: Duration(milliseconds: (duration * 0.60).toInt()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.upperText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey[400],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: duration),
              height: 50 * animatedValue,
            ),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.grey.shade400,
                  Colors.grey.shade400,
                  Colors.grey.shade800,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Text(
                widget.lowerText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// await Future.delayed(const Duration(milliseconds: 550), () {
// final animationController = AnimationController(
// duration: const Duration(milliseconds: 1000), // Adjust duration as needed
// vsync: this,
// );
//
// final animation = Tween<double>(begin: cardWidth, end: 0).animate(
// CurvedAnimation(parent: animationController, curve: Curves.easeOut),
// );
//
// animationController.addListener(() {
// setState(() {
// cardWidth = animation.value;
// });
// });
//
// animationController.forward();
// });
