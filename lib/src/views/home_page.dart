import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:property_manage/src/localization/app_localizations.dart';
import 'package:property_manage/src/models/property_type.dart';
import 'package:property_manage/src/models/province.dart';
import 'package:property_manage/src/models/rent_type.dart';
import 'package:property_manage/src/providers/auth_provider.dart';
import 'package:property_manage/src/providers/language_provider.dart';
import 'package:property_manage/src/providers/province_provider.dart';
import 'package:property_manage/src/providers/property_provider.dart';
import 'package:property_manage/src/providers/rental_types_provider.dart';
import 'package:property_manage/src/services/session_management_service.dart';
import 'package:property_manage/src/widgets/property_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:property_manage/src/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.provinceId, this.rentTypeId});
  final String? provinceId;
  final String? rentTypeId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getLocalizedProvinceName(Province province, String languageCode) {
    if (province.id == null) {
      return AppLocalizations.of(context).translate('all');
    }

    switch (languageCode) {
      case 'zh':
        return utf8.decode(province.nameChinese!.runes.toList());
      case 'th':
        return utf8.decode(province.nameThailand!.runes.toList());
      case 'my':
        return utf8.decode(province.nameMyanmar!.runes.toList());
      default:
        return province.name;
    }
  }

  String getPropertyName(PropertyType property, String languageCode) {
    if (property.id == null) {
      return AppLocalizations.of(context).translate('all');
    }

    switch (languageCode) {
      case 'zh':
        return utf8.decode(property.nameChinese!.runes.toList());
      case 'th':
        return utf8.decode(property.nameThailand!.runes.toList());
      case 'my':
        return utf8.decode(property.nameMyanmar!.runes.toList());
      default:
        return property.name;
    }
  }

  String getRentName(RentType rentType, String languageCode) {
    switch (languageCode) {
      case 'zh':
        return utf8.decode(rentType.nameChinese!.runes.toList());
      case 'th':
        return utf8.decode(rentType.nameThailand!.runes.toList());
      case 'my':
        return utf8.decode(rentType.nameMyanmar!.runes.toList());
      default:
        return rentType.name;
    }
  }

  bool _isLoading = false;
  String? _error;
  List<dynamic> _properties = [];
  String? _selectedProvince;
  String? _selectedPropertyType;
  String? _selectRentType;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  List<dynamic> _filteredProperties = [];
  bool _isLoadingMore = false;
  String? _nextPageUrl;
  final ScrollController _scrollController = ScrollController();

  // Dropdown for province and property type
  void _showFilterPanel(context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguageCode = languageProvider.currentLocale.languageCode;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Material(
                child: SafeArea(
                  bottom: false,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/home_filter.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('filter'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: SvgPicture.asset(
                                        'assets/images/cross_dark.svg',
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Province Dropdown
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('province'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Consumer<ProvinceProvider>(
                                  builder: (context, provinceProvider, child) {
                                    final provinces =
                                        provinceProvider.provinces;
                                    final isLoading =
                                        provinceProvider.isLoading;

                                    return ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(
                                            context,
                                          ).translate('selectProvince'),
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Color(0xFFb9f0d6),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 16,
                                              ),
                                          isDense: true,
                                        ),
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 250,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        value: _selectedProvince,
                                        items:
                                            isLoading || provinces.isEmpty
                                                ? [
                                                  DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                                : provinces.map((province) {
                                                  final isSelected =
                                                      province.id.toString() ==
                                                      _selectedProvince;
                                                  return DropdownMenuItem(
                                                    value:
                                                        province.id.toString(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isSelected
                                                                ? const Color(
                                                                  0xfff1f2f4,
                                                                )
                                                                : Colors
                                                                    .transparent,
                                                        borderRadius:
                                                            isSelected
                                                                ? BorderRadius.circular(
                                                                  6,
                                                                )
                                                                : null,
                                                      ),

                                                      padding:
                                                          isSelected
                                                              ? const EdgeInsets.symmetric(
                                                                vertical: 8,
                                                              )
                                                              : EdgeInsets.zero,
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Color(
                                                              0xFF000000,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getLocalizedProvinceName(
                                                                province,
                                                                currentLanguageCode,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          if (isSelected)
                                                            const Icon(
                                                              Icons.check,
                                                              color: Color(
                                                                0xFF000000,
                                                              ),
                                                              size: 18,
                                                            ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                        onChanged: (value) {
                                          setModalState(() {
                                            _selectedProvince = value;
                                          });
                                          setState(() {
                                            _selectedProvince = value;
                                          });
                                        },
                                        selectedItemBuilder: (context) {
                                          return provinces.map((province) {
                                            return Text(
                                              getLocalizedProvinceName(
                                                province,
                                                currentLanguageCode,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }).toList();
                                        },
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Property Type Dropdown
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('propertyType'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Consumer<PropertyProvider>(
                                  builder: (
                                    context,
                                    propertyTypeProvider,
                                    child,
                                  ) {
                                    final propertyTypes =
                                        propertyTypeProvider.propertyTypes;
                                    final isLoading =
                                        propertyTypeProvider.isLoading;

                                    return ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(
                                            context,
                                          ).translate('selectProperty'),
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Color(0xFFb9f0d6),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14,
                                              ),
                                          isDense: true,
                                        ),
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 250,
                                        value: _selectedPropertyType,
                                        items:
                                            isLoading || propertyTypes.isEmpty
                                                ? [
                                                  DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                                : propertyTypes.map((
                                                  propertyType,
                                                ) {
                                                  final isSelected =
                                                      propertyType.id
                                                          .toString() ==
                                                      _selectedPropertyType;
                                                  return DropdownMenuItem(
                                                    value:
                                                        propertyType.id
                                                            .toString(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isSelected
                                                                ? const Color(
                                                                  0xfff1f2f4,
                                                                )
                                                                : Colors
                                                                    .transparent,
                                                        borderRadius:
                                                            isSelected
                                                                ? BorderRadius.circular(
                                                                  6,
                                                                )
                                                                : null,
                                                      ),

                                                      padding:
                                                          isSelected
                                                              ? const EdgeInsets.symmetric(
                                                                vertical: 8,
                                                              )
                                                              : EdgeInsets.zero,
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Color(
                                                              0xFF000000,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getPropertyName(
                                                                propertyType,
                                                                currentLanguageCode,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          if (isSelected)
                                                            const Icon(
                                                              Icons.check,
                                                              color: Color(
                                                                0xff000000,
                                                              ),
                                                              size: 18,
                                                            ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                        onChanged: (value) {
                                          setModalState(() {
                                            _selectedPropertyType = value;
                                          });
                                          setState(() {
                                            _selectedPropertyType = value;
                                          });
                                        },
                                        selectedItemBuilder: (context) {
                                          return propertyTypes.map((
                                            propertyType,
                                          ) {
                                            return Text(
                                              getPropertyName(
                                                propertyType,
                                                currentLanguageCode,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }).toList();
                                        },
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),

                                // rentType Dropdown
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('rentType'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Consumer<RentalTypesProvider>(
                                  builder: (
                                    context,
                                    rentalTypesProvider,
                                    child,
                                  ) {
                                    final rentTypes =
                                        rentalTypesProvider.rentTypes;
                                    final isLoading =
                                        rentalTypesProvider.isLoading;

                                    return ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(
                                            context,
                                          ).translate('selectRentType'),
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: Color(0xFFb9f0d6),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14,
                                              ),
                                          isDense: true,
                                        ),
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 250,
                                        value: _selectRentType,
                                        items:
                                            isLoading || rentTypes.isEmpty
                                                ? [
                                                  DropdownMenuItem(
                                                    value: '',
                                                    child: Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                                : rentTypes.map((rentType) {
                                                  final isSelected =
                                                      rentType.id.toString() ==
                                                      _selectRentType;
                                                  return DropdownMenuItem(
                                                    value:
                                                        rentType.id.toString(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isSelected
                                                                ? const Color(
                                                                  0xfff1f2f4,
                                                                )
                                                                : Colors
                                                                    .transparent,
                                                        borderRadius:
                                                            isSelected
                                                                ? BorderRadius.circular(
                                                                  6,
                                                                )
                                                                : null,
                                                      ),

                                                      padding:
                                                          isSelected
                                                              ? const EdgeInsets.symmetric(
                                                                vertical: 8,
                                                              )
                                                              : EdgeInsets.zero,
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Color(
                                                              0xFF000000,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getRentName(
                                                                rentType,
                                                                currentLanguageCode,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          if (isSelected)
                                                            const Icon(
                                                              Icons.check,
                                                              color: Color(
                                                                0xff000000,
                                                              ),
                                                              size: 18,
                                                            ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                        onChanged: (value) {
                                          setModalState(() {
                                            _selectRentType = value;
                                          });
                                          setState(() {
                                            _selectRentType = value;
                                          });
                                        },
                                        selectedItemBuilder: (context) {
                                          return rentTypes.map((rentType) {
                                            return Text(
                                              getRentName(
                                                rentType,
                                                currentLanguageCode,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }).toList();
                                        },
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 250),
                                // Action buttons
                                Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _loadProperties(
                                            provinceId: _selectedProvince,
                                            rentTypeId: _selectRentType,
                                            propertyTypeId:
                                                _selectedPropertyType,
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xff26cb93),
                                          ),
                                          backgroundColor: const Color(
                                            0xfff7fefa,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('viewResults'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // Navigator.of(context).pop();
                                          setModalState(() {
                                            _selectedProvince = null;
                                            _selectedPropertyType = null;
                                            _selectRentType = null;
                                          });
                                          SharedPreferences.getInstance().then((
                                            prefs,
                                          ) {
                                            prefs.remove('selected_province');
                                            prefs.remove(
                                              'selected_property_type',
                                            );
                                            prefs.remove('selected_rent_type');
                                          });
                                          _loadProperties();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0xff26cb93),
                                          ),
                                          backgroundColor: const Color(
                                            0xfff7fefa,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('reset'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedProvince != null) {
      await prefs.setString('selected_province', _selectedProvince!);
    }
    if (_selectedPropertyType != null) {
      await prefs.setString('selected_property_type', _selectedPropertyType!);
    }
    if (_selectRentType != null) {
      await prefs.setString('selected_rent_type', _selectRentType!);
    }
  }

  Future<void> _loadFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedProvince =
          prefs.getString('selected_province') ?? widget.provinceId;
      _selectedPropertyType = prefs.getString('selected_property_type');
      _selectRentType =
          prefs.getString('selected_rent_type') ?? widget.rentTypeId;
    });

    // Load properties with cached filters
    _loadProperties(
      provinceId: _selectedProvince,
      rentTypeId: _selectRentType,
      propertyTypeId: _selectedPropertyType,
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.provinceId != null) {
      _selectedProvince = widget.provinceId;
    }

    if (widget.rentTypeId != null) {
      _selectRentType = widget.rentTypeId;
    }

    _loadFilterPreferences();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProvinceProvider>().loadProvinces();
        context.read<PropertyProvider>().loadPropertyTypes();
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        !_isLoadingMore &&
        _nextPageUrl != null) {
      _loadMoreProperties();
    }
  }

  @override
  void dispose() {
    _saveFilterPreferences();
    _searchFocusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || _nextPageUrl == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      final response = await apiService.getWithFullUrl(_nextPageUrl!);

      if (mounted) {
        setState(() {
          final newProperties = response['results'] ?? [];
          _properties.addAll(newProperties);
          _filteredProperties =
              _properties.where((property) => property['status'] == 1).toList();
          _nextPageUrl = response['next'];
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadProperties({
    String? provinceId,
    String? rentTypeId,
    String? propertyTypeId,
  }) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _nextPageUrl = null;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final queryParams = {
        'province':
            (provinceId == null || provinceId == 'null') ? '' : provinceId,
        'property_type':
            (propertyTypeId == null || propertyTypeId == 'null')
                ? ''
                : propertyTypeId,
        'rent_type':
            (rentTypeId == null || rentTypeId == 'null') ? '' : rentTypeId,
      };
      final response = await apiService.get('posts', queryParams: queryParams);

      if (mounted) {
        setState(() {
          _properties = response['results'] ?? [];
          _filteredProperties =
              _properties.where((property) => property['status'] == 1).toList();
          _nextPageUrl = response['next'];
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
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final sessionService = SessionService();
      Future.microtask(() => sessionService.handleSessionExpiry(authProvider));
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffdcf5ea), Color(0xfff5f5f5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: null,
          actions: null,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _searchFocusNode,
                    textInputAction: TextInputAction.search,

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
                          onPressed: () {},
                        ),
                      ),
                      suffixIcon: null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onTap: () {
                      _searchFocusNode.unfocus();

                      context.push(
                        '/home_search',
                        extra: {
                          'properties': _filteredProperties,
                          'selectedProvince': _selectedProvince,
                          'selectedPropertyType': _selectedPropertyType,
                          'selectedRentType': _selectRentType,
                        },
                      );
                    },
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showFilterPanel(context),
                  child: Image.asset(
                    'assets/images/home_filter.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (_isSearchFocused) {
      return GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

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
              onPressed: _loadProperties,
              child: Text(AppLocalizations.of(context).translate('tryAgain')),
            ),
          ],
        ),
      );
    }

    if (_filteredProperties.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).translate('noPropertiesFound'),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF26CB93),
      onRefresh:
          () => _loadProperties(
            provinceId: _selectedProvince,
            rentTypeId: _selectRentType,
            propertyTypeId: _selectedPropertyType,
          ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _filteredProperties.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredProperties.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Color(0xFF26CB93)),
              ),
            );
          }

          final property = _filteredProperties[index];
          return PropertyCard(
            property: property,
            onTap: () => context.push('/details/${property['id']}'),
          );
        },
      ),
    );
  }
}
