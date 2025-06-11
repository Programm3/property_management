import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/services/api_service.dart';
import 'package:property_manage/src/widgets/property_card_widget.dart';
import 'package:provider/provider.dart';

class HomeSearchPage extends StatefulWidget {
  final String? selectedProvince;
  final String? selectedPropertyType;
  final String? selectedRentType;
  final List<dynamic>? properties;

  const HomeSearchPage({
    super.key,
    this.selectedProvince,
    this.selectedPropertyType,
    this.selectedRentType,
    this.properties,
  });

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  bool _isLoading = false;
  String? _error;
  List<dynamic> _searchResults = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: '');
    _searchFocusNode = FocusNode();

    if (widget.properties != null && widget.properties!.isNotEmpty) {
      _searchResults = widget.properties!;
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _searchFocusNode.requestFocus();
    //   if (widget.initialQuery.isNotEmpty) {
    //     _searchProperties(widget.initialQuery);
    //   }
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchProperties(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = widget.properties ?? [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final queryParams = {
        'search': searchTerm,
        if (widget.selectedProvince != null)
          'province': widget.selectedProvince!,
        if (widget.selectedPropertyType != null)
          'property_type': widget.selectedPropertyType!,
        if (widget.selectedRentType != null)
          'rent_type': widget.selectedRentType!,
      };

      final response = await apiService.get('posts', queryParams: queryParams);

      if (mounted) {
        setState(() {
          _searchResults = response['results'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffdcf5ea), Color(0xfff5f5f5)],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          automaticallyImplyLeading: false,
          leading: null,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      _searchProperties(value);
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(
                        context,
                      ).translate('searchLocationOrProject'),
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      prefixIcon: Container(
                        width: 13,
                        height: 14,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Image.asset(
                            'assets/images/search.png',
                            width: 13,
                            height: 14,
                            fit: BoxFit.cover,
                          ),
                          iconSize: 14,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _searchProperties(_searchController.text);
                          },
                        ),
                      ),
                      suffixIcon:
                          _searchController.text.isNotEmpty
                              ? IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/cross_gray.svg',
                                  width: 14,
                                  height: 14,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _hasSearched = false;
                                  setState(() {
                                    _searchResults = widget.properties ?? [];
                                  });
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap:
                      () => {
                        context.pop({'showFilter': true}),
                      },
                  child: SvgPicture.asset(
                    'assets/images/cross_dark.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF26CB93)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchProperties(_searchController.text),
              child: Text(AppLocalizations.of(context).translate('tryAgain')),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_searchResults.isEmpty &&
        _searchController.text.isNotEmpty &&
        _hasSearched) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate('noPropertiesFound'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final property = _searchResults[index];
        return PropertyCard(
          property: property,
          onTap: () => context.push('/details/${property['id']}'),
        );
      },
    );
  }
}
