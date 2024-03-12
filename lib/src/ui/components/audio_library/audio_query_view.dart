

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:radioapps/src/ui/components/wide_elevated_button.dart';
import 'package:radioapps/src/ui/components/widget_extensions.dart';

class AudioQueryView extends StatefulWidget {
  const AudioQueryView({super.key});

  @override
  State<AudioQueryView> createState() => _AudioQueryViewState();
}

SizedBox cardSize = const SizedBox(
  width: 80,
  height: 30,
);


class _AudioQueryViewState extends State<AudioQueryView> {

  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = const [];
  SongModel? _selectedSong;
  List<SongModel> searchHistory = <SongModel>[];

  final searchController = SearchController();

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();

    checkPermission()
      .then((ok) {
        setState(() {
          _hasPermission = ok;
          if(_hasPermission) {
            runQuery();
          }
        });
      });
    

    searchController.addListener(_searchListener);
  }

  void _searchListener() {
    if( !searchController.isOpen ) {
      FocusScopeNode currentFocus = FocusScope.of(context);

      currentFocus.unfocus();

    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(_searchListener);
  }

  Future<bool> checkPermission() async {
    bool hasPermission = await _audioQuery.permissionsStatus();

    if( !hasPermission ) {
      hasPermission = await _audioQuery.permissionsRequest();
    }
    return hasPermission;
  }

  Future<void> runQuery() async {
    final songs = await _audioQuery.querySongs();
    setState(() {
      _songs = songs;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(localisations.requestSelectAudioTitle),
      ),
      body: _body(context),

    );
    
  }

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map(
      (SongModel song) => SongView(song: song),
    );
  }

  void _select() {
    Navigator.of(context).pop(_selectedSong);
  }


  void _handleSelection(SongModel selectedSong) {
    setState(() {
      _selectedSong = selectedSong;
      if (searchHistory.length >= 15) {
        searchHistory.removeLast();
      }
      searchHistory.removeWhere((element) => element.id == selectedSong.id);
      searchHistory.insert(0, selectedSong);
      FocusScopeNode currentFocus = FocusScope.of(context);

      currentFocus.unfocus();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     FocusScope.of(context).unfocus();
   });

    });
  }

  Widget _body(BuildContext context) {

    return Align(
      alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              SearchAnchor.bar(
                searchController: searchController,
                barHintText: localisations.requestSongSearchPrompt,
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  if (controller.text.isEmpty) {
                    if (searchHistory.isNotEmpty) {
                      return getHistoryList(controller);
                    }
                    return <Widget>[Center(child: Text('No search history.'))];
                  }
                  return getSuggestions(controller);
                },
              ),
              cardSize,
              if(_selectedSong != null) SongView(song: _selectedSong!),

              if(_selectedSong != null) WideElevatedButton(onTap: _select, 
                                  title: localisations.select)
            ],
          ),
        );
  }



  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text.toLowerCase();
    return _songs.where((song) {
      return (song.artist?.toLowerCase().contains(input) ?? false) || 
              song.displayName.toLowerCase().contains(input);
    }).map((e) => InkWell(
              onTap: () {
                _handleSelection(e);
                // FocusManager.instance.primaryFocus?.unfocus();
                controller.closeView(e.title);
                FocusScope.of(context).unfocus();

              } ,
              child: SongView(song: e))
      );

  }



}

class SongView extends StatelessWidget {
  final SongModel song;

  const SongView({super.key, required this.song});
  
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: artwork(),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.artist ?? "",
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,),
              Text(song.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
          ),
        ],
      ),
      )
      ],
    );

  }

  Widget artwork()  {
    return QueryArtworkWidget(
      id: song.id,
      type: ArtworkType.AUDIO,
    );
  }


  
}




// class SearchBarApp extends StatefulWidget {
//   const SearchBarApp({super.key});

//   @override
//   State<SearchBarApp> createState() => _SearchBarAppState();
// }

// class _SearchBarAppState extends State<SearchBarApp> {
//   Color? selectedColorSeed;
//   List<ColorLabel> searchHistory = <ColorLabel>[];

//   Iterable<Widget> getHistoryList(SearchController controller) {
//     return searchHistory.map(
//       (ColorLabel color) => ListTile(
//         leading: const Icon(Icons.history),
//         title: Text(color.label),
//         trailing: IconButton(
//           icon: const Icon(Icons.call_missed),
//           onPressed: () {
//             controller.text = color.label;
//             controller.selection = TextSelection.collapsed(offset: controller.text.length);
//           },
//         ),
//       ),
//     );
//   }

//   Iterable<Widget> getSuggestions(SearchController controller) {
//     final String input = controller.value.text;
//     return ColorLabel.values.where((ColorLabel color) => color.label.contains(input)).map(
//           (ColorLabel filteredColor) => ListTile(
//             leading: CircleAvatar(backgroundColor: filteredColor.color),
//             title: Text(filteredColor.label),
//             trailing: IconButton(
//               icon: const Icon(Icons.call_missed),
//               onPressed: () {
//                 controller.text = filteredColor.label;
//                 controller.selection = TextSelection.collapsed(offset: controller.text.length);
//               },
//             ),
//             onTap: () {
//               controller.closeView(filteredColor.label);
//               handleSelection(filteredColor);
//             },
//           ),
//         );
//   }

//   void handleSelection(ColorLabel selectedColor) {
//     setState(() {
//       selectedColorSeed = selectedColor.color;
//       if (searchHistory.length >= 5) {
//         searchHistory.removeLast();
//       }
//       searchHistory.insert(0, selectedColor);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData themeData = ThemeData(useMaterial3: true, colorSchemeSeed: selectedColorSeed);
//     final ColorScheme colors = themeData.colorScheme;

//     return MaterialApp(
//       theme: themeData,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Search Bar Sample')),
//         body: Align(
//           alignment: Alignment.topCenter,
//           child: Column(
//             children: <Widget>[
//               SearchAnchor.bar(
//                 barHintText: 'Search colors',
//                 suggestionsBuilder: (BuildContext context, SearchController controller) {
//                   if (controller.text.isEmpty) {
//                     if (searchHistory.isNotEmpty) {
//                       return getHistoryList(controller);
//                     }
//                     return <Widget>[Center(child: Text('No search history.', style: TextStyle(color: colors.outline)))];
//                   }
//                   return getSuggestions(controller);
//                 },
//               ),
//               cardSize,
//               Card(color: colors.primary, child: cardSize),
//               Card(color: colors.onPrimary, child: cardSize),
//               Card(color: colors.primaryContainer, child: cardSize),
//               Card(color: colors.onPrimaryContainer, child: cardSize),
//               Card(color: colors.secondary, child: cardSize),
//               Card(color: colors.onSecondary, child: cardSize),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// enum ColorLabel {
//   red('red', Colors.red),
//   orange('orange', Colors.orange),
//   yellow('yellow', Colors.yellow),
//   green('green', Colors.green),
//   blue('blue', Colors.blue),
//   indigo('indigo', Colors.indigo),
//   violet('violet', Color(0xFF8F00FF)),
//   purple('purple', Colors.purple),
//   pink('pink', Colors.pink),
//   silver('silver', Color(0xFF808080)),
//   gold('gold', Color(0xFFFFD700)),
//   beige('beige', Color(0xFFF5F5DC)),
//   brown('brown', Colors.brown),
//   grey('grey', Colors.grey),
//   black('black', Colors.black),
//   white('white', Colors.white);

//   const ColorLabel(this.label, this.color);
//   final String label;
//   final Color color;
// }
