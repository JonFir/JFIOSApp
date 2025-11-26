# 🎨 Design System - Fitness App

Руководство по использованию дизайн-системы приложения для фитнеса.

## 📦 Содержание

- [Цветовая палитра](#цветовая-палитра)
- [Компоненты](#компоненты)
- [Примеры использования](#примеры-использования)
- [Рекомендации](#рекомендации)

---

## 🎨 Цветовая палитра

### Быстрый старт

```swift
import SwiftUI

// Основные цвета
.foregroundColor(.appPrimaryRed)      // Основной красный
.foregroundColor(.appSecondaryRed)    // Темнее красный
.foregroundColor(.appAccentLight)     // Светлый акцент

// Текст
.foregroundColor(.appTextPrimary)     // Основной текст (белый)
.foregroundColor(.appTextSecondary)   // Второстепенный (прозрачный)

// UI элементы
.background(.appInputBackground)      // Фон полей ввода
.stroke(.appBorderColor)              // Рамки
.foregroundColor(.appErrorRed)        // Ошибки

// Градиенты
.background(Color.appPrimaryGradient)      // Красный градиент для кнопок
.background(Color.appBackgroundGradient)   // Фоновый градиент
.foregroundStyle(Color.appFlameGradient)   // Градиент для иконок
```

### Полная документация

См. [Assets README](LLIos/App/Resources/Assets.xcassets/README.md)

---

## 🧩 Компоненты

### 1. AppTextField - Поля ввода

Стандартизированное поле ввода с лейблом и стилем приложения.

```swift
import SwiftUI

// Простое поле
AppTextField(
    title: "Email",
    text: $email
)

// С placeholder и типом клавиатуры
AppTextField(
    title: "Email",
    text: $email,
    placeholder: "your@email.com",
    keyboardType: .emailAddress
)

// Поле пароля
AppTextField(
    title: "Password",
    text: $password,
    isSecure: true
)

// Заблокированное поле
AppTextField(
    title: "Username",
    text: $username,
    isDisabled: true
)
```

### 2. AppButton - Кнопки

Три стиля кнопок для разных целей.

```swift
import SwiftUI

// Primary - основная кнопка действия
Button("Start Training") {
    startTraining()
}
.buttonStyle(AppButtonStyle.primary)

// Secondary - второстепенная кнопка
Button("Skip") {
    skip()
}
.buttonStyle(AppButtonStyle.secondary)

// Destructive - для опасных действий
Button("Delete Account") {
    deleteAccount()
}
.buttonStyle(AppButtonStyle.destructive)
```

---

## 💡 Примеры использования

### Экран с формой

```swift
struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.appBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Заголовок
                Text("JOIN THE CHALLENGE")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.appTextPrimary)
                    .tracking(2)
                
                // Форма
                VStack(spacing: 16) {
                    AppTextField(
                        title: "Name",
                        text: $name,
                        placeholder: "Your name"
                    )
                    
                    AppTextField(
                        title: "Email",
                        text: $email,
                        keyboardType: .emailAddress
                    )
                    
                    AppTextField(
                        title: "Password",
                        text: $password,
                        isSecure: true
                    )
                }
                
                // Кнопка
                Button("Create Account") {
                    createAccount()
                }
                .buttonStyle(AppButtonStyle.primary)
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .padding(.top, 60)
        }
    }
}
```

### Карточка тренировки

```swift
struct WorkoutCard: View {
    let title: String
    let duration: String
    let calories: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Заголовок
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.appTextPrimary)
            
            // Метрики
            HStack(spacing: 16) {
                Label(duration, systemImage: "clock")
                Label("\(calories) kcal", systemImage: "flame.fill")
            }
            .font(.system(size: 14))
            .foregroundColor(.appTextSecondary)
            
            // Кнопка
            Button("Start") {
                startWorkout()
            }
            .buttonStyle(AppButtonStyle.primary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.appInputBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.appBorderColor, lineWidth: 1)
                )
        )
    }
}
```

### Заголовок с иконкой

```swift
struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.appFlameGradient)
                .shadow(color: .appShadowRed, radius: 20)
            
            Text("PUSH YOUR LIMITS")
                .font(.system(size: 28, weight: .black))
                .foregroundColor(.appTextPrimary)
                .tracking(2)
            
            Text("Train. Push. Conquer.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.appTextSecondary)
                .tracking(1)
        }
    }
}
```

### Сообщение об ошибке

```swift
struct ErrorView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14))
            Text(message)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(.appErrorRed)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.appErrorRed.opacity(0.1))
        )
    }
}
```

---

## 📋 Рекомендации

### ✅ Делайте

1. **Используйте семантические цвета**
   ```swift
   // Хорошо
   .foregroundColor(.appTextPrimary)
   
   // Плохо
   .foregroundColor(.white)
   ```

2. **Используйте готовые компоненты**
   ```swift
   // Хорошо
   AppTextField(title: "Email", text: $email)
   
   // Плохо - дублирование кода
   TextField("Email", text: $email)
       .padding()
       .background(...)
   ```

3. **Используйте предопределенные градиенты**
   ```swift
   // Хорошо
   .background(Color.appPrimaryGradient)
   
   // Плохо
   .background(
       LinearGradient(
           colors: [Color(red: 1.0, green: 0.3...), ...],
           ...
       )
   )
   ```

4. **Добавляйте эффекты для важных элементов**
   ```swift
   Button("Action") { }
       .buttonStyle(AppButtonStyle.primary)
       // Тень добавляется автоматически в стиле
   ```

### ❌ Не делайте

1. **Не используйте хардкод цветов**
   ```swift
   // Плохо
   .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.2))
   
   // Хорошо
   .foregroundColor(.appPrimaryRed)
   ```

2. **Не создавайте кастомные стили без необходимости**
   - Используйте `AppButtonStyle` для всех кнопок
   - Используйте `AppTextField` для всех полей ввода

3. **Не игнорируйте disabled состояния**
   ```swift
   // Хорошо
   Button("Login") { login() }
       .buttonStyle(AppButtonStyle.primary)
       .disabled(isLoading)
   ```

### 🎯 Типографика

```swift
// Заголовки
.font(.system(size: 28, weight: .black))
.tracking(2)  // Широкий tracking для заголовков

// Подзаголовки
.font(.system(size: 14, weight: .medium))
.tracking(1)

// Кнопки
.font(.system(size: 16, weight: .bold))
.tracking(1.5)

// Лейблы полей
.font(.system(size: 12, weight: .semibold))
.textCase(.uppercase)
.tracking(1)

// Основной текст
.font(.system(size: 15))
```

### 🌟 Эффекты

```swift
// Тень для кнопок
.shadow(color: .appShadowRed, radius: 15, y: 5)

// Свечение для иконок
.shadow(color: .appShadowRed, radius: 20)

// Анимация нажатия
.scaleEffect(isPressed ? 0.97 : 1.0)
.opacity(isPressed ? 0.9 : 1.0)
.animation(.easeInOut(duration: 0.1), value: isPressed)
```

---

## 🚀 Начало работы

1. Импортируйте необходимые модули:
   ```swift
   import SwiftUI
   ```

2. Используйте готовые компоненты:
   ```swift
   AppTextField(title: "Email", text: $email)
   ```

3. Применяйте цветовую палитру:
   ```swift
   .foregroundColor(.appTextPrimary)
   .background(Color.appPrimaryGradient)
   ```

4. Следуйте рекомендациям из этого документа

---

## 📚 Дополнительные ресурсы

- [Color Palette Documentation](LLIos/App/Resources/Assets.xcassets/README.md)
- Примеры: `LLIos/UILogin/Impl/UILoginView.swift`

---

**Философия дизайна**: Энергия 🔥 • Сила 💪 • Мотивация 🎯

Создавайте интерфейсы, которые вдохновляют пользователей на достижения!

