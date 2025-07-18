# 10-Level Ability Game

Простая платформер-игра на движке [Love2D](https://love2d.org/), в которой на каждом из 10 уровней вы открываете новую способность.

## Запуск

1. Установите Love2D (рекомендованная версия — 11.3 или новее).
2. Распакуйте этот репозиторий в любую папку.
3. **Windows:** дважды кликните `start.bat`.  
   **Linux/macOS:** в терминале перейдите в папку проекта и выполните:
   ```bash
   love .

## Управление

* **Влево/вправо** — движение
* **Пробел** — прыжок
* **Способности** (открываются по мере прохождения уровней):

  * **Double Jump** — второй прыжок в воздухе (ещё один пробел)
  * **Dash** — рывок (удержать Left Shift)
  * **Wall Jump** — отталкивание от стены при касании
  * **Glide** — планирование (удерживать пробел при падении)
  * **Push** — толкать ящики (подойти и двигаться)
  * **Shield** — щит на 2 секунды (клавиша S)
  * **Teleport** — телепорт к курсору (клавиша T)
  * **Speed** — +50% к скорости передвижения
  * **Ground Pound** — удар о землю (удерживать ↓ в воздухе)

## Структура проекта

```
├── main.lua           # точка входа, загрузка ресурсов и стэйтов
├── gamestate.lua      # простой менеджер игровых состояний
├── levels.lua         # описание 10 уровней (платформы, флаги, ящики, турели)
├── player.lua         # логика игрока и его способностей
├── box.lua            # поведение ящиков
├── turret.lua         # поведение турелей
├── utils.lua          # вспомогательные функции
├── start.bat          # скрипт запуска для Windows
└── assets/
    ├── tiles/         # тайловый фон
    ├── sprites/       # спрайты игрока, флага, ящика
    └── fonts/         # шрифт DejaVu Sans
└── states/
    ├── menu.lua       # главное меню
    ├── game.lua       # игровой процесс
    └── win.lua        # экран победы
```
