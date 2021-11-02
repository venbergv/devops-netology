#Домашнее задание к занятию «2.2. Основы Git»


##Задание №1 – Знакомимся с gitlab и bitbucket
 
    1. Подключены все удаленные репозитории по https и ssh.

	'git remote -v'
	'bitbucket	git@bitbucket.org:vitaly-grebnev/devops-netology.git (fetch)'
	'bitbucket	git@bitbucket.org:vitaly-grebnev/devops-netology.git (push)'
	'bitbucket-https	https://bitbucket.org/vitaly-grebnev/devops-netology.git (fetch)'
	'bitbucket-https	https://bitbucket.org/vitaly-grebnev/devops-netology.git (push)'
	'github-https	https://github.com/vitaly-grebnev/devops-netology.git (fetch)'
	'github-https	https://github.com/vitaly-grebnev/devops-netology.git (push)'
	'gitlab	git@gitlab.com:vitaly-grebnev/devops-netology.git (fetch)'
	'gitlab	git@gitlab.com:vitaly-grebnev/devops-netology.git (push)'
	'gitlab-https	https://gitlab.com/vitaly-grebnev/devops-netology.git (fetch)'
	'gitlab-https	https://gitlab.com/vitaly-grebnev/devops-netology.git (push)'
	'origin	git@github.com:vitaly-grebnev/devops-netology.git (fetch)'
	'origin	git@github.com:vitaly-grebnev/devops-netology.git (push)'

    2. Выполнен push локальной ветки main.

	'git push -u gitlab main'
	'git push -u bitbucket main'

##Задание №2 – Теги

    1. Добавлен лекговесный тэг 'v0.0' и аннотированный тэг 'v0.1'
    2. Обновлены ветки 'main' для 'gitlab' и 'bitbucket', с добавленными тегами.
    

##Задание №3 – Ветки

    1. Создана ветка 'fix' на основе коммита 'aec8c0c' 'Prepare to delete and move'.
    2. Отправлена новая ветка в репозиторий на 'github' 'git push -u origin fix'.
    3. Внесены изменения в файл '/02-git-02-base/README.md'.
    4. Отправлены изменения в репозиторий 'github'.


##Задание №4 – Упрощаем себе жизнь

    1.Внесены изменения в файл '/02-git-02-base/README.md' из под PyCharm.
    2. Отправлены изменения в репозиторий 'gitlub' из под PyCharm
