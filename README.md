# Docker-swarm-D1-HW-03

ЗАДАНИЕ ДЛЯ САМОСТОЯТЕЛЬНОЙ РАБОТЫ (HW-03)

Описание:

Мы продолжаем развивать наш интернет-магазин по продаже носков. В этом задании мы посмотрим, как Docker Swarm работает в облаке. Для этого мы создадим несколько серверов в Yandex.Cloud, установим туда Docker, объединим эти инстансы в кластер и задеплоим туда наш интернет-магазин по продаже носков.
После успешной инсталляции необходимо зайти по выделенному IP и убедиться, что наш проект доступен извне через браузер.
Для выполнения задания нужно использовать конфигурацию для Docker Compose из предыдущего задания. Некоторые директивы нужно модифицировать таким образом, чтобы сервисы запустились без ошибок в новом swarm-кластере.
Все инструкции по выполнению этого задания выполнены с помощью Terraform. Если у вас возникают сложности с выполнением, вы можете посмотреть решение. Можно выполнять задание любым удобным способом.

Задание:
1. Подготовить аккаунт в Yandex.Cloud.
2. Создать три инстанса в Yandex.Cloud:
  - Объединить их в сеть.
  - Добавить внешний IP для доступа к проекту через браузер.
3. Создать Docker Swarm кластер с одной управляющей нодой и двумя worker-нодами.
4. Задеплоить в swarm-кластер исправленный файл docker-compose.yml.
5. Проверить в браузере, что проект работает.
6. Масштабировать frontend-сервис до двух реплик.
7. Для проверки задания необходимо отправить:
  - Описание — каким образом и какие команды использовались для решения задания.
  - Скриншот страницы в браузере (главной страницы проекта, работающего в Yandex.Cloud).
  - Вывод команды docker service ls.
  - Вывод команды docker node ls.
8. Погасить проект.



ИТОГОВОЕ ЗАДАНИЕ (HW-03)

Развернуть пример реализации микросервисов на основе готового репозитория на GitHub

Описание:

Для зачета по итоговому заданию модуля достаточно предоставить GitHub-репозиторий с работающим решением по развертыванию интернет-магазина носков в одном из публичных провайдеров. Для Yandex.Сloud это может быть Swarm или Nomad, для Amazon — это ECS.
Кроме репозитория необходимо предоставить скриншоты работающего интернет-магазина. На одном скриншоте должны быть видны интернет-магазин и адресная строка.
Описание инфраструктуры необходимо зафиксировать как код в одном из инструментов, который вам больше подходит. Это может быть Terraform, Cloudformation или что-то другое.
В приведенном репозитории присутствуют ошибки, поэтому вам нужно самостоятельно описать IaC или использовать код из репозитория для того чтобы создать работающий проект, который мы ранее запускали в Swarm.

Задание:

1. Описать через IaC интернет-магазин носков.
2. Развернуть проект.
3. Сделать скриншоты.
4. Предоставить доступ к репозиторию и скриншотам для проверки.

![1](https://user-images.githubusercontent.com/69116076/236702133-886de035-3096-4b61-a617-aa3080b86634.png)

![2](https://user-images.githubusercontent.com/69116076/236702137-2d034965-9a7e-49b0-86dd-c5520d06f8d8.png)

![3](https://user-images.githubusercontent.com/69116076/236702143-1092f201-219e-4a95-83bc-1fd97b9a026b.png)

![4](https://user-images.githubusercontent.com/69116076/236702151-cab7637a-63ee-4cfc-86b3-8ad514131989.png)

![5](https://user-images.githubusercontent.com/69116076/236702161-fd8131f2-d381-482d-9893-344faf22400f.png)

![6](https://user-images.githubusercontent.com/69116076/236702167-ef9314c1-e263-4559-8ca3-4de22a787ead.png)

![7](https://user-images.githubusercontent.com/69116076/236702171-82a0ad91-50c4-413c-ab2b-12e69f427da8.png)

![8](https://user-images.githubusercontent.com/69116076/236702177-46f3e9b0-df3b-4e34-b355-547a6e155d70.png)

![9](https://user-images.githubusercontent.com/69116076/236702186-d6709159-773f-486a-a1ef-4fe1c6fd55db.png)

![10](https://user-images.githubusercontent.com/69116076/236702192-dce9e06b-e2ef-4a63-9065-3f2ee8c06e9d.png)

