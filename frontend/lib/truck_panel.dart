import 'package:flutter/material.dart';
import 'utils/Utils.dart';
import 'display_type_header.dart';
import 'filter_tab.dart';
import 'truck_list_view.dart';
import 'truck_map_view.dart';
import 'truck_model.dart';
import 'truck_service.dart';

class _PanelData {
  TruckPanelState         _panelState;
  bool                    _showHeaderBack;
  bool                    _showTabBar;
}


class TruckPanel extends StatefulWidget {
	_PanelData _data = _PanelData(); 

	@override
	TruckPanelState createState() {
		return _data._panelState = TruckPanelState();
	}
}

class TruckPanelState extends State<TruckPanel> {
	ListMapDisplayType _displayType = ListMapDisplayType.List;
	List<TruckModel> _trucks = []; 
	Future<List<TruckModel>> _taskLoading;
	List<Filter> _truckFilters; 
	List<String> _filterTagValues;
	List<String> _filterWorkTimeValues;

	@override 
	void initState() {
		_initFilters();
		_taskLoading = getFoodTruckList();
		_taskLoading.then((List<TruckModel> trucks) {
				_refresh(() {
					_trucks = trucks;
					_taskLoading = null; 
				});
		});
		super.initState();

	}

	void _initFilters() {
		_truckFilters = [new Filter(type: FilterType.Tag), new Filter(type:FilterType.WorkTime)];
		_filterTagValues = ["All Tags"];
		for(Tag tag in Tag.values) {
			_filterTagValues.add(TagHelper.tagToString(tag));
		}
		_filterWorkTimeValues = ["Is Open Now", "All"];
	}

	void _selectDisplayType (ListMapDisplayType displayType) {
		if (_displayType != displayType) {
			_refresh(() {
				_displayType = displayType;
		        _enableMap(_displayType == ListMapDisplayType.Map);
			});    
	    }
	}

	void _refresh(Function fn){
	    this.setState(fn);
	 }

	void _enableMap(bool enable) {
	    
  	}

	Widget _buildListView() {
		if(_taskLoading != null) {
			return _buildLoadingView(); 
		}
		return Visibility(
		    visible: (_displayType == ListMapDisplayType.List),
		    child: Container(
		        color: UiColors.illinoisWhiteBackground, child: FoodTruckListView(_trucks)));
	}

	Widget _buildMapView() {
		if(_taskLoading != null) {
			return _buildLoadingView(); 
		}
		return Container(
				child: FoodTruckMapView(Location(lat: 40.1129, lng: -88.2262), _trucks)
		);
	}

	Widget _buildLoadingView() {
		return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            ],
          );
	}

	List<Widget> _buildFilterWidgets() {
		List<Widget> filterTypeWidgets = List<Widget>();

	    for (int i = 0; i < _truckFilters.length; i++) {
	      Filter selectedFilter = _truckFilters[i];
	      List<String> filterValues = _getFilterValuesByType(selectedFilter.type);
	      int filterValueIndex = selectedFilter.firstSelectedIndex;
	      String filterHeaderLabel = filterValues[filterValueIndex];
	      filterTypeWidgets.add(FilterSelectorWidget(
	        label: filterHeaderLabel,
	        active: selectedFilter.active,
	        visible: true,
	        onTap: (){
	          return _onFilterTypeClicked(selectedFilter);},
	      ));
	    }
	    return filterTypeWidgets;
	}

	List<String> _getFilterValuesByType(FilterType filterType) {
		switch(filterType) {
			case FilterType.Tag:
				return _filterTagValues;
			case FilterType.WorkTime:
				return _filterWorkTimeValues;
			default:
				return null; 
		}
	}

	void _onFilterTypeClicked(Filter selectedFilter) {
	    _refresh(() {
	        for (Filter filter in _truckFilters) {
	          if (filter != selectedFilter) {
	            filter.active = false;
	          }
	        }
		    selectedFilter.active = !selectedFilter.active;
	    });
	  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Food Truck Tracker"),
			), // appBar 
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					ExploreDisplayTypeHeader(
		              displayType: _displayType,
		              searchVisible: false, // TODO: set as true 
		              onTapList: () => _selectDisplayType(ListMapDisplayType.List),
		              onTapMap: () => _selectDisplayType(ListMapDisplayType.Map),
		            ), // ExploreDisplayTypeHeader
					Expanded(
		                child: Stack(
		                  	children: <Widget>[
			                    Column(
			                      crossAxisAlignment: CrossAxisAlignment.start,
			                      children: <Widget>[
			                      SingleChildScrollView(
			                          scrollDirection: Axis.horizontal,
			                          child: Padding(
			                              padding: EdgeInsets.only(
			                                  left: 12, right: 12, bottom: 12),
			                              child: Row(
			                                children: _buildFilterWidgets(),
			                              )),
			                        ),
			                      		Expanded(
			                            child: Container(
			                          	color: UiColors.illinoisWhiteBackground,
			                          	child: Center(
			                            child: Stack(
			                              children: <Widget>[
			                              	_buildMapView(), 
			                                _buildListView(),
			                              ],
			                            ), // Stack 
			                          	), // Center 
			                        	) // Container 
			                        	) // Expanded
			                        ],
			                    ),  // Column
			                   // _buildFilterValueContainers();
		                  	],
		                ), // Stack 
		        	), // Expanded 
				], 
			), // Column 
		);
	}
}


enum FilterType{Tag, WorkTime}

class Filter{
  FilterType type;
  Set<int> selectedIndexes; 
  bool active; 

  Filter(
      {@required this.type, this.selectedIndexes = const {0}, this.active=false});

  int get firstSelectedIndex {
    if (selectedIndexes == null || selectedIndexes.isEmpty) {
      return -1;
    }
    return selectedIndexes.first;
  }
}