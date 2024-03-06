import 'package:flutter/material.dart';
import 'package:radioapps/src/ui/components/colored_safe_area.dart';

class TabOption {
  final String title;
  final IconData iconData;

  const TabOption({required this.title, required this.iconData});

  
}

class CustomTabBar<TabItem extends TabOption> extends StatefulWidget {

  final List<TabItem> options;
  final Function(TabItem) onChanged;

  const CustomTabBar({super.key, required this.options, required this.onChanged});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState<TabItem>();
}


class _CustomTabBarState<TabItem extends TabOption> extends State<CustomTabBar<TabItem>> {

  int _selectedIndex = 0;



  // Widget _option(int index) {
  void _selected( int index) {
    setState(() {
      _selectedIndex = index;

      final option = widget.options[index];
      widget.onChanged(option); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

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
                _option(1),
                _option(3),
                _centralOption,
                _option(4),
                _option(2),
        
              ], 
            ),
      ),
    );
  }

  Widget get _centralOption {
    final option = widget.options.firstOrNull;


    return option == null ? space : _option(0,outlined: true);
  }

  Widget get space {
    final option = widget.options[1];
    const color = Colors.transparent;
    return _icon(option, color);
  }

  Widget _option(int index, {bool outlined = false}) {
    final option = widget.options.elementAtOrNull(index);

    if( option == null ) { return Expanded(child: space); }

    final colorscheme = Theme.of(context).colorScheme;
    final color = index == _selectedIndex ? colorscheme.onPrimary : colorscheme.onPrimary.withAlpha(100);

    final button = outlined ? ElevatedButton(
              onPressed: () => _selected(index), 
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(side: BorderSide(width: 3.0, color: colorscheme.primary)),
                backgroundColor: colorscheme.primary,
                shadowColor: colorscheme.onBackground,
                elevation: _selectedIndex == index ? 10 : 5,
                side: BorderSide(width: 1.0, color: color),
                padding: const EdgeInsets.all(10),
              ),

              child: _icon(option, color)) : 
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: IconButton(onPressed: () => _selected(index), icon: _icon(option, color)));

    return Expanded(
      child: button);
  }

  Widget _icon( TabOption option, Color color) {
    return Column(
        
        children: [
          Icon(option.iconData, color: color,),
          Text(option.title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),)
        ],
      );
  }
}
