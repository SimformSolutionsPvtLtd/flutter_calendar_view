import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthView selectedDate', () {
    testWidgets('tracks tapped date internally when selectedDate is null',
        (tester) async {
      DateTime? tappedDate;

      await tester.pumpWidget(
        _buildMonthView(
          onCellTap: (_, date) => tappedDate = date,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2026-5-15-idle'), findsOneWidget);
      expect(find.text('2026-5-20-selected'), findsNothing);

      await tester.tap(find.text('2026-5-15-idle'));
      await tester.pump();

      expect(find.text('2026-5-15-selected'), findsOneWidget);
      expect(tappedDate, DateTime(2026, 5, 15));
    });

    testWidgets('uses external selectedDate when provided', (tester) async {
      DateTime? tappedDate;

      await tester.pumpWidget(
        _buildMonthView(
          selectedDate: DateTime(2026, 5, 13),
          onCellTap: (_, date) => tappedDate = date,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2026-5-13-selected'), findsOneWidget);
      expect(find.text('2026-5-15-idle'), findsOneWidget);

      await tester.tap(find.text('2026-5-15-idle'));
      await tester.pump();

      expect(find.text('2026-5-13-selected'), findsOneWidget);
      expect(find.text('2026-5-15-selected'), findsNothing);
      expect(tappedDate, DateTime(2026, 5, 15));
    });
  });
}

Widget _buildMonthView({
  DateTime? selectedDate,
  CellTapCallback<Object?>? onCellTap,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 420,
        height: 420,
        child: MonthView<Object?>(
          width: 420,
          controller: EventController<Object?>(),
          selectedDate: selectedDate,
          monthViewStyle: MonthViewStyle(
            initialMonth: DateTime(2026, 5, 1),
            minMonth: DateTime(2026, 5, 1),
            maxMonth: DateTime(2026, 5, 31),
            hideDaysNotInMonth: false,
            pagePhysics: NeverScrollableScrollPhysics(),
          ),
          monthViewBuilders: MonthViewBuilders<Object?>(
            onCellTap: onCellTap,
            cellBuilder: (
              date,
              events,
              isToday,
              isInMonth,
              isSelected,
              hideDaysNotInMonth,
            ) {
              return Center(
                child: Text(
                  '${date.year}-${date.month}-${date.day}-${isSelected ? 'selected' : 'idle'}',
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
