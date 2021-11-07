# Домашнее задание к занятию «2.4. Инструменты Git»

Задача №1
---------
*Найдите полный хеш и комментарий коммита, хеш которого начинается на* `aefea`*.*

**git show aefea --pretty=format:"Hash: %H%nSubject: %s" --no-patch**

*Ответ*
```
Hash: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Subject: Update CHANGELOG.md
```

Задача №2
---------
*Какому тегу соответствует коммит* `85024d3`*?*

**git show 85024d3 --oneline --no-patch**

*Ответ*
```
85024d310 (tag: v0.12.23) v0.12.23
```

Задача №3
---------
*Сколько родителей у коммита* `b8d720`*? Напишите их хеши.*

**git show b8d720 --pretty=format:%p --no-patch**

*Ответ*
Два родителя
```
56cd7859e 9ea88f22f
```

Задача №4
---------
*Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами*  `v0.12.23` *и* `v0.12.24` *.*

**git log -s --oneline v0.12.23..v0.12.24**

*Ответ*
```
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```
*Или*

**git log v0.12.23..v0.12.24 --pretty=format:"Hash: %h%nSubject: %s%n" --no-patch**

*Ответ*
```
Hash: 33ff1c03b
Subject: v0.12.24

Hash: b14b74c49
Subject: [Website] vmc provider links

Hash: 3f235065b
Subject: Update CHANGELOG.md

Hash: 6ae64e247
Subject: registry: Fix panic when server is unreachable

Hash: 5c619ca1b
Subject: website: Remove links to the getting started guide's old location

Hash: 06275647e
Subject: Update CHANGELOG.md

Hash: d5f9411f5
Subject: command: Fix bug when using terraform login on Windows
```

Задача №5
---------
*Найдите коммит в котором была создана функция* `func providerSource` *, ее определение в коде выглядит* 
*так* `func providerSource(...)` *(вместо троеточего перечислены аргументы).*

**git log --oneline -S"func providerSource("**

*Ответ*
```
8c928e835 main: Consult local directories as potential mirrors of providers
```

Задача №6
---------
*Найдите все коммиты в которых была изменена функция* `globalPluginDirs`*.*

Чтобы не разбирать лишние строки, сразу предположим, что функция должна содержать в имени `func globalPluginDirs(`

**git grep "func globalPluginDirs("**

```
plugins.go:func globalPluginDirs() []string {
```

**git log -L:globalPluginDirs:plugins.go --oneline --no-patch**

*Ответ*
```
78b122055 Remove config.go and update things using its aliases
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package
```

Задача №7
---------
*Кто автор функции* `synchronizedWriters`*?*


**git log -S"synchronizedWriters" --pretty="%h Author:%aN"**

```
bdfea50cc Author:James Bardin
fd4f7eb0b Author:James Bardin
5ac311e2a Author:Martin Atkins
```

*Ответ*

```
Martin Atkins
```

