import 'package:auto_route/auto_route.dart';

/// Inventory tab host: a nested stack (list → detail) inside the shell, so
/// the tab bar stays visible and the tab keeps its own back stack.
@RoutePage()
class InventoryTabScreen extends AutoRouter {
  const InventoryTabScreen({super.key});
}
