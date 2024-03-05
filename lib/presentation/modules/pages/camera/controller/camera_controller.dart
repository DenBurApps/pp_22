import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ICameraController extends ValueNotifier<CameraState> {
  ICameraController() : super(CameraState.initial()) {
    _init();
  }

  final _imagePicker = ImagePicker();

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);
      final cameraIsPermanentlyDenied =
          await Permission.camera.isPermanentlyDenied;
      if (cameraIsPermanentlyDenied) {
        await openAppSettings();
      } else {
        final cameras = await availableCameras();
        final camera = CameraController(
          cameras.first,
          ResolutionPreset.max,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await camera.initialize();

        value = value.copyWith(camera: camera);
      }
      value = value.copyWith(isLoading: false);
    } catch (e) {
      value = value.copyWith(isLoading: false);
    }
  }

  void flashAction({VoidCallback? onCameraNull}) {
    if (value.camera == null) {
      onCameraNull?.call();
      return;
    }
    if (value.isFlashActive) {
      disableFlash();
    } else {
      _enableFlash();
    }
  }

  Future<void> _enableFlash() async {
    await value.camera?.setFlashMode(FlashMode.torch);
    value = value.copyWith(isFlashActive: true);
  }

  Future<void> disableFlash() async {
    await value.camera?.setFlashMode(FlashMode.off);
    value = value.copyWith(isFlashActive: false);
  }

  Future<void> takePicture({VoidCallback? onCameraNull}) async {
    if (value.camera == null) {
      onCameraNull?.call();
      return;
    }
    final picture = await (await value.camera!.takePicture()).readAsBytes();
    if (value.obverse.isEmpty) {
      value = value.copyWith(obverse: picture);
    } else {
      value = value.copyWith(reverse: picture);
    }
  }

  void removeObverse() => value = value.copyWith(obverse: Uint8List(0));

  void removeReverse() => value = value.copyWith(reverse: Uint8List(0));

  Future<void> pickPhotos({
    VoidCallback? onCameraNull,
    VoidCallback? onError,
  }) async {
    if (value.camera == null) {
      onCameraNull?.call();
      return;
    }
    try {
      final photos = await _imagePicker.pickMultiImage();
      Uint8List? obverse;
      Uint8List? reverse;
      if (photos.length < 2) {
        final photo = await photos.first.readAsBytes();
        if (value.obverse.isEmpty) {
          obverse = photo;
        } else {
          reverse = photo;
        }
      } else {
        for (var i = 0; i < photos.length; i++) {
          if (i == 0) {
            obverse = await photos[i].readAsBytes();
            continue;
          }
          if (i == 1) {
            reverse = await photos[i].readAsBytes();
            break;
          }
        }
      }
      value = value.copyWith(obverse: obverse, reverse: reverse);
    } catch (e) {
      final request = await Permission.mediaLibrary.request();
      if (!request.isGranted) {
        await openAppSettings();
      }
      return;
    }
  }

  Future<void> setZoom(double zoom, {VoidCallback? onCameraNull}) async {
    if (value.camera == null) {
      onCameraNull?.call();
      return;
    }
    await value.camera!.setZoomLevel(zoom);
    value = value.copyWith(zoom: zoom);
  }

  void refresh() => _init();
}

class CameraState {
  final bool isPermissionGranted;
  final bool isLoading;
  final Uint8List obverse;
  final Uint8List reverse;
  final CameraController? camera;
  final bool isFlashActive;
  final double zoom;
  final String? errorMessage;

  const CameraState({
    this.camera,
    required this.isPermissionGranted,
    required this.isFlashActive,
    required this.isLoading,
    required this.obverse,
    required this.reverse,
    required this.zoom,
    this.errorMessage,
  });

  factory CameraState.initial() => CameraState(
        isPermissionGranted: false,
        camera: null,
        isFlashActive: false,
        isLoading: false,
        obverse: Uint8List(0),
        reverse: Uint8List(0),
        zoom: 1,
      );

  CameraState copyWith({
    bool? isFlashActive,
    CameraController? camera,
    bool? isLoading,
    Uint8List? obverse,
    Uint8List? reverse,
    double? zoom,
    bool? isPermissionGranted,
    String? errorMessage,
  }) =>
      CameraState(
        isFlashActive: isFlashActive ?? this.isFlashActive,
        camera: camera ?? this.camera,
        isLoading: isLoading ?? this.isLoading,
        obverse: obverse ?? this.obverse,
        reverse: reverse ?? this.reverse,
        zoom: zoom ?? this.zoom,
        isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
