import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';


import '../../domain/models/puzzle_image.dart';
import '../../domain/repositories/images_repository.dart';

const puzzleOptions = <PuzzleImage>[
  PuzzleImage(
    name: 'Numeric',
    assetPath: 'assets/images/numeric-puzzle.png',
    soundPath: '',
  ),
  PuzzleImage(
    name: 'Pikachu',
    assetPath: 'assets/animals/xx.jpeg',
    soundPath: 'assets/sounds/pikachu.mp3',
  ),
  PuzzleImage(
    name: 'Charmander',
    assetPath: 'assets/animals/Charmander.png',
    soundPath: 'assets/sounds/charmander.mp3',
  ),
  PuzzleImage(
    name: 'Bulbasaur',
    assetPath: 'assets/animals/Bulbasaur.png',
    soundPath: 'assets/sounds/bulbasaur.mp3',
  ),
  PuzzleImage(
    name: 'Pikachu2',
    assetPath: 'assets/animals/Pika.png',
    soundPath: 'assets/sounds/angry_pikachu.mp3',
  ),
  PuzzleImage(
    name: 'Snorlax',
    assetPath: 'assets/animals/Snorlax.png',
    soundPath: 'assets/sounds/snorlax.mp3',
  ),
  PuzzleImage(
    name: 'Eeve',
    assetPath: 'assets/animals/Eeve.png',
    soundPath: 'assets/sounds/eeve.mp3',
  ),
  PuzzleImage(
    name: 'Blastoise',
    assetPath: 'assets/animals/Blastoise.png',
    soundPath: 'assets/sounds/blastoise.mp3',
  ),
  PuzzleImage(
    name: 'Squirtle',
    assetPath: 'assets/animals/Squirtle.png',
    soundPath: 'assets/sounds/squirtle.mp3',
  ),
  PuzzleImage(
    name: 'Lucario',
    assetPath: 'assets/animals/Lucario.png',
    soundPath: 'assets/sounds/lucario.mp3',
  ),
  PuzzleImage(
    name: 'Gyarados',
    assetPath: 'assets/animals/Gyarados.png',
    soundPath: 'assets/sounds/gyarados.mp3',
  ),
];

Future<Image> decodeAsset(ByteData bytes) async {
  return decodeImage(
    bytes.buffer.asUint8List(),
  )!;
}

class SPlitData {
  final Image image;
  final int crossAxisCount;

  SPlitData(this.image, this.crossAxisCount);
}

Future<List<Uint8List>> splitImage(SPlitData data) {
  final image = data.image;
  final crossAxisCount = data.crossAxisCount;
  final int length = (image.width / crossAxisCount).round();
  List<Uint8List> pieceList = [];

  for (int y = 0; y < crossAxisCount; y++) {
    for (int x = 0; x < crossAxisCount; x++) {
      pieceList.add(
        Uint8List.fromList(
          encodePng(
            copyCrop(
              image,
              x * length,
              y * length,
              length,
              length,
            ),
          ),
        ),
      );
    }
  }
  return Future.value(pieceList);
}

class ImagesRepositoryImpl implements ImagesRepository {
  Map<String, Image> cache = {};

  @override
  Future<List<Uint8List>> split(String asset, int crossAxisCount) async {
    late Image image;
    if (cache.containsKey(asset)) {
      image = cache[asset]!;
    } else {
      final bytes = await rootBundle.load(asset);

      /// use compute because theimage package is a pure dart package
      /// so to avoid bad ui performance we do this task in a different
      /// isolate
      image = await compute(decodeAsset, bytes);

      final width = math.min(image.width, image.height);

      /// convert to square
      image = copyResizeCropSquare(image, width);
      cache[asset] = image;
    }

    final pieces = await compute(
      splitImage,
      SPlitData(image, crossAxisCount),
    );

    return pieces;
  }
}
