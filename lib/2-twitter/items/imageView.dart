import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends StatefulWidget {
  final String imageName;
  ImageViewerPage(this.imageName);
  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  Offset beginningDragPosition = Offset.zero;
  Offset currentDragPosition = Offset.zero;
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  int photoViewAnimationDurationMilliSec = 0;
  double barsOpacity = 1.0;

  double get photoViewScale {
    return max(1.0 - currentDragPosition.distance * 0.001, 0.8);
  }

  double get photoViewOpacity {
    return max(1.0 - currentDragPosition.distance * 0.005, 0.1);
  }

  Matrix4 get photoViewTransform {
    final translationTransform = Matrix4.translationValues(
      currentDragPosition.dx,
      currentDragPosition.dy,
      0.0,
    );

    final scaleTransform = Matrix4.diagonal3Values(
      photoViewScale,
      photoViewScale,
      1.0,
    );

    return translationTransform * scaleTransform;
  }

  void onTapPhotoView() {
    setState(() {
      barsOpacity = (barsOpacity <= 0.0) ? 1.0 : 0.0;
    });
  }

  void onVerticalDragStart(DragStartDetails details) {
    setState(() {
      barsOpacity = 0.0;
      photoViewAnimationDurationMilliSec = 0;
    });
    beginningDragPosition = details.globalPosition;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      barsOpacity = (currentDragPosition.distance < 20.0) ? 1.0 : 0.0;
      currentDragPosition = Offset(
        details.globalPosition.dx - beginningDragPosition.dx,
        details.globalPosition.dy - beginningDragPosition.dy,
      );
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (currentDragPosition.distance < 100.0) {
      setState(() {
        photoViewAnimationDurationMilliSec = 200;
        currentDragPosition = Offset.zero;
        barsOpacity = 1.0;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildImage(context),
          _buildTopBar(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: onTapPhotoView,
      onVerticalDragStart: scaleState == PhotoViewScaleState.initial ? onVerticalDragStart : null,
      onVerticalDragUpdate: scaleState == PhotoViewScaleState.initial ? onVerticalDragUpdate : null,
      onVerticalDragEnd: scaleState == PhotoViewScaleState.initial ? onVerticalDragEnd : null,
      child: Container(
        color: Colors.black.withOpacity(photoViewOpacity),
        child: AnimatedContainer(
          duration: Duration(milliseconds: photoViewAnimationDurationMilliSec),
          transform: photoViewTransform,
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            imageProvider: NetworkImage(widget.imageName),
            minScale: PhotoViewComputedScale.contained,
            scaleStateChangedCallback: (state) {
              setState(() {
                scaleState = state;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: barsOpacity,
      child: Container(
        width: double.infinity,
        color: Colors.black26.withOpacity(0.2),
        height: 90,
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.clear_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ),
      ),
    );
  }
}
