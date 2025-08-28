import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_widget/styled_widget.dart';

import 'id_photo_create_logic.dart';

class IdPhotoCreatePage extends StatefulWidget {
  const IdPhotoCreatePage({super.key});

  @override
  State<IdPhotoCreatePage> createState() => _IdPhotoCreatePageState();
}

class _IdPhotoCreatePageState extends State<IdPhotoCreatePage> {
  final logic = Get.find<IdPhotoCreateLogic>();

  late CameraController _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  bool _isWeb = kIsWeb;

  int _currentCameraIndex = 1;

  bool _isRearCameraSelected = true;

  final double _PhotoWidth = 303;
  final double _PhotoHeight = 298;
  final double _horizontalPadding = 5.0;

  Future<bool> _checkPermissions() async {
    if (!_isWeb) {
      try {
        final cameraStatuses = await Permission.camera.request();

        final cameraGranted = cameraStatuses.isGranted;

        return cameraGranted;
      } catch (e) {
        print("Permission request exception: $e");
        return false;
      }
    }
    return true;
  }

  void _checkCameraAvailability() async {
    final status = await _checkPermissions();
    if (status) {
      _initializeCamera();
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: const Text('Camera permissions required'),
        content: const Text(
            'Please grant camera permission to get distance'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Setting'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkCameraAvailability();
  }

  Future<void> _initializeCamera() async {
    if (!_isWeb) {
      _cameras = await availableCameras();
      if (_cameras == null || (_cameras?.length ?? 0) < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No other cameras were found')));
        return;
      }
      _controller = CameraController(
          _cameras![_currentCameraIndex], ResolutionPreset.high,
          enableAudio: false);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              break;
            default:
              break;
          }
        }
      });
    }
  }

  Widget _buildFixedPhoto() {
    return Positioned(
      top: 90,
      left: _horizontalPadding,
      right: _horizontalPadding,
      child: Container(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/icon6.png',
          width: _PhotoWidth,
          height: _PhotoHeight,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_cameras == null || (_cameras?.length ?? 0) < 2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No other cameras were found')));
      return;
    }
    try {
      XFile image;
      if (_isWeb) {
        image = (await ImagePicker().pickImage(source: ImageSource.camera))!;
      } else {
        image = await _controller.takePicture();
      }
      setState(() => _capturedImage = image);
      _saveWithPhoto();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Widget _getPreview() {
    if (_isWeb) {
      return _capturedImage != null
          ? Image.network(_capturedImage!.path)
          : const Center(child: Text('Take a picture first'));
    } else {
      return _cameras?.isNotEmpty == true
          ? CameraPreview(_controller)
          : <Widget>[
              const Text(
                'No camera available',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ].toColumn(mainAxisAlignment: MainAxisAlignment.end);
    }
  }

  Future<img.Image> _fixImageOrientation(Uint8List bytes) async {
    img.Image image = img.decodeImage(bytes)!;
    if (bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      int offset = 2;
      while (offset < bytes.length - 1) {
        if (bytes[offset] != 0xFF) break;

        final marker = bytes[offset + 1];
        final length = (bytes[offset + 2] << 8) | bytes[offset + 3];

        if (marker == 0xE1) {
          final exifData = bytes.sublist(offset + 4, offset + 4 + length - 2);
          final orientation = _getOrientationFromExif(exifData);
          image = _applyOrientation(image, orientation);
          break;
        }

        offset += 2 + length;
      }
    }
    return image;
  }

  int _getOrientationFromExif(Uint8List exifData) {
    const orientationTag = 0x0112;
    try {
      if (exifData.length > 6) {
        final byteOrder = exifData[0] == 0x49 ? 'little' : 'big';
        final ifdOffset = _toInt32(exifData.sublist(4, 8), byteOrder);

        final entryCount =
            _toInt16(exifData.sublist(ifdOffset, ifdOffset + 2), byteOrder);

        for (int i = 0; i < entryCount; i++) {
          final entryOffset = ifdOffset + 2 + i * 12;
          final tag = _toInt16(
              exifData.sublist(entryOffset, entryOffset + 2), byteOrder);

          if (tag == orientationTag) {
            final format = _toInt16(
                exifData.sublist(entryOffset + 2, entryOffset + 4), byteOrder);
            final components = _toInt32(
                exifData.sublist(entryOffset + 4, entryOffset + 8), byteOrder);

            if (format == 3 && components == 1) {
              return _toInt16(
                  exifData.sublist(entryOffset + 8, entryOffset + 10),
                  byteOrder);
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing Exif: $e');
    }
    return 1;
  }

  img.Image _applyOrientation(img.Image image, int orientation) {
    switch (orientation) {
      case 2:
        return img.flipHorizontal(image);
      case 3:
        return img.copyRotate(image, angle: 180);
      case 4:
        return img.flipVertical(image);
      case 5:
        return img.copyRotate(img.flipHorizontal(image), angle: -90);
      case 6:
        return img.copyRotate(image, angle: -90);
      case 7:
        return img.copyRotate(img.flipHorizontal(image), angle: 90);
      case 8:
        return img.copyRotate(image, angle: 90);
      default:
        return image;
    }
  }

  int _toInt16(List<int> bytes, String byteOrder) {
    if (byteOrder == 'little') {
      return (bytes[1] << 8) | bytes[0];
    } else {
      return (bytes[0] << 8) | bytes[1];
    }
  }

  int _toInt32(List<int> bytes, String byteOrder) {
    if (byteOrder == 'little') {
      return (bytes[3] << 24) | (bytes[2] << 16) | (bytes[1] << 8) | bytes[0];
    } else {
      return (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
    }
  }

  Future<void> _saveWithPhoto() async {
    if (_capturedImage == null) return;
    try {
      final bytes = await _capturedImage!.readAsBytes();
      Get.toNamed('/id_photo_details', arguments: bytes);
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_cameras != null && (_cameras?.length ?? 0) >= 2) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: <Widget>[
        Expanded(
            child: SafeArea(
          child: Container(
            child: <Widget>[
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: _getPreview(),
              ),
              _buildFixedPhoto(),
            ].toStack(alignment: Alignment.center),
          ),
        )),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + 100,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: <Widget>[
            Image.asset(
              'assets/icon7.png',
              fit: BoxFit.cover,
            ).gestures(onTap: () {
              _takePicture();
            }),
          ].toRow(mainAxisAlignment: MainAxisAlignment.center),
        ).decorated(color: Colors.black)
      ].toColumn(),
    );
  }
}
