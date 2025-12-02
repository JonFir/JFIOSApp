# 🎨 Design System - Fitness App

Руководство по использованию дизайн-системы приложения для фитнеса.

## 📦 Содержание

- [Цветовая палитра](#цветовая-палитра)
- [Компоненты](#компоненты)
- [Рекомендации](#рекомендации)

---

## 🎨 Цветовая палитра

### Быстрый старт

```swift
// Основные цвета
ResourcesAsset.primaryRed.swiftUIColor      // Основной красный
ResourcesAsset.secondaryRed.swiftUIColor    // Темнее красный
ResourcesAsset.accentLight.swiftUIColor     // Светлый акцент

// Текст
ResourcesAsset.textPrimary.swiftUIColor     // Основной текст (белый)
ResourcesAsset.textSecondary.swiftUIColor   // Второстепенный (прозрачный)

// Фон
ResourcesAsset.backgroundDark.swiftUIColor       // Основной фон
ResourcesAsset.inputBackground.swiftUIColor      // Фон полей ввода

// UI элементы
ResourcesAsset.borderColor.swiftUIColor          // Рамки
ResourcesAsset.errorRed.swiftUIColor             // Ошибки
ResourcesAsset.shadowRed.swiftUIColor            // Тени и свечение
```

### Полная документация

См. [Resources README](../LLIos/Resources/README.md)

---

## 🧩 Компоненты

### 1. DefaultTextField - Поля ввода

Стандартизированное поле ввода с лейблом.

```swift
DefaultTextField(title: "Email", text: $email)
DefaultTextField(title: "Password", isSecure: true, text: $password)
```

📄 [DefaultTextField.swift](../LLIos/UIComponents/Api/DefaultTextField.swift)

---

### 2. PrimaryButtonStyle - Основная кнопка

Стиль для основной кнопки с красным градиентом.

```swift
Button("Login") { login() }
    .buttonStyle(.primary)
```

📄 [PrimaryButtonStyle.swift](../LLIos/UIComponents/Api/PrimaryButtonStyle.swift)

---

### 3. InlineButtonStyle - Текстовая кнопка

Стиль для второстепенных кнопок без фона.

```swift
Button("Forgot Password?") { forgotPassword() }
    .buttonStyle(.inline)
```

📄 [InlineButtonStyle.swift](../LLIos/UIComponents/Api/InlineButtonStyle.swift)

---

### 4. InlineErrorView - Сообщения об ошибках

Компонент для отображения ошибок.

```swift
InlineErrorView(message: "Invalid credentials")
InlineErrorView(message: "Error", description: "Details here")
```

📄 [InlineErrorView.swift](../LLIos/UIComponents/Api/InlineErrorView.swift)

---

### 5. BackgroundGradient - Градиентный фон

Градиент для фона экранов.

```swift
VStack { /* контент */ }
    .backgroundGradient()
```

📄 [BackgroundGradient.swift](../LLIos/UIComponents/Api/BackgroundGradient.swift)

---

### 6. TextStyle - Стили текста

Протокол для переиспользуемых стилей текста.

```swift
Text("LOGIN").textStyle(.primaryButton)
Text("Skip").textStyle(.inlineButton)
```

📄 [TextStyle.swift](../LLIos/UIComponents/Api/TextStyle.swift)

---

## 📋 Рекомендации

### ✅ Делайте

1. **Используйте цвета через ResourcesAsset**
   ```swift
   // ✅ Хорошо
   .foregroundColor(ResourcesAsset.textPrimary.swiftUIColor)
   
   // ❌ Плохо
   .foregroundColor(.white)
   ```

2. **Используйте готовые компоненты**
   ```swift
   // ✅ Хорошо
   DefaultTextField(title: "Email", text: $email)
   
   // ❌ Плохо
   TextField("Email", text: $email).padding().background(...)
   ```

3. **Используйте стили кнопок**
   ```swift
   // ✅ Хорошо
   Button("Login") { }.buttonStyle(.primary)
   
   // ❌ Плохо
   Button("Login") { }.background(Color.red)
   ```

4. **Используйте backgroundGradient() для фона**
   ```swift
   // ✅ Хорошо
   VStack { }.backgroundGradient()
   
   // ❌ Плохо
   VStack { }.background(Color.black)
   ```

### ❌ Не делайте

1. **Не используйте хардкод цветов**
   ```swift
   // ❌ Плохо
   .foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.2))
   
   // ✅ Хорошо
   .foregroundColor(ResourcesAsset.primaryRed.swiftUIColor)
   ```

2. **Не создавайте кастомные компоненты без необходимости**
   - Используйте `DefaultTextField` для полей ввода
   - Используйте `.primary` или `.inline` для кнопок
   - Используйте `InlineErrorView` для ошибок

3. **Не игнорируйте disabled состояния**
   ```swift
   Button("Login") { }.buttonStyle(.primary).disabled(isLoading)
   ```

### 🎯 Типографика

| Элемент | Стиль |
|---------|-------|
| Заголовки | `.font(.system(size: 28, weight: .black)).tracking(2)` |
| Подзаголовки | `.font(.system(size: 14, weight: .medium)).tracking(1)` |
| Кнопки | Используйте `.textStyle(.primaryButton)` или `.textStyle(.inlineButton)` |
| Лейблы полей | `.font(.system(size: 12, weight: .semibold)).textCase(.uppercase).tracking(1)` |
| Основной текст | `.font(.system(size: 15))` |

### 🌟 Эффекты

```swift
// Тень для кнопок (встроена в .primary)
.shadow(color: ResourcesAsset.shadowRed.swiftUIColor, radius: 15, y: 5)

// Свечение для иконок
.shadow(color: ResourcesAsset.shadowRed.swiftUIColor, radius: 20)
```

---

## 📚 Дополнительные ресурсы

- [Color Palette Documentation](../LLIos/Resources/README.md)
- [UI Components](../LLIos/UIComponents/Api)
- Примеры использования: `LLIos/UILogin/Impl/UILoginView.swift`, `LLIos/UIRegistration/Impl/UIRegistrationView.swift`

---

**Философия дизайна**: Энергия 🔥 • Сила 💪 • Мотивация 🎯

Создавайте интерфейсы, которые вдохновляют пользователей на достижения!

