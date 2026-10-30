import 'package:flutter/material.dart';

void main() {
  runApp(const DompetkuApp());
}

class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class Category {
  const Category(this.name, this.imagePath);

  final String name;
  final String imagePath;
}

const categories = [
  Category('Makanan', 'assets/Makanan.jpg'),
  Category('Transportasi', 'assets/Transportasi.jpg'),
  Category('Belanja', 'assets/Belanja.png'),
  Category('Hiburan', 'assets/Hiburan.jpg'),
  Category('Kesehatan', 'assets/Kesehatan.jpg'),
];

class Expense {
  Expense(this.title, this.amount, this.category);

  final String title;
  final double amount;
  final Category category;
}

String formatRupiah(double value) {
  final digits = value.toStringAsFixed(0);
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final sisa = digits.length - i;
    buffer.write(digits[i]);

    if (sisa > 1 && sisa % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp $buffer';
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Expense> _expenses = [
    Expense('Makan Siang', 25000, categories[0]),
    Expense('Ojek ke Kampus', 15000, categories[1]),
    Expense('Beli Buku', 85000, categories[2]),
    Expense('Nonton Bioskop', 50000, categories[3]),
    Expense('Kopi Susu', 18000, categories[0]),
    Expense('Beli Obat', 120000, categories[4]),
  ];

  double get _total {
    return _expenses.fold(0, (sum, e) => sum + e.amount);
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _expenses.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dompetku'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.receipt_long),
                text: 'Transaksi',
              ),
              Tab(
                icon: Icon(Icons.category),
                text: 'Kategori',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profil',
              ),
              Tab(
                icon: Icon(Icons.bar_chart),
                text: 'Statistik',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TransaksiTab(
              expenses: _expenses,
              total: _total,
            ),
            KategoriTab(
              expenses: _expenses,
            ),
            const ProfilTab(),
            StatistikTab(
              expenses: _expenses,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openForm,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TransaksiTab extends StatelessWidget {
  const TransaksiTab({
    super.key,
    required this.expenses,
    required this.total,
  });

  final List<Expense> expenses;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.account_balance_wallet),
            ),
            title: const Text('Total Pengeluaran'),
            subtitle: Text(
              formatRupiah(total),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    expense.category.imagePath,
                  ),
                ),
                title: Text(expense.title),
                subtitle: Text(expense.category.name),
                trailing: Text(
                  formatRupiah(expense.amount),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class KategoriTab extends StatelessWidget {
  const KategoriTab({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  double getSubtotal(Category category) {
    return expenses
        .where((expense) => expense.category == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final subtotal = getSubtotal(category);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    category.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(formatRupiah(subtotal)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/Avatar.png',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pengguna Dompetku',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Image.network(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class StatistikTab extends StatelessWidget {
  const StatistikTab({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text('Belum ada transaksi'),
      );
    }

    final sortedExpenses = List<Expense>.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final largest = sortedExpenses.first;

    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bar_chart,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaksi Terbesar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                largest.category.imagePath,
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 12),
              Text(
                largest.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(largest.category.name),
              const SizedBox(height: 8),
              Text(
                formatRupiah(largest.amount),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = categories[0];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final amount =
        double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null) {
      return;
    }

    Navigator.pop(
      context,
      Expense(
        title,
        amount,
        _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama transaksi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Category>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (category) {
                if (category != null) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}