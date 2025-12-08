# Provider State Management - Quick Start Guide

## 🚀 Instalasi yang Sudah Dilakukan

Provider package sudah ditambahkan ke `pubspec.yaml`. Pastikan Anda sudah menjalankan:
```bash
flutter pub get
```

---

## 📌 Struktur Provider yang Tersedia

### 1. **AuthProvider** - Autentikasi User
```dart
import 'package:provider/provider.dart';

// Akses di widget:
context.read<AuthProvider>().login(email, password);
context.watch<AuthProvider>().isAuthenticated;
context.read<AuthProvider>().logout();
```

### 2. **NavigationProvider** - Navigasi Bottom Nav
```dart
Consumer<NavigationProvider>(
  builder: (context, nav, _) {
    return CustomBottomNav(
      currentIndex: nav.currentIndex,
      onTap: nav.onTapNav,
    );
  },
)
```

### 3. **ProgramProvider** - Data Program Lari
```dart
// Fetch programs:
context.read<ProgramProvider>().fetchPrograms();

// Watch programs:
context.watch<ProgramProvider>().programs;

// Complete program:
context.read<ProgramProvider>().completeProgram(programId);
```

### 4. **AppProvider** - Settings Aplikasi
```dart
// Toggle dark mode:
context.read<AppProvider>().toggleDarkMode();

// Get current settings:
context.watch<AppProvider>().isDarkMode;
```

---

## 📁 File Contoh yang Bisa Anda Lihat

1. **`lib/page/login/sign_in_example.dart`**
   - Contoh lengkap implementasi Sign In dengan Provider
   - Menunjukkan error handling, loading state, dan navigation

2. **`lib/page/main/home_example.dart`**
   - Contoh HomePage menggunakan ProgramProvider dan AuthProvider
   - Menampilkan list program dengan interaksi

3. **`STATE_MANAGEMENT_GUIDE.md`**
   - Dokumentasi lengkap setiap provider

---

## ✅ Checklist Implementasi di Proyek Anda

Untuk mengintegrasikan Provider ke halaman-halaman Anda:

### Di **SignIn.dart** dan **SignUp.dart**:
- [ ] Import `provider` package
- [ ] Gunakan `context.read<AuthProvider>()` untuk login/signup
- [ ] Tangkap error dan tampilkan dengan SnackBar
- [ ] Navigate ke MainScreen saat login berhasil

### Di **HomePage.dart**:
- [ ] Gunakan `ChangeNotifierProvider` atau `Consumer<ProgramProvider>`
- [ ] Fetch programs di `initState` atau dengan `FutureBuilder`
- [ ] Display list programs dari `programProvider.programs`

### Di **ProgramWeekPage.dart**:
- [ ] Tampilkan program details
- [ ] Implement "Mark as Complete" button

### Di **ProfilePage.dart**:
- [ ] Display user info dari `authProvider.user`
- [ ] Implement logout button dengan `context.read<AuthProvider>().logout()`

---

## 💡 Common Patterns

### Pattern 1: Menampilkan Data dengan Loading/Error
```dart
Consumer<ProgramProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) return CircularProgressIndicator();
    if (provider.programs.isEmpty) return Text('No data');
    
    return ListView.builder(
      itemCount: provider.programs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(provider.programs[index].title),
        );
      },
    );
  },
)
```

### Pattern 2: Aksi dengan Error Handling
```dart
ElevatedButton(
  onPressed: () async {
    final success = await context.read<AuthProvider>()
        .login(email, password);
    
    if (success) {
      Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (_) => MainScreen())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed'))
      );
    }
  },
  child: Text('Login'),
)
```

### Pattern 3: Multiple Providers
```dart
Consumer2<AuthProvider, ProgramProvider>(
  builder: (context, auth, program, _) {
    return Column(
      children: [
        Text('User: ${auth.user?.name}'),
        Text('Programs: ${program.programs.length}'),
      ],
    );
  },
)
```

---

## 🔄 Workflow Umum

1. **Fetch Data saat halaman load:**
   ```dart
   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       context.read<ProgramProvider>().fetchPrograms();
     });
   }
   ```

2. **Listen perubahan state:**
   ```dart
   Consumer<ProgramProvider>(
     builder: (context, provider, _) {
       // Widget rebuild saat provider berubah
       return Text(provider.programs.length.toString());
     },
   )
   ```

3. **Trigger action:**
   ```dart
   // Dari event listener atau button press
   context.read<ProgramProvider>().selectProgram(program);
   ```

---

## 🐛 Debugging Tips

### Print state changes
```dart
@override
void notifyListeners() {
  print('ProgramProvider updated');
  super.notifyListeners();
}
```

### Check current state
```dart
final auth = context.read<AuthProvider>();
print('User: ${auth.user?.name}');
print('Is authenticated: ${auth.isAuthenticated}');
```

---

## 📚 Resources

- **Official Provider Docs**: https://pub.dev/packages/provider
- **Flutter State Management**: https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro
- **Provider Examples**: https://github.com/rrousselGit/provider/tree/master/packages/provider/example

---

## 🎯 Next: API Integration

Provider sudah siap, sekarang Anda perlu:
1. Update mock API calls dengan real API endpoints
2. Add `http` atau `dio` package
3. Implement proper error handling dan retry logic
4. Add local caching dengan `shared_preferences` atau `hive`

Lihat dokumentasi lengkap di `STATE_MANAGEMENT_GUIDE.md`

---

Selamat coding! 🚀
