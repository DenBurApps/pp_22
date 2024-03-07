import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/presentation/modules/pages/collections/views/collections_view.dart';
import 'package:pp_22/presentation/modules/pages/home/view/home_view.dart';
import 'package:pp_22/presentation/modules/settings_view.dart';
import 'package:pp_22/routes/routes.dart';

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
    ),
    _BottomNavItem(
      icon: Assets.icons.settings,
      module: Module.settins,
    )
  ];

  void _selectModule(Module module) => setState(() => _currentModule = module);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20 ,bottom: 20),
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => _BottomButton(
                          onPressed: () =>
                              _selectModule(_bottomNavigationItems[index].module),
                          bottomNavItem: _bottomNavigationItems[index],
                          isActive: _bottomNavigationItems[index].module ==
                              _currentModule,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30), 
                _ScanButton(),
              ],
            ),
          ),
        ),
      ),
      body: switch (_currentModule) {
        Module.home => const HomeView(),
        Module.collections => const CollectionsView(),
        Module.settins => const SettingsView(),
      },
    );
  }
}

class _BottomButton extends StatelessWidget {
  final _BottomNavItem bottomNavItem;
  final bool isActive;
  final VoidCallback onPressed;
  const _BottomButton({
    required this.bottomNavItem,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isActive ? 1 : 0,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isActive ? Theme.of(context).colorScheme.onPrimary : null,
              borderRadius: BorderRadius.circular(40)),
          child: !isActive
              ? bottomNavItem.icon.svg()
              : Row(
                  children: [
                    bottomNavItem.icon.svg(
                      color: Theme.of(context).colorScheme.primary,
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      bottomNavItem.module.label,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).pushNamed(RouteNames.camera),
      child: Container(
        alignment: Alignment.center,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Assets.icons.scan.svg(fit: BoxFit.none),
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
  home(label: 'Home'),
  collections(label: 'Collections'),
  settins(label: 'Settings');

  final String label;

  const Module({required this.label});
}
