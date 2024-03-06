import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/presentation/components/bottom_pop_up.dart';
import 'package:pp_22/presentation/components/loading_animation.dart';
import 'package:pp_22/presentation/modules/pages/camera/controller/camera_controller.dart';
import 'package:pp_22/routes/routes.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final _cameraController = ICameraController();

  void _flashAction() => _cameraController.flashAction();

  void _setZoom(double zoom) => _cameraController.setZoom(zoom);

  Future<void> _takePicture() async {
    if (_cameraController.value.obverse.isNotEmpty &&
        _cameraController.value.reverse.isNotEmpty) {
      _showBeforeSearchingDialog();
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (context) => const LoadingAnimation(
        alignment: Alignment(0, -0.35),
      ),
    );
    await _cameraController.takePicture();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (_cameraController.value.obverse.isNotEmpty &&
        _cameraController.value.reverse.isNotEmpty) {
      _showBeforeSearchingDialog();
    }
  }

  Future<void> _pickPhotos() async {
    if (_cameraController.value.obverse.isNotEmpty &&
        _cameraController.value.reverse.isNotEmpty) {
      _showBeforeSearchingDialog();
      return;
    }
    showCupertinoDialog(
      context: context,
      builder: (context) => const LoadingAnimation(),
    );
    await _cameraController.pickPhotos(
      onError: Navigator.of(context).pop,
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (_cameraController.value.obverse.isNotEmpty &&
        _cameraController.value.reverse.isNotEmpty) {
      _showBeforeSearchingDialog();
    }
  }

  void _showZoomPicker() {
    if (_cameraController.value.camera == null) {
      return;
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => _ZoomPicker(
          onSelectZoom: (zoom) => _setZoom(zoom + 1),
          zoom: _cameraController.value.zoom,
        ),
      );
    }
  }

  void _showBeforeSearchingDialog() => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            'You have selected both images, shall we continue the search?',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                if (_cameraController.value.isFlashActive) {
                  _cameraController.disableFlash();
                }
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.cameraSearch,
                  (route) => route.settings.name == RouteNames.pages,
                  arguments: CameraSearchViewArguments(
                    obverse: _cameraController.value.obverse,
                    reverse: _cameraController.value.reverse,
                  ),
                );
              },
              child: Text(
                'YES',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: Navigator.of(context).pop,
              child: Text(
                'NO',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        ),
      );

  void _infoAction() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BottomPopUp(
          title: 'Snap Tips',
          body: [
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'To scan a coin: ',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '1. point it at the center of the screen and the camera will automatically take a picture.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
              SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '2. scan both sides of the coin, the front and back of the coin.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 20),
            Assets.images.rightExample.image(),
            const SizedBox(height: 20),
            Assets.images.wrongExample.image(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        bottomSheet: ValueListenableBuilder(
          valueListenable: _cameraController,
          builder: (context, value, child) => _BottomPanel(
            mainAction: _takePicture,
            photosAction: _pickPhotos,
            zoom: value.zoom,
            zoomAction: _showZoomPicker,
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AppBarButton(
                  icon: Assets.icons.close,
                  onPressed: Navigator.of(context).pop,
                ),
                _AppBarButton(
                  icon: Assets.icons.info,
                  onPressed: _infoAction,
                ),
                ValueListenableBuilder(
                  valueListenable: _cameraController,
                  builder: (context, value, child) => _AppBarButton(
                    icon: value.isFlashActive
                        ? Assets.icons.flashOff
                        : Assets.icons.flashOn,
                    onPressed: _flashAction,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 130),
          child: ValueListenableBuilder(
            valueListenable: _cameraController,
            builder: (context, value, child) {
              if (value.isLoading) {
                return const LoadingAnimation();
              } else if (value.camera == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Camera not available',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                      ),
                      CupertinoButton(
                        onPressed: _cameraController.refresh,
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(value.camera!),
                    const _CameraOverlay(),
                    const _CoinArea(),
                    _TopCameraColumn(
                      obverse: value.obverse,
                      reverse: value.reverse,
                      removeObverse: _cameraController.removeObverse,
                      removeReverse: _cameraController.removeReverse,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  final VoidCallback? photosAction;
  final VoidCallback? mainAction;
  final double zoom;
  final VoidCallback? zoomAction;
  const _BottomPanel({
    this.photosAction,
    this.mainAction,
    required this.zoom,
    this.zoomAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: photosAction,
            child: Assets.icons.photos.svg(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: mainAction,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Theme.of(context).colorScheme.surface),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          _Zoom(
            zoom: zoom,
            onPressed: zoomAction,
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final SvgGenImage icon;
  final VoidCallback? onPressed;
  const _AppBarButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: icon.svg(color: Theme.of(context).colorScheme.surface),
    );
  }
}

class _CameraOverlay extends StatelessWidget {
  const _CameraOverlay();

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.black54,
        BlendMode.srcOut,
      ),
      child: Container(
        alignment: const Alignment(0, -0.3),
        decoration: const BoxDecoration(
          color: Colors.black,
          backgroundBlendMode: BlendMode.dstOut,
        ),
        child: Container(
          height: 293,
          width: 293,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class _TopCameraColumn extends StatelessWidget {
  final Uint8List obverse;
  final Uint8List reverse;
  final VoidCallback? removeObverse;
  final VoidCallback? removeReverse;
  const _TopCameraColumn({
    required this.obverse,
    required this.reverse,
    this.removeObverse,
    this.removeReverse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CoinPhotoStep(
              label: 'Obverse',
              isActive: obverse.isEmpty,
              imageName: 'obverse',
              picture: obverse,
              remove: removeObverse,
            ),
            const SizedBox(width: 20),
            _CoinPhotoStep(
              label: 'Reverse',
              isActive: obverse.isNotEmpty && reverse.isEmpty,
              imageName: 'reverse',
              picture: reverse,
              remove: removeReverse,
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class _CoinArea extends StatelessWidget {
  const _CoinArea();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.3),
      child: Container(
        alignment: Alignment.center,
        width: 293,
        height: 293,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 5,
          ),
        ),
        child: Assets.icons.add.svg(
          color: Theme.of(context).colorScheme.surface,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}

class _CoinPhotoStep extends StatelessWidget {
  final String label;
  final bool isActive;
  final String imageName;
  final Uint8List picture;
  final VoidCallback? remove;

  const _CoinPhotoStep({
    super.key,
    required this.label,
    required this.isActive,
    required this.imageName,
    required this.picture,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 65,
      child: Stack(
        children: [
          if (picture.isNotEmpty) ...[
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 60,
                height: 60,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.memory(
                  picture,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame,
                          wasSynchronouslyLoaded) =>
                      frame != null
                          ? child
                          : Center(
                              child: CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: remove,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 10,
                  ),
                ),
              ),
            )
          ] else
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 60,
                decoration: DottedDecoration(
                  shape: Shape.circle,
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Zoom extends StatelessWidget {
  final double zoom;
  final VoidCallback? onPressed;
  const _Zoom({
    required this.zoom,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
        ),
        height: 40,
        width: 40,
        child: FittedBox(
          child: Text(
            '${zoom.toInt()}×',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}

class _ZoomPicker extends StatelessWidget {
  final void Function(int)? onSelectZoom;
  final double zoom;
  const _ZoomPicker({this.onSelectZoom, required this.zoom});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: CupertinoPicker.builder(
        backgroundColor: Colors.white,
        scrollController:
            FixedExtentScrollController(initialItem: zoom.toInt() - 1),
        itemExtent: 32,
        onSelectedItemChanged: onSelectZoom,
        itemBuilder: (context, index) => Text('${index + 1}'),
        childCount: 4,
      ),
    );
  }
}
