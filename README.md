# devops-sf_sp1
Разворачиваем инфраструктуру в яндекс облаке:

1.Клонируем проект
------------------
$ git clone https://github.com/SergeyMedzhidov/devops-sf_sp1
$ cd devops-sf_sp1

2.Генерируем ключи и копируем в каталог проекта
-----------------------------------------------
$ ssh-keygen -t rsa
$ cp ~/.ssh/id_rsa* ./

3.Правим реквизиты Yandex Cloud в файле terraform/main.tf
---------------------------------------------------------
$ cd terraform 
$ terraform init 
$ terraform apply

4.Запускаем плейбуки для настройки кластера k8s
-----------------------------------------------
$ cd ../ansible 
$ ansible-playbook -i hosts users.yml
$ ansible-playbook -i hosts install-k8s.yml
$ ansible-playbook -i hosts master.yml
$ ansible-playbook -i hosts join-workers.yml
$ ansible-playbook -i hosts finish.yml
