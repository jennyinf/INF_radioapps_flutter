import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radioapps/src/ui/components/custom_tab_bar.dart';

/// trivial page monitoring cubit.

class PageState<T extends TabOption> {
  final T page;

  PageState({required this.page});
  
  bool isSelected( T option ) => page.iconData == option.iconData;

}


class PageStateCubit<T extends TabOption> extends Cubit<PageState<T>> {

  PageStateCubit({int index = -1, required PageState<T> initialState}) 
                          : super(initialState);

    /// change the page
    /// included because we need to navigate from one page to another (contact to settings)
    /// without going through the tab bar
    void setPage( T page ) => emit(PageState(page: page));

}

