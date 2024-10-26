  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:to_do_list_app/about_screen.dart';
  import 'package:to_do_list_app/models/task.dart';
import 'package:to_do_list_app/screens/bin_screen.dart';
  import 'screens/splash_screen.dart';
  import 'providers/task_provider.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: MaterialApp(
          title: 'To-Do List App',
          theme: ThemeData(
            primaryColor: const Color(0xFF2C3E50),
            hintColor: const Color(0xFF1ABC9C),
            fontFamily: GoogleFonts.poppins().fontFamily,
            textTheme: GoogleFonts.poppinsTextTheme().copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.grey[800],
              ),
              titleMedium: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            scaffoldBackgroundColor: Colors.grey[100],
          ),
          home: const SplashScreen(),
        ),
      );
    }
  }

  class ToDoListScreen extends StatefulWidget {
    const ToDoListScreen({super.key});

    @override
    _ToDoListScreenState createState() => _ToDoListScreenState();
  }

  class _ToDoListScreenState extends State<ToDoListScreen> with SingleTickerProviderStateMixin {
    late TabController _tabController;

    @override
    void initState() {
      super.initState();
      _tabController = TabController(length: 2, vsync: this);
    }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF2C3E50),
      title: const Text(
        'To Do List App',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BinScreen()),
            );
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Completed'),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Colors.teal[100],
        indicatorColor: Colors.orangeAccent,
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: [
        _buildTaskList(false),
        _buildTaskList(true),
      ],
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {
        _showTaskForm(context, null, null);
      },
      icon: const Icon(Icons.add),
      label: const Text('Tugas Baru'),
      backgroundColor: const Color(0xFF1ABC9C),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}



    Widget _buildTaskList(bool isCompleted) {
  return Consumer<TaskProvider>(
    builder: (context, taskProvider, child) {
      final tasks = isCompleted
          ? taskProvider.tasks.where((task) => task.isCompleted).toList()
          : taskProvider.tasks.where((task) => !task.isCompleted).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCompleted ? "Tugas Selesai" : "Tugas Aktif",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${tasks.length} tugas",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isCompleted ? Icons.check_circle_outline : Icons.list_alt,
                    color: const Color(0xFF1ABC9C),
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Tasks List
          Expanded(
            child: Container(
              color: const Color(0xFFF5F6FA),
              child: tasks.isEmpty
                  ? _buildEmptyState(isCompleted)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _buildTaskCard(task, taskProvider, context);
                      },
                    ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildEmptyState(bool isCompleted) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCompleted ? Icons.task_alt : Icons.assignment_outlined,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          isCompleted
              ? "Belum ada tugas yang diselesaikan"
              : "Belum ada tugas aktif",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isCompleted
              ? "Selesaikan beberapa tugas untuk melihatnya di sini"
              : "Tap tombol + untuk menambah tugas baru",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildTaskCard(Task task, TaskProvider taskProvider, BuildContext context) {
  return Dismissible(
    key: Key('${task.title}_${task.id ?? ''}'),
    background: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    ),
    onDismissed: (direction) {
      taskProvider.removeTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tugas telah dihapus'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Sedikit bayangan untuk efek depth
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with priority color
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: task.priorityColor?.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          _buildPriorityBadge(task),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Task Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Due Date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tenggat: ${DateFormat('dd MMM yyyy – HH:mm').format(task.dueDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Status
                      Row(
                        children: [
                          Icon(
                            task.isCompleted ? Icons.check_circle : Icons.pending,
                            size: 20,
                            color: task.isCompleted ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status: ${task.isCompleted ? 'Selesai' : 'Belum Selesai'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: task.isCompleted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Close Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  _buildCheckbox(task, taskProvider),
                  
                  const SizedBox(width: 12),

                  // Task Content
                  Expanded(
                    child: _buildTaskContent(task),
                  ),

                  // Action Buttons (Edit & Delete)
                  if (!task.isCompleted) _buildActionButtons(context, task, taskProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// Fungsi untuk membangun Checkbox
Widget _buildCheckbox(Task task, TaskProvider taskProvider) {
  return Transform.scale(
    scale: 1.2,
    child: Checkbox(
      value: task.isCompleted,
      onChanged: (bool? value) {
        taskProvider.toggleTaskCompletion(task);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      activeColor: const Color(0xFF1ABC9C),
    ),
  );
}

// Fungsi untuk menampilkan konten tugas
Widget _buildTaskContent(Task task) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        task.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      const SizedBox(height: 8),
      _buildPriorityBadge(task), // Badge untuk prioritas
      const SizedBox(height: 8),
      Text(
        task.description,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      const SizedBox(height: 4),
      _buildDueDate(task), // Tampilkan due date
    ],
  );
}

// Fungsi untuk menampilkan due date dengan icon
Widget _buildDueDate(Task task) {
  return Row(
    children: [
      Icon(
        Icons.access_time,
        size: 16,
        color: Colors.grey[500],
      ),
      const SizedBox(width: 4),
      Text(
        DateFormat('dd MMM yyyy – HH:mm').format(task.dueDate),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
    ],
  );
}

// Fungsi untuk menampilkan badge prioritas
Widget _buildPriorityBadge(Task task) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: task.priorityColor?.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: task.priorityColor ?? Colors.grey,
        width: 1,
      ),
    ),
    child: Text(
      'Prioritas: ${task.priority}',
      style: TextStyle(
        fontSize: 12,
        color: task.priorityColor,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

// Fungsi untuk menampilkan tombol aksi (Edit & Delete)
Widget _buildActionButtons(BuildContext context, Task task, TaskProvider taskProvider) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(
          Icons.edit_outlined,
          color: Color(0xFF1ABC9C),
          size: 22,
        ),
        onPressed: () {
          _showTaskForm(context, task, taskProvider.tasks.indexOf(task));
        },
      ),
      IconButton(
        icon: Icon(
          Icons.delete_outline,
          color: Colors.red[400],
          size: 22,
        ),
        onPressed: () {
          _showDeleteConfirmation(context, task, taskProvider);
        },
      ),
    ],
  );
}

// Floating Action Button
Widget buildFloatingActionButton(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () {
      _showTaskForm(context, null, null);
    },
    backgroundColor: const Color(0xFF1ABC9C),
    elevation: 4,
    icon: const Icon(Icons.add_rounded, size: 24),
    label: const Text(
      'Tugas Baru',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}




  void _showDeleteConfirmation(BuildContext context, Task task, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Tugas"),
          content: const Text("Apakah Anda yakin ingin menghapus tugas ini?"),
          actions: [
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ya", style: TextStyle(color: Colors.red)),
              onPressed: () {
                taskProvider.removeTask(task);
                Navigator.of(context).pop();
                // Menampilkan SnackBar setelah tugas dihapus
                _showSimpleSnackBar(context, 'Tugas berhasil dihapus');
              },
            ),
          ],
        );
      },
    );
  }

  void _showSimpleSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Padding lebih kecil
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white, // Warna teks
            ),
          ),
        ),
        backgroundColor: Colors.grey[800], // Warna abu-abu gelap
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16), // Margin di luar SnackBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Radius lebih kecil untuk sudut
        ),
      ),
    );
  }



    void _showTaskForm(BuildContext context, Task? task, int? index) {
  final titleController = TextEditingController(text: task?.title);
  final descriptionController = TextEditingController(text: task?.description);
  final priorityController = TextEditingController(text: task?.priority);
  DateTime dueDate = task?.dueDate ?? DateTime.now();
  TimeOfDay dueTime = TimeOfDay.fromDateTime(dueDate);

  final List<Map<String, dynamic>> priorityOptions = [
    {'label': 'Urgent', 'color': Colors.red, 'icon': Icons.warning_rounded},
    {'label': 'High', 'color': Colors.orange, 'icon': Icons.arrow_upward_rounded},
    {'label': 'Medium', 'color': Colors.yellow, 'icon': Icons.remove_rounded},
    {'label': 'Low', 'color': Colors.green, 'icon': Icons.arrow_downward_rounded},
    {'label': 'Optional', 'color': Colors.blue, 'icon': Icons.more_horiz_rounded},
  ];

  Color selectedColor = task?.priorityColor ?? priorityOptions[2]['color'];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            task == null ? Icons.add_task : Icons.edit,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            task == null ? 'Tambah Tugas Baru' : 'Edit Tugas',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Field
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Judul Tugas',
                              prefixIcon: const Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Description Field
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi',
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Priority Section
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prioritas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: priorityOptions.map((option) {
                                      final isSelected = selectedColor == option['color'];
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = option['color'];
                                            priorityController.text = option['label'];
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: isSelected ? option['color'].withOpacity(0.1) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected ? option['color'] : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Priority Icon with Circle Background
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: option['color'].withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  option['icon'],
                                                  color: option['color'],
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Priority Label
                                              Expanded(
                                                child: Text(
                                                  option['label'],
                                                  style: TextStyle(
                                                    color: option['color'],
                                                    fontSize: 16,
                                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              // Checkmark for Selected Item
                                              if (isSelected)
                                                AnimatedOpacity(
                                                  duration: const Duration(milliseconds: 200),
                                                  opacity: 1.0,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: option['color'],
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Due Date & Time Section
                          Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // efek bayangan
      ),
    ],
    border: Border.all(color: Colors.grey[300]!),
  ),
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Tenggat Waktu',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[800],
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              icon: const Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.blueAccent,
              ),
              label: Text(
                DateFormat('dd MMM yyyy').format(dueDate),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dueDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      dueTime.hour,
                      dueTime.minute,
                    );
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              icon: const Icon(
                Icons.access_time,
                size: 20,
                color: Colors.orangeAccent,
              ),
              label: Text(
                dueTime.format(context),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: dueTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    dueTime = pickedTime;
                    dueDate = DateTime(
                      dueDate.year,
                      dueDate.month,
                      dueDate.day,
                      dueTime.hour,
                      dueTime.minute,
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    ],
  ),
),


                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Batal',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (titleController.text.isNotEmpty &&
                                  descriptionController.text.isNotEmpty &&
                                  priorityController.text.isNotEmpty) {
                                final newTask = Task(
                                  id: task?.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  priority: priorityController.text,
                                  priorityColor: selectedColor,
                                  dueDate: dueDate,
                                  isCompleted: task?.isCompleted ?? false,
                                );

                                if (task == null) {
                                  Provider.of<TaskProvider>(context,
                                          listen: false)
                                      .addTask(newTask);
                                } else {
                                  Provider.of<TaskProvider>(context,
                                          listen: false)
                                      .updateTask(index!, newTask);
                                }
                                Navigator.of(context).pop();

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      task == null
                                          ? 'Tugas berhasil ditambahkan'
                                          : 'Tugas berhasil diperbarui',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Semua kolom harus diisi',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              task == null ? 'Tambah Tugas' : 'Simpan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
             ],
            )
              )
            ),
          );
          
        },
      );
    },
  );
}
}

