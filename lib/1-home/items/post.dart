import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
// import 'package:video_player/video_player.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Manager Demo',
      home: Material(
        child: Center(
          child: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                final permitted = await PhotoManager.requestPermission();
                if (!permitted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Gallery()),
                );
              },
              child: Text('Open Gallery'),
            );
          }),
        ),
      ),
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(asset: assets[index]);
        },
      ),
    );
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );
    setState(() => assets = recentAssets);
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    required this.asset,
  });

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      // future: asset.thumbData,
      builder: (_, snapshot) {
        print(snapshot.data);
        final bytes = snapshot.data;
        if (bytes == null) return CircularProgressIndicator();
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (asset.type == AssetType.image) {
                    return Container();
                    // return ImageScreen(imageFile: asset.file,);
                    // エラーメッセージ
                    // The argument type 'Future<File?>' can't be assigned to the parameter type 'Future<File>'.
                  } else {
                    return Container();
                  }
                },
              ),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// return VideoScreen(videoFile: asset.file);
class ImageScreen extends StatelessWidget {
  const ImageScreen({
    required this.imageFile,
  });

  final Future<File> imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: FutureBuilder<File>(
        future: imageFile,
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          return Image.file(file);
        },
      ),
    );
  }
}

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({
//     Key key,
//     @required this.videoFile,
//   }) : super(key: key);

//   final Future<File> videoFile;

//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   VideoPlayerController _controller;
//   bool initialized = false;

//   @override
//   void initState() {
//     _initVideo();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   _initVideo() async {
//     final video = await widget.videoFile;
//     _controller = VideoPlayerController.file(video)
//       ..setLooping(true)
//       ..initialize().then((_) => setState(() => initialized = true));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: initialized
//           ? Scaffold(
//               body: Center(
//                 child: AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 ),
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {
//                   setState(() {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       _controller.play();
//                     }
//                   });
//                 },
//                 child: Icon(
//                   _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               ),
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }