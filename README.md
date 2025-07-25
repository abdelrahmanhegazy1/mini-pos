# Mini-POS Checkout Core

This is a logic-only POS checkout engine built using **pure Dart** and **BLoC**. The implementation focuses on business rule modeling, event/state handling, TDD, and unit test discipline.

> ✅ No UI, no plugins, no database — 100% pure Dart core logic.

---

## 🔧 Features

- Product catalog loading (JSON-based)
- Cart management: add/remove/update
- VAT calculation
- Total price & receipt generation
- **Undo/Redo** last N cart actions
- **100% unit test coverage**
- `asMoney` extension on `num`

---

## 📁 Project Structure

mini_pos/
├── lib/
│   └── src/
│       ├── cart/
│       │   ├── bloc/
│       │   │   ├── cart_bloc.dart
│       │   │   ├── cart_event.dart
│       │   │   ├── cart_state.dart
│       │   └── models/
│       │       ├── cart_line.dart
                ├── receipt.dart
│       │       ├── totals.dart
│       ├── catalog/
│       │   ├── bloc/
│       │   │   ├── catalog_bloc.dart
│       │   │   ├── catalog_event.dart
│       │   │   ├── catalog_state.dart
│       │   └── models/
│       │       └── catalog_item.dart
│       ├── extensions/
│       │   └── money_extension.dart
├── test/
│   ├── cart_bloc_test.dart
│   ├── catalog_bloc_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md