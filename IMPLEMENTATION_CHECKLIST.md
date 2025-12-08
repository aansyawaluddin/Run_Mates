# 📋 Implementation Checklist

Gunakan file ini untuk track progress implementasi Provider di setiap halaman.

## 🎯 PHASE 1: Core Pages Integration (REQUIRED)

### SignIn Page (lib/page/login/signIn.dart)
- [ ] Import `package:provider/provider.dart`
- [ ] Import `package:runmates/providers/auth_provider.dart`
- [ ] Replace navigation logic dengan `context.read<AuthProvider>().login()`
- [ ] Add error handling dengan SnackBar
- [ ] Show loading state saat login process
- [ ] Redirect ke MainScreen saat login success
- [ ] Test: Verify no errors & navigation works

**Reference File:** `lib/page/login/sign_in_example.dart`

```dart
// Quick snippet to add:
import 'package:provider/provider.dart';
import 'package:runmates/providers/auth_provider.dart';
import 'package:runmates/home.dart';

// In your login button onPressed:
onPressed: () async {
  final success = await context.read<AuthProvider>()
      .login(_emailController.text, _passwordController.text);
  
  if (success) {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const MainScreen())
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed'))
    );
  }
}
```

---

### SignUp Page (lib/page/login/signUp.dart)
- [ ] Import `package:provider/provider.dart`
- [ ] Import `package:runmates/providers/auth_provider.dart`
- [ ] Replace signup logic dengan `context.read<AuthProvider>().signup()`
- [ ] Add proper validation
- [ ] Add error handling & loading state
- [ ] Redirect ke MainScreen saat signup success
- [ ] Test: Verify no errors & navigation works

**Reference File:** `lib/page/login/sign_in_example.dart`

```dart
// Quick snippet to add:
onPressed: () async {
  final success = await context.read<AuthProvider>()
      .signup(_nameController.text, _emailController.text, 
              _passwordController.text);
  
  if (success) {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const MainScreen())
    );
  }
}
```

---

### HomePage (lib/page/main/home.dart)
- [ ] Import `package:provider/provider.dart`
- [ ] Import `package:runmates/providers/program_provider.dart`
- [ ] Fetch programs di initState atau FutureBuilder
- [ ] Replace hardcoded data dengan `programProvider.programs`
- [ ] Implement Consumer untuk auto-rebuild saat data changes
- [ ] Handle loading state
- [ ] Handle empty state
- [ ] Test: Verify programs load & display correctly

**Reference File:** `lib/page/main/home_example.dart`

```dart
// Quick snippet to add:
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProgramProvider>().fetchPrograms();
  });
}

// Replace your list with:
Consumer<ProgramProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) return CircularProgressIndicator();
    if (provider.programs.isEmpty) return Text('No programs');
    
    return ListView.builder(
      itemCount: provider.programs.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(provider.programs[i].title),
      ),
    );
  },
)
```

---

### ProgramWeekPage (lib/page/main/programWeek.dart)
- [ ] Import `package:provider/provider.dart`
- [ ] Import `package:runmates/providers/program_provider.dart`
- [ ] Display `selectedProgram` dari provider
- [ ] Implement "Mark as Complete" button
- [ ] Call `context.read<ProgramProvider>().completeProgram(id)`
- [ ] Update UI setelah completion
- [ ] Test: Verify selected program displays & completion works

```dart
// Quick snippet to add:
Consumer<ProgramProvider>(
  builder: (context, provider, _) {
    final program = provider.selectedProgram;
    if (program == null) return Text('No program selected');
    
    return Column(
      children: [
        Text(program.title),
        ElevatedButton(
          onPressed: () {
            provider.completeProgram(program.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Completed!'))
            );
          },
          child: Text('Mark as Complete'),
        ),
      ],
    );
  },
)
```

---

### ProfilePage (lib/page/main/profile.dart)
- [ ] Import `package:provider/provider.dart`
- [ ] Import `package:runmates/providers/auth_provider.dart`
- [ ] Display user info dari `authProvider.user`
- [ ] Implement logout button
- [ ] Call `context.read<AuthProvider>().logout()`
- [ ] Redirect ke LoginScreen setelah logout
- [ ] Test: Verify user info displays & logout works

```dart
// Quick snippet to add:
Consumer<AuthProvider>(
  builder: (context, auth, _) {
    if (!auth.isAuthenticated) {
      return Text('Not logged in');
    }
    
    return Column(
      children: [
        Text('Name: ${auth.user?.name}'),
        Text('Email: ${auth.user?.email}'),
        ElevatedButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const LoginScreen())
            );
          },
          child: Text('Logout'),
        ),
      ],
    );
  },
)
```

---

## 🔄 PHASE 2: API Integration (RECOMMENDED)

### Update AuthProvider
- [ ] Install `http` atau `dio` package
- [ ] Replace `Future.delayed()` dengan real API calls
- [ ] Add proper error handling
- [ ] Add retry logic
- [ ] Test: Login/signup dengan real API

### Update ProgramProvider
- [ ] Connect to real API endpoint
- [ ] Implement pagination (if needed)
- [ ] Add data caching with local storage
- [ ] Handle network errors gracefully
- [ ] Test: Programs fetch from API

---

## 💾 PHASE 3: Local Storage (OPTIONAL)

### User Session Persistence
- [ ] Add `shared_preferences` package
- [ ] Save user token after login
- [ ] Restore session on app restart
- [ ] Clear session on logout

### Program Data Caching
- [ ] Add `hive` package
- [ ] Cache program data locally
- [ ] Sync with API periodically
- [ ] Show cached data while fetching

---

## 🧪 PHASE 4: Testing (BEFORE PRODUCTION)

### Unit Tests
- [ ] Test AuthProvider.login()
- [ ] Test AuthProvider.signup()
- [ ] Test AuthProvider.logout()
- [ ] Test ProgramProvider methods

### Widget Tests
- [ ] Test SignIn page integration
- [ ] Test HomePage data display
- [ ] Test ProfilePage logout

### Integration Tests
- [ ] Test complete login flow
- [ ] Test navigation between pages
- [ ] Test data persistence

---

## ✅ FINAL VERIFICATION CHECKLIST

### Code Quality
- [ ] No compiler errors
- [ ] No lint warnings
- [ ] Code formatted properly
- [ ] Comments added where needed

### Functionality
- [ ] Login works
- [ ] Signup works
- [ ] Navigation works
- [ ] Data displays correctly
- [ ] Logout works
- [ ] Error handling works

### UI/UX
- [ ] Loading states shown
- [ ] Error messages displayed
- [ ] Empty states handled
- [ ] No jank or lag
- [ ] Responsive design

### Performance
- [ ] App starts quickly
- [ ] Pages load smoothly
- [ ] No memory leaks
- [ ] No unnecessary rebuilds

---

## 📊 Progress Tracking

### Overall Progress
```
Phase 1: Core Integration
├─ SignIn: ____%
├─ SignUp: ____%
├─ HomePage: ____%
├─ ProgramWeekPage: ____%
└─ ProfilePage: ____%

Phase 2: API Integration
├─ Auth API: ____%
├─ Program API: ____%
└─ Error Handling: ____%

Phase 3: Local Storage
├─ Session Save: ____%
├─ Data Cache: ____%
└─ Sync Logic: ____%

Phase 4: Testing
├─ Unit Tests: ____%
├─ Widget Tests: ____%
└─ Integration Tests: ____%

Overall: ____%
```

---

## 🚨 Common Issues & Solutions

### Issue: "Provider not found in scope"
**Solution:** Make sure MultiProvider is in main.dart with all 4 providers

### Issue: "Widget not rebuilding when provider changes"
**Solution:** Use Consumer<Provider> or context.watch<Provider>()

### Issue: "Build failed after adding provider"
**Solution:** Run `flutter pub get` & `flutter clean`

### Issue: "Too many rebuilds"
**Solution:** Use Selector instead of Consumer to listen specific properties

### Issue: "Can't access provider in initState"
**Solution:** Use WidgetsBinding.instance.addPostFrameCallback()

---

## 📞 Need Help?

1. Check: `STATE_MANAGEMENT_GUIDE.md`
2. Check: `PROVIDER_QUICK_START.md`
3. Check: Example files in `lib/page/`
4. Read: Official Provider docs (https://pub.dev/packages/provider)

---

## 🎯 Remember

✓ Take it step by step
✓ Test after each change
✓ Use the examples as reference
✓ Read the documentation
✓ Don't skip the error handling
✓ Your code will be better than before!

**Happy Coding! 🚀**
