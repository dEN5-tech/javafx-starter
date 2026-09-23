# 📝 Практическая работа: Разработка ToDo приложения на JavaFX (ListView, ObservableList и Scene Builder)

> **Дисциплина:** Разработка прикладных приложений (МДК.02.04)  
> **Группа:** 401 (4 курс)  
> **Стек технологий:** Java 17+, JavaFX, Scene Builder 18, VS Code / VSCodium  

---

## 📖 1. Теоретические сведения: Работа со списками в JavaFX

### Класс `ListView<T>`
Класс `javafx.scene.control.ListView<T>` предназначен для отображения прокручиваемого списка элементов.  
`ListView` является обобщенным типом (Generic). В нашем приложении для отображения списка задач мы типизируем его строками: `ListView<String>`.

---

### Динамическое изменение данных через `ObservableList<T>`
В JavaFX графический компонент `ListView` не хранит данные самостоятельно, а связывается с коллекцией-наблюдателем — `ObservableList<T>`.

Для создания и привязки коллекции используется фабричный метод `FXCollections.observableArrayList()`:

```java
// 1. Создаем коллекцию-наблюдатель
private ObservableList<String> items = FXCollections.observableArrayList();

// 2. В методе initialize() привязываем коллекцию к графическому списку
taskListView.setItems(items);
```

> 💡 **Как это работает:**  
> После вызова `setItems(items)` любые изменения в коллекции (`items.add(...)`, `items.remove(...)`, `items.clear()`) **мгновенно и автоматически отображаются в окне приложения** без необходимости вручную перерисовывать интерфейс!

---

### Получение выбранного элемента (`SelectionModel`)
Для работы с элементом, который пользователь выделил мышкой в списке, используется модель выбора `MultipleSelectionModel`:

```java
// Получение значения выделенной строки (или null, если ничего не выбрано)
String selected = taskListView.getSelectionModel().getSelectedItem();

if (selected != null) {
    items.remove(selected); // Удаление задачи из коллекции
}
```

---

## 🎨 2. Разработка интерфейса в Scene Builder (`MainView.fxml`)

Откройте файл макета `src/com/example/MainView.fxml` в Scene Builder (или через `open-scenebuilder.bat`) и добавьте элементы:

| Элемент UI | Назначение | `fx:id` в Scene Builder | Обработчик `On Action` |
| :--- | :--- | :--- | :--- |
| **TextField** | Поле ввода текста новой задачи | `taskInput` | — |
| **Button** («Добавить») | Добавление задачи в список | — | `#onAddClick` |
| **ListView** | Компонент отображения списка задач | `taskListView` | — |
| **Button** («Удалить») | Удаление выделенной задачи | — | `#onDeleteClick` |
| **Button** («Очистить все») | Полная очистка списка | — | `#onClearClick` |

> 📌 **Важно:** Не забудьте указать `promptText="Введите новую задачу..."` у поля `taskInput`.  
> Сохраните файл в Scene Builder (`Ctrl + S`). Расширение auto-sync автоматически создаст заготовки полей и методов в контроллере!

---

## 💻 3. Полный код контроллера (`MainController.java`)

Откройте `src/com/example/MainController.java` и реализуйте логику работы со списком:

```java
package com.example;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;

public class MainController {

    // --- 1. Элементы интерфейса (FXML) ---
    @FXML
    private TextField taskInput;

    @FXML
    private ListView<String> taskListView;

    // --- 2. Источник данных (Коллекция задач) ---
    private ObservableList<String> items = FXCollections.observableArrayList();

    // --- 3. Инициализация (вызывается автоматически при старте) ---
    @FXML
    public void initialize() {
        // Привязываем коллекцию к ListView
        taskListView.setItems(items);
    }

    // --- 4. Обработчики событий ---

    /**
     * Добавление новой задачи в список
     */
    @FXML
    void onAddClick(ActionEvent event) {
        String text = taskInput.getText();

        // Валидация: защита от пустых строк и строк из одних пробелов
        if (text != null && !text.trim().isEmpty()) {
            items.add(text.trim());
            taskInput.clear(); // Очищаем поле ввода для следующей задачи
        }
    }

    /**
     * Удаление выбранной задачи из списка
     */
    @FXML
    void onDeleteClick(ActionEvent event) {
        String selected = taskListView.getSelectionModel().getSelectedItem();
        
        // Удаляем только если элемент действительно был выделен
        if (selected != null) {
            items.remove(selected);
        }
    }

    /**
     * Полная очистка всего списка задач
     */
    @FXML
    void onClearClick(ActionEvent event) {
        items.clear();
    }
}
```

---

## 🛡️ 4. Требования к валидации и поведению программы

1. **Защита от пустых задач:**
   - Если поле ввода пустое или состоит только из пробелов (`text.trim().isEmpty()`), нажатие кнопки «Добавить» **не должно** добавлять пустую строку в список.
2. **Безопасное удаление:**
   - Если пользователь нажал кнопку «Удалить», не выделив предварительно ни одной задачи в `ListView`, программа **не должна падать с ошибкой** (проверка `if (selected != null)` обязательна).
3. **Очистка поля ввода:**
   - Сразу после успешного добавления поле `taskInput` очищается методом `taskInput.clear()`, чтобы пользователю было удобно вводить следующую задачу.

---

## 🚀 5. Запуск и демонстрация работы

1. Запустите проект в VSCodium: откройте `src/com/example/App.java` и нажмите зеленый треугольник **Run ▶** (или выполните `run.bat`).
2. **Чек-лист для сдачи работы преподавателю на паре:**
   - [ ] Добавьте 3-4 различные задачи (например: *«Сдать практическую»*, *«Повторить FXML»*, *«Написать отчет»*).
   - [ ] Попробуйте нажать кнопку «Добавить» с пустым полем — пустые элементы не должны появляться.
   - [ ] Выделите задачу мышкой и нажмите «Удалить» — задача должна исчезнуть из списка.
   - [ ] Нажмите «Очистить все» — список должен полностью опустошиться.
