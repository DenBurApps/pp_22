import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/presentation/modules/pages/collections/views/collections_view.dart';
import 'package:pp_22_copy/presentation/modules/pages/home/view/home_view.dart';
import 'package:pp_22_copy/routes/routes.dart';

class PagesView extends StatefulWidget {
  const PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  var _currentModule = Module.home;

  final _bottomNavigationItems = [
    _BottomNavItem(
      icon: Assets.icons.home,
      module: Module.home,
    ),
    _BottomNavItem(
      icon: Assets.icons.collections,
      module: Module.collections,
    )
  ];

  void _selectModule(Module module) => setState(() => _currentModule = module);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const _CameraButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _bottomNavigationItems.length,
            (index) => _BottomNavItemWidget(
              onPressed: () =>
                  _selectModule(_bottomNavigationItems[index].module),
              isActive: _bottomNavigationItems[index].module == _currentModule,
              bottomNavItem: _bottomNavigationItems[index],
            ),
          ),
        ),
      ),
      body: switch (_currentModule) {
        Module.home => const HomeView(),
        Module.collections => const CollectionsView(),
      },
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteNames.camera),
      child: Container(
        alignment: Alignment.center,
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Assets.icons.camera.svg(fit: BoxFit.none),
      ),
    );
  }
}

class _BottomNavItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final _BottomNavItem bottomNavItem;
  const _BottomNavItemWidget({
    required this.onPressed,
    required this.isActive,
    required this.bottomNavItem,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: bottomNavItem.icon.svg(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
      ),
      onPressed: onPressed,
    );
  }
}

class _BottomNavItem {
  final SvgGenImage icon;
  final Module module;
  _BottomNavItem({
    required this.icon,
    required this.module,
  });
}

enum Module {
  home,
  collections,
}
