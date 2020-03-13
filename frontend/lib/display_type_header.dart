/*
 * Copyright (c) 2019 Illinois. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'display_type_tab.dart';
import 'utils/Utils.dart';

enum ListMapDisplayType { List, Map }

class ExploreDisplayTypeHeader extends StatelessWidget {
  final ListMapDisplayType displayType;
  final GestureTapCallback onTapList;
  final GestureTapCallback onTapMap;
  final bool searchVisible;

  ExploreDisplayTypeHeader({this.displayType, this.onTapList, this.onTapMap, this.searchVisible = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        color: UiColors.darkBlueGrey,
        child: Padding(
            padding: EdgeInsets.only(left: 18),
            child: Column(children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  ExploreViewTypeTab(
                    label: 'List',
                    hint: '',
                    iconResource: 'images/icon-list-view.png',
                    selected: (displayType == ListMapDisplayType.List),
                    onTap: onTapList,
                  ),
                  Container(
                    width: 10,
                  ),
                  ExploreViewTypeTab(
                    label: 'Map',
                    hint: '',
                    iconResource: 'images/icon-map-view.png',
                    selected: (displayType == ListMapDisplayType.Map),
                    onTap: onTapMap,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Visibility(
                    visible: searchVisible,
                    child: Semantics(
                      button: true, excludeSemantics: true,
                      label: 'Search',child:
                    IconButton(
                      icon: Image.asset('images/icon-search.png'),
                      onPressed: () { /* TODO */ 
                      },
                    ),
                  ))
                ],
              )),
            ])));
  }
}
