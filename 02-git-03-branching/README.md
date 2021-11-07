# Домашнее задание к занятию «2.3. Ветвления в Git»
## Задание №1 – Ветвление, merge и rebase.

## _**Краткий список действий и команд.**_

Делаем файлы
```
git add .
git connit -S -m "prepare for merge and rebase"
git push -u origin main
```
**Подготовка файла merge.sh.**
```shell
git switch -c git-merge
```
Изменяем merge.sh
```shell
git add .
git commit -S -m "merge: @ instead *"
git push -u origin git-merge
```
Еще меняем merge.sh
```
git add .
git commit -S -m "merge: use shift"
git push -u origin git-merge
```
**Изменим main.**

```
git switch main
```
Изменяем rebase.sh
```
git add .
git commit -s -m "change rebase.sh to main"
git push -u origin main
```

**Подготовка файла rebase.sh.**

```
git log --grep 'prepare for merge and rebase'
git checkout f7db983
git switch -c git-rebase
```
Изменим rebase.sh
```
git add .
git commit -S -m "git-rebase 1"
git push -u origin git-rebase
```
Изменим rebase.sh еще раз
```
git add .
git commit -S -m "git-rebase 2"
git push -u origin git-rebase
```

**Merge**
```
git switch main
git merge git-merge
git push
```
**Rebase**
```
git switch git-rebase
git rebase -i main
```
Изменяем rebase.sh
```
git add 02-git-03-branching/rebase.sh
git rebase --continue
```
Изменяем rebase.sh
```
git add 02-git-03-branching/rebase.sh
git rebase --continue
```
Создаем комментарий объединенному комиту.
```
git push -u origin git-rebase
git push -u origin git-rebase -f
git switch main
git merge git-rebase
git push -u origin
```
