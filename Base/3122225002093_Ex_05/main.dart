import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawnShape> shapes = [];
  String selectedShape = 'Line';
  Color selectedColor = Colors.black;
  Offset? startPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing App"),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                shapes.clear();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedShape,
                onChanged: (value) {
                  setState(() {
                    selectedShape = value!;
                  });
                },
                items: ['Point', 'Line', 'Rectangle', 'Circle']
                    .map((shape) => DropdownMenuItem(
                  value: shape,
                  child: Text(shape),
                ))
                    .toList(),
              ),
              IconButton(
                icon: Icon(Icons.color_lens, color: selectedColor),
                onPressed: () async {
                  Color? pickedColor = await showDialog(
                    context: context,
                    builder: (context) => ColorPickerDialog(selectedColor),
                  );
                  if (pickedColor != null) {
                    setState(() {
                      selectedColor = pickedColor;
                    });
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  startPoint = details.localPosition;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  startPoint = null;
                });
              },
              onPanUpdate: (details) {
                if (startPoint == null) return;
                setState(() {
                  shapes.add(DrawnShape(
                    start: startPoint!,
                    end: details.localPosition,
                    color: selectedColor,
                    shape: selectedShape,
                  ));
                  startPoint = details.localPosition;
                });
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: ShapePainter(shapes),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawnShape {
  Offset start;
  Offset end;
  Color color;
  String shape;

  DrawnShape({required this.start, required this.end, required this.color, required this.shape});
}

class ShapePainter extends CustomPainter {
  List<DrawnShape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final paint = Paint()
        ..color = shape.color
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      switch (shape.shape) {
        case 'Point':
          canvas.drawCircle(shape.start, 2, paint);
          break;
        case 'Line':
          canvas.drawLine(shape.start, shape.end, paint);
          break;
        case 'Rectangle':
          canvas.drawRect(Rect.fromPoints(shape.start, shape.end), paint);
          break;
        case 'Circle':
          double radius = (shape.start - shape.end).distance;
          canvas.drawCircle(shape.start, radius, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ColorPickerDialog extends StatelessWidget {
  final Color selectedColor;

  const ColorPickerDialog(this.selectedColor, {super.key});

  @override
  Widget build(BuildContext context) {
    Color pickedColor = selectedColor;

    return AlertDialog(
      title: Text("Pick a color"),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: pickedColor,
          onColorChanged: (color) {
            pickedColor = color;
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text("Select"),
          onPressed: () {
            Navigator.pop(context, pickedColor);
          },
        ),
      ],
    );
  }
}