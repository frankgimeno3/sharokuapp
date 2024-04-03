import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class Task {
  final int id;
  final DateTime date;
  DateTime? startTime;
  DateTime? endTime;
  final bool lastsAllDay;
  final String concept;
  final String description;

  Task({
    required this.id,
    required this.date,
    this.startTime,
    this.endTime,
    this.lastsAllDay = true,
    required this.concept,
    required this.description,
  });
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    // Initialize locale data
    initializeDateFormatting('es', null);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _addTask() {
    // Implement task addition logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TableCalendar(
              locale: "es",
              focusedDay: _selectedDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(3050, 12, 31),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 16),
            Text(
              '${_selectedDay.weekday == 1 ? 'Lunes' : _selectedDay.weekday == 2 ? 'Martes' : _selectedDay.weekday == 3 ? 'Miércoles' : _selectedDay.weekday == 4 ? 'Jueves' : _selectedDay.weekday == 5 ? 'Viernes' : _selectedDay.weekday == 6 ? 'Sábado' : 'Domingo'} ${_selectedDay.day} de ${_selectedDay.month == 1 ? 'Enero' : _selectedDay.month == 2 ? 'Febrero' : _selectedDay.month == 3 ? 'Marzo' : _selectedDay.month == 4 ? 'Abril' : _selectedDay.month == 5 ? 'Mayo' : _selectedDay.month == 6 ? 'Junio' : _selectedDay.month == 7 ? 'Julio' : _selectedDay.month == 8 ? 'Agosto' : _selectedDay.month == 9 ? 'Septiembre' : _selectedDay.month == 10 ? 'Octubre' : _selectedDay.month == 11 ? 'Noviembre' : 'Diciembre'} de ${_selectedDay.year}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Modificación del tamaño de fuente
            ),
            const Text(
              "Tareas:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            tasks.isEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "No se han encontrado tareas para este día",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].concept),
                    subtitle: Text(tasks[index].description),
                    // Display more task information here
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text("Añadir tarea"),
            ),
          ],
        ),
      ),
    );
  }
}