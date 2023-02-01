import 'package:flutter/material.dart';

class ControlLayer extends StatelessWidget {
  const ControlLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Align(
              alignment: Alignment.centerRight,
              child: ZoomControlButtonGroup()),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
          child: Align(
              alignment: Alignment.bottomRight,
              child: PositionControlButtonGroup()),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: ShotOnControlButtonGroup()),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child:
              Align(alignment: Alignment.topRight, child: OpenDrawerButton()),
        ),
      ],
    );
  }
}

class OpenDrawerButton extends StatelessWidget {
  const OpenDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.black,
      child: IconButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ShotOnControlButtonGroup extends StatelessWidget {
  const ShotOnControlButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.pause,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(Icons.stop, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}

class ZoomControlButtonGroup extends StatelessWidget {
  const ZoomControlButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 120,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.zoom_out,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PositionControlButtonGroup extends StatelessWidget {
  const PositionControlButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_up),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: Icon(
              Icons.keyboard_arrow_right,
            ),
          ),
        ),
      ]),
    );
  }
}
