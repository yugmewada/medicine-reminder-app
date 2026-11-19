// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i12;
import 'package:demo_project/features/auth/presentation/welcome_screen.dart'
    as _i11;
import 'package:demo_project/features/medicines/presentation/inventory_screen.dart'
    as _i3;
import 'package:demo_project/features/medicines/presentation/inventory_tab_screen.dart'
    as _i4;
import 'package:demo_project/features/medicines/presentation/medicine_detail_screen.dart'
    as _i5;
import 'package:demo_project/features/medicines/presentation/medicine_form_screen.dart'
    as _i1;
import 'package:demo_project/features/onboarding/presentation/onboarding_screen.dart'
    as _i7;
import 'package:demo_project/features/profile/presentation/profile_screen.dart'
    as _i8;
import 'package:demo_project/features/shell/home_shell.dart' as _i2;
import 'package:demo_project/features/shell/not_found_screen.dart' as _i6;
import 'package:demo_project/features/splash/presentation/splash_screen.dart'
    as _i9;
import 'package:demo_project/features/today/presentation/today_screen.dart'
    as _i10;
import 'package:material_ui/material_ui.dart' as _i13;

/// generated route for
/// [_i1.AddMedicineScreen]
class AddMedicineRoute extends _i12.PageRouteInfo<void> {
  const AddMedicineRoute({List<_i12.PageRouteInfo>? children})
    : super(AddMedicineRoute.name, initialChildren: children);

  static const String name = 'AddMedicineRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddMedicineScreen();
    },
  );
}

/// generated route for
/// [_i1.EditMedicineScreen]
class EditMedicineRoute extends _i12.PageRouteInfo<EditMedicineRouteArgs> {
  EditMedicineRoute({
    _i13.Key? key,
    required String medicineId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         EditMedicineRoute.name,
         args: EditMedicineRouteArgs(key: key, medicineId: medicineId),
         rawPathParams: {'medicineId': medicineId},
         initialChildren: children,
       );

  static const String name = 'EditMedicineRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EditMedicineRouteArgs>(
        orElse: () => EditMedicineRouteArgs(
          medicineId: pathParams.getString('medicineId'),
        ),
      );
      return _i1.EditMedicineScreen(key: args.key, medicineId: args.medicineId);
    },
  );
}

class EditMedicineRouteArgs {
  const EditMedicineRouteArgs({this.key, required this.medicineId});

  final _i13.Key? key;

  final String medicineId;

  @override
  String toString() {
    return 'EditMedicineRouteArgs{key: $key, medicineId: $medicineId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditMedicineRouteArgs) return false;
    return key == other.key && medicineId == other.medicineId;
  }

  @override
  int get hashCode => key.hashCode ^ medicineId.hashCode;
}

/// generated route for
/// [_i2.HomeShell]
class HomeShellRoute extends _i12.PageRouteInfo<void> {
  const HomeShellRoute({List<_i12.PageRouteInfo>? children})
    : super(HomeShellRoute.name, initialChildren: children);

  static const String name = 'HomeShellRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeShell();
    },
  );
}

/// generated route for
/// [_i3.InventoryScreen]
class InventoryRoute extends _i12.PageRouteInfo<void> {
  const InventoryRoute({List<_i12.PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.InventoryScreen();
    },
  );
}

/// generated route for
/// [_i4.InventoryTabScreen]
class InventoryTabRoute extends _i12.PageRouteInfo<void> {
  const InventoryTabRoute({List<_i12.PageRouteInfo>? children})
    : super(InventoryTabRoute.name, initialChildren: children);

  static const String name = 'InventoryTabRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.InventoryTabScreen();
    },
  );
}

/// generated route for
/// [_i5.MedicineDetailScreen]
class MedicineDetailRoute extends _i12.PageRouteInfo<MedicineDetailRouteArgs> {
  MedicineDetailRoute({
    _i13.Key? key,
    required String medicineId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         MedicineDetailRoute.name,
         args: MedicineDetailRouteArgs(key: key, medicineId: medicineId),
         rawPathParams: {'medicineId': medicineId},
         initialChildren: children,
       );

  static const String name = 'MedicineDetailRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MedicineDetailRouteArgs>(
        orElse: () => MedicineDetailRouteArgs(
          medicineId: pathParams.getString('medicineId'),
        ),
      );
      return _i5.MedicineDetailScreen(
        key: args.key,
        medicineId: args.medicineId,
      );
    },
  );
}

class MedicineDetailRouteArgs {
  const MedicineDetailRouteArgs({this.key, required this.medicineId});

  final _i13.Key? key;

  final String medicineId;

  @override
  String toString() {
    return 'MedicineDetailRouteArgs{key: $key, medicineId: $medicineId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MedicineDetailRouteArgs) return false;
    return key == other.key && medicineId == other.medicineId;
  }

  @override
  int get hashCode => key.hashCode ^ medicineId.hashCode;
}

/// generated route for
/// [_i6.NotFoundScreen]
class NotFoundRoute extends _i12.PageRouteInfo<void> {
  const NotFoundRoute({List<_i12.PageRouteInfo>? children})
    : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.NotFoundScreen();
    },
  );
}

/// generated route for
/// [_i7.OnboardingScreen]
class OnboardingRoute extends _i12.PageRouteInfo<void> {
  const OnboardingRoute({List<_i12.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i8.ProfileScreen]
class ProfileRoute extends _i12.PageRouteInfo<void> {
  const ProfileRoute({List<_i12.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashScreen();
    },
  );
}

/// generated route for
/// [_i10.TodayScreen]
class TodayRoute extends _i12.PageRouteInfo<void> {
  const TodayRoute({List<_i12.PageRouteInfo>? children})
    : super(TodayRoute.name, initialChildren: children);

  static const String name = 'TodayRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.TodayScreen();
    },
  );
}

/// generated route for
/// [_i11.WelcomeScreen]
class WelcomeRoute extends _i12.PageRouteInfo<void> {
  const WelcomeRoute({List<_i12.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.WelcomeScreen();
    },
  );
}
