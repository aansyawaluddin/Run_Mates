# State Management - Provider Guide

Proyek RunMates telah diintegrasikan dengan **Provider** sebagai state management solution. Provider adalah solusi state management yang powerful, scalable, dan mudah digunakan untuk aplikasi Flutter.

## 📋 Daftar Providers

### 1. **AuthProvider** (`lib/providers/auth_provider.dart`)
Mengelola state autentikasi dan data user.

**Properties:**
- `user` - Data user yang sedang login
- `isAuthenticated` - Status autentikasi
- `isLoading` - Status loading
- `errorMessage` - Pesan error

**Methods:**
- `login(email, password)` - Login user
- `signup(name, email, password)` - Daftar user baru
- `logout()` - Logout user
- `clearError()` - Hapus pesan error

**Contoh penggunaan di Widget:**
```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return FloatingActionButton(
          onPressed: () {
            authProvider.login('user@example.com', 'password');
          },
          child: authProvider.isLoading
              ? CircularProgressIndicator()
              : Text('Login'),
        );
      },
    );
  }
}
```

---

### 2. **NavigationProvider** (`lib/providers/navigation_provider.dart`)
Mengelola state navigasi halaman utama (bottom navigation).

**Properties:**
- `currentIndex` - Index halaman yang aktif
- `pageController` - PageController untuk animasi

**Methods:**
- `onTapNav(index)` - Dipanggil saat nav bar diklik
- `onPageChanged(index)` - Dipanggil saat PageView bergeser

**Contoh penggunaan:**
```dart
Consumer<NavigationProvider>(
  builder: (context, navProvider, _) {
    return CustomBottomNav(
      currentIndex: navProvider.currentIndex,
      onTap: navProvider.onTapNav,
    );
  },
)
```

---

### 3. **ProgramProvider** (`lib/providers/program_provider.dart`)
Mengelola data program lari/fitness.

**Properties:**
- `programs` - List semua program
- `selectedProgram` - Program yang dipilih
- `isLoading` - Status loading

**Methods:**
- `fetchPrograms()` - Ambil data program dari API
- `selectProgram(program)` - Pilih program
- `completeProgram(id)` - Tandai program selesai
- `addProgram(program)` - Tambah program baru
- `deleteProgram(id)` - Hapus program

**Contoh penggunaan:**
```dart
class ProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context, programProvider, _) {
        if (programProvider.isLoading) {
          return CircularProgressIndicator();
        }
        
        return ListView.builder(
          itemCount: programProvider.programs.length,
          itemBuilder: (context, index) {
            final program = programProvider.programs[index];
            return ListTile(
              title: Text(program.title),
              onTap: () {
                programProvider.selectProgram(program);
              },
            );
          },
        );
      },
    );
  }
}
```

---

### 4. **AppProvider** (`lib/providers/app_provider.dart`)
Mengelola state aplikasi umum (dark mode, bahasa, dll).

**Properties:**
- `isDarkMode` - Status dark mode
- `appLanguage` - Bahasa aplikasi ('id' atau 'en')

**Methods:**
- `toggleDarkMode()` - Toggle dark mode
- `setDarkMode(bool)` - Set dark mode
- `setLanguage(language)` - Ubah bahasa

**Contoh penggunaan:**
```dart
Consumer<AppProvider>(
  builder: (context, appProvider, _) {
    return Switch(
      value: appProvider.isDarkMode,
      onChanged: (value) {
        appProvider.setDarkMode(value);
      },
    );
  },
)
```

---

## 🎯 Cara Menggunakan Provider di Widget

### Opsi 1: Consumer (Recommended)
```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text('User: ${authProvider.user?.name}');
  },
)
```

### Opsi 2: context.read (untuk method/event)
```dart
ElevatedButton(
  onPressed: () {
    context.read<AuthProvider>().logout();
  },
  child: Text('Logout'),
)
```

### Opsi 3: context.watch (untuk rebuild otomatis)
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Text('Status: ${authProvider.isAuthenticated}');
  }
}
```

### Opsi 4: Selector (untuk listen property tertentu)
```dart
Selector<AuthProvider, bool>(
  selector: (context, authProvider) => authProvider.isLoading,
  builder: (context, isLoading, child) {
    return isLoading
        ? CircularProgressIndicator()
        : child!;
  },
  child: YourWidget(),
)
```

---

## 🚀 Next Steps - Yang Perlu Dilakukan

1. **Update LoginPage dan SignUp/SignIn**
   - Integrasikan dengan `AuthProvider.login()` dan `AuthProvider.signup()`
   - Redirect ke `MainScreen` setelah login berhasil

2. **Update HomePage, ProgramWeekPage, ProfilePage**
   - Gunakan `ProgramProvider` untuk fetch dan display program
   - Gunakan `AuthProvider` untuk tampilkan data user

3. **Implementasi API Integration**
   - Ganti mock API di providers dengan real API calls
   - Gunakan `http` atau `dio` package untuk HTTP requests

4. **Tambahkan Error Handling**
   - Tampilkan error messages menggunakan SnackBar atau Dialog
   - Handle exception di setiap provider method

5. **Implementasi Local Storage** (Optional)
   - Gunakan `shared_preferences` untuk simpan user session
   - Gunakan `hive` untuk cache data program

---

## 📦 Dependencies yang Digunakan

```yaml
provider: ^6.1.5+1  # State Management
```

---

## 💡 Best Practices

1. **Jangan overload Provider dengan banyak state**
   - Pisahkan concern: AuthProvider untuk auth, ProgramProvider untuk program, dll

2. **Gunakan Consumer atau Selector untuk optimize rebuilds**
   - Hindari rebuilding widget yang tidak perlu

3. **Clear Error Messages**
   - Selalu panggil `clearError()` setelah menampilkan error

4. **Handle Loading States**
   - Selalu cek `isLoading` sebelum menampilkan UI

5. **Test Providers**
   - Test provider logic secara terpisah dari UI

---

## 📚 Resources

- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
