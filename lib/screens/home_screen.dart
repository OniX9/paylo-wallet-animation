import 'package:flutter/material.dart';
import 'package:paylo_wallet_animation/widgets/atm_card.dart';
import 'package:paylo_wallet_animation/custom_page_route.dart';
import 'package:paylo_wallet_animation/screens/atm_screen.dart';
import 'package:paylo_wallet_animation/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCardOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WalletContainer(
              onCardInOut: (isOut){
                isCardOut = isOut;
              },
            ),
            CustomButton(
              title: "Send Money",
              backgroundColor: Colors.blue.shade400,
              onPressed: () {
                if (isCardOut) Navigator.push(
                  context,
                  CustomPageRoute(child: AtmScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// ***SCREEN-ONLY WIDGETS***
// 1.
class WalletContainer extends StatefulWidget {
  final Function(bool) onCardInOut;
  const WalletContainer({
    super.key,
    required this.onCardInOut,
  });

  @override
  State<WalletContainer> createState() => _WalletContainerState();
}

class _WalletContainerState extends State<WalletContainer>
    with SingleTickerProviderStateMixin {
  bool isCardOut = false;
  bool isCardHidden = true;
  Animation<Alignment>? _animation;
  late AnimationController _controller;
  var _dragA1ignment = Alignment.center;

  onDragUpdate(DragUpdateDetails details) {
    double sum = _dragA1ignment.y + (details.delta.dy / 40);

    // print("ALIGNMENT: ${_dragA1ignment.y}");
    // print("DELTA CHANGE: ${details.delta.dy / 50}");
    // print("SUM: ${sum}\n\n");

    // Prevent backward and card hidden scrolls
    if (sum >= 0 || isCardHidden) return;

    setState(() {
      _dragA1ignment = Alignment(
        _dragA1ignment.x,
        _dragA1ignment.y + (details.delta.dy / 50),
      );
    });
  }

  void onDragEnd(DragEndDetails details) {
    _animation = Tween<Alignment>(
      begin: _dragA1ignment,
      end: Alignment.center,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
    switchCard(_animation);
  }

  void switchCard(details) {
    print("Percent: ${details.value.y}");
    if (details.value.y <= (isCardOut ? -2.3 : -2.25)) {
      // FINE TUNE TO YOUR NEEDS, TO SWITCH CARD OUTSIDE.
      setState(() {
        isCardOut = !isCardOut;
        widget.onCardInOut(isCardOut);
      });
    }
  }

  double? getCardPositioning() {
    if (isCardHidden) {
      return 220;
    } else if (isCardOut) {
      return 260;
    } else {
      return 300;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {
          _dragA1ignment = _animation!.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget firstCard = Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset(
            'assets/wallet.png',
            fit: BoxFit.fitHeight,
            width: double.infinity,
          ),
          InkWell(
            onTap: () {
              if (!isCardOut) setState(() => isCardHidden = !isCardHidden);
            },
            splashColor: Colors.transparent,
            child: Container(
              height: 30,
              width: 130,
              margin: EdgeInsets.only(right: 10, bottom: 25),
              // color: Colors.blue.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
    Widget secondCard = Transform.rotate(
      angle: -_dragA1ignment.y * 0.0225,
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: getCardPositioning(),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: GestureDetector(
          // onVerticalDragStart: (details) {
          //   print(details.localPosition.dy);
          //   setState(() {
          //     currentPosition = details.globalPosition.dy;
          //   });
          // },
          onVerticalDragUpdate: onDragUpdate,
          onVerticalDragEnd: onDragEnd,
          child: Align(
            alignment: _dragA1ignment,
            child: AtmCard(),
          ),
        ),
      ),
    );

    return Transform.scale(
      scale: 1 + _dragA1ignment.y * 0.01,
      child: Container(
        height: 360,
        width: 350,
        // color: Colors.blue[200],
        // padding: EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/walletBack.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: 280,
            ),
            !isCardOut ? secondCard : firstCard,
            !isCardOut ? firstCard : secondCard,
          ],
        ),
      ),
    );
  }
}
