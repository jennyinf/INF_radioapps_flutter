import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/bloc/page_state.dart';
import 'package:radioapps/src/ui/components/colored_safe_area.dart';

abstract class TabOption {
  final IconData iconData;

  const TabOption({required this.iconData});

  String title(BuildContext context);
  
}

///
/// CustomTabBar relies on a PageStateCubit to generate its state.
/// This is wrapped up in a provider within the containing class
/// here: RadioappPage.
/// A better way might be for the tab bar to create its own cubit and
/// add page to TabOption.
/// Pages can still access the page state cubit and change the page but the
/// holding page just needs to know about the tab bar
/// 
class CustomTabBar<TabItem extends TabOption> extends StatefulWidget {

  final List<TabItem> options;

  const CustomTabBar({super.key, required this.options});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState<TabItem>();
}


class _CustomTabBarState<TabItem extends TabOption> extends State<CustomTabBar<TabItem>> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final pageStateCubit = context.watch<PageStateCubit<TabItem>>();

    final Color background = themeData.colorScheme.background;
    final Color fill = themeData.colorScheme.primary;
    final Color shadow = Colors.black;
    final List<Color> gradient = [
      background,
      background,
      shadow,
      fill,
      fill,
    ];
    const double fillPercent = 85; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const double fillEnd = (100 - 90) / 100;
    final List<double> stops = [0.0, fillStop, fillEnd, fillEnd, 1.0];


    return ColoredSafeArea(
        child: Container( 
            height: 65, 
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                stops: stops,
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: Row( 
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _option(1,pageStateCubit),
                _option(3,pageStateCubit),
                _centralOption(pageStateCubit),
                _option(4,pageStateCubit),
                _option(2,pageStateCubit),
        
              ], 
            ),
      ),
    );
  }

  Widget _centralOption(PageStateCubit<TabItem> cubit) {
    final option = widget.options.firstOrNull;


    return option == null ? space : _option(0,cubit, outlined: true);
  }

  Widget get space {
    final option = widget.options[1];
    const color = Colors.transparent;
    return _icon(option, color);
  }

  Widget _option(int index, PageStateCubit<TabItem> cubit, {bool outlined = false}) {
    final option = widget.options.elementAtOrNull(index);

    if( option == null ) { return Expanded(child: space); }

    final state = cubit.state;

    final colorscheme = Theme.of(context).colorScheme;
    final color = state.isSelected(option) ? colorscheme.onPrimary : colorscheme.onPrimary.withAlpha(100);

    final button = outlined ? ElevatedButton(
              onPressed: () => cubit.setPage(option), 
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(side: BorderSide(width: 3.0, color: colorscheme.primary)),
                backgroundColor: colorscheme.primary,
                shadowColor: colorscheme.onBackground,
                elevation: state.isSelected(option) ? 10 : 5,
                side: BorderSide(width: 1.0, color: color),
                padding: const EdgeInsets.all(10),
              ),

              child: _icon(option, color)) : 
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: IconButton(onPressed: () => cubit.setPage(option), icon: _icon(option, color)));

    return Expanded(
      child: FittedBox(
                      fit: BoxFit.scaleDown,
        child: button));
  }

  Widget _icon( TabOption option, Color color) {
    return Column(
        
        children: [
          Icon(option.iconData, color: color,),
          Text(option.title(context), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),)
        ],
      );
  }
}
