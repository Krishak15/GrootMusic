import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class SeekBarData {
  final Duration position;
  final Duration duration;

  SeekBarData(this.position, this.duration);
}

class SeekBar1 extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar1(
      {super.key,
      required this.position,
      required this.duration,
      this.onChanged,
      this.onChangeEnd});

  @override
  State<SeekBar1> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar1> {
  double? _dragValue;
  //Format Helper Method
  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            //SeekBar
            Container(
              child: Expanded(
                  child: Slider(
                activeColor: Colors.white.withOpacity(0.8),
                thumbColor: Colors.deepPurple.shade200,
                inactiveColor: Colors.lightBlue.withOpacity(0.1),
                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(
                  _dragValue ?? widget.position.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble(),
                ),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null; //onDrag value change
                },
              )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, right: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(widget.position),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
              ),
              Text(
                _formatDuration(widget.duration),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
