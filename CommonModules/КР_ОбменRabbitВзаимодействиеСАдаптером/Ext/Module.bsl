﻿
#Область ПрограммныйИнтерфейс

// Метод регламентного задания КР_ОбменRabbitИнтеграция
// Выполняет итерацию обмена данными с сервисом RabbitMQ.
// Базоый порядок действий:
//	1. Итерация переноса отработанных сообщений в архив сообщений
//	2. Подключение к сервису RabbitMQ
//	3. Выгрузака сообщений
//	4. Загрузка сообщений
//	5. Фиксация результатов итерации обмена
//
Процедура ОбменСообщениями(МассивКлючей = Неопределено) Экспорт
	
	// Сверяем с Истина, чтобы не контролировать установленное значение
	// для низкой версии платформы можно переделать на константу
	Если ПолучитьФункциональнуюОпцию("КР_ИспользуетсяИнтеграцияRabbitMQ") <> Истина Тогда
		Возврат;	
	КонецЕсли;

	// << 03.07.2024 Петухов А.В., Фактор, #4286
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.КР_ОбменRabbitИнтеграция);
	// >> 03.07.2024 Петухов А.В., Фактор, #4286
	
	// Оценка производительности
	ВремяНачала = ОценкаПроизводительности.НачатьЗамерВремени();
	КлючеваяОперация = "RabbitMQ.ОбменСообщениями";
	// Оценка производительности
	
	Если МассивКлючей = Неопределено Тогда 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ПеренестиСообщенияВАрхив();
	КонецЕсли;
	
	ИнтеграционнаяИнформация = НачатьИтерациюОбмена();
	Если ИнтеграционнаяИнформация = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Клиент = ПолучитьСоединениеСКлиентомОбмена(ИнтеграционнаяИнформация);
	Если Клиент = Неопределено Тогда
		
        ТекстСообщения = НСтр("ru='Исключительная ошибка запуска итерации обмена:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		ЗакончитьИтерациюОбмена(ИнтеграционнаяИнформация);
		
		// Оценка производительности
		ВесЗамера = 0;
		ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, ВесЗамера, , Истина);
		// Оценка производительности	
		
		Возврат;			
	КонецЕсли;	
	
	Попытка
	
		ВыгрузитьСообщенияВRabbit(Клиент, ИнтеграционнаяИнформация, МассивКлючей);
		
	Исключение
		ТекстСообщения = НСтр("ru='Исключительная ошибка выгрузки сообщений на итерации обмена:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		ЗакончитьИтерациюОбмена(ИнтеграционнаяИнформация);
		
		// Оценка производительности
		ВесЗамера = 0;
		ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, ВесЗамера, , Истина);
		// Оценка производительности
		
		Возврат;		
	КонецПопытки;
	
	Попытка
		
		Если МассивКлючей = Неопределено Тогда
			ЗагрузитьСообщенияИзRabbit(Клиент, ИнтеграционнаяИнформация);	
		КонецЕсли;
		
	Исключение
		ТекстСообщения = НСтр("ru='Исключительная ошибка загрузки сообщений на итерации обмена:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		ЗакончитьИтерациюОбмена(ИнтеграционнаяИнформация);
		
		// Оценка производительности
		ВесЗамера = 0;
		ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, ВесЗамера, , Истина);
		// Оценка производительности
		
		Возврат;
	КонецПопытки;
	
	ЗакончитьИтерациюОбмена(ИнтеграционнаяИнформация);
	
	Клиент = Неопределено;
	
	// Оценка производительности
	ВесЗамера = ИнтеграционнаяИнформация.ПолученоСообщений + ИнтеграционнаяИнформация.ОтправленоСообщений;
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, ВесЗамера, , ИнтеграционнаяИнформация.ЕстьОшибка); 
	// Оценка производительности
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Зафиксировать старт итерации обмена и получить данные текущей итерации
//
// Возвращаемое значение:
//   Структура   - данные текущей итерации обмена
//
Функция НачатьИтерациюОбмена()

	НачатьТранзакцию();
	Попытка
		
		// Блокируем целевой регистр интеграционной информации, чтобы в системе не было две интеграции в один момент времени
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КР_ИнтеграционнаяИнформация");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	КР_ИнтеграционнаяИнформация.КлючИнтеграции КАК КлючИнтеграции,
			|	ДОБАВИТЬКДАТЕ(КР_ИнтеграционнаяИнформация.ДатаНачала, МИНУТА, 20) КАК ДатаВозникновенияОшибки
			|ИЗ
			|	РегистрСведений.КР_ИнтеграционнаяИнформация КАК КР_ИнтеграционнаяИнформация
			|ГДЕ
			|	КР_ИнтеграционнаяИнформация.Статус = ЗНАЧЕНИЕ(Перечисление.КР_СтатусыИнтеграции.Выполняется)";		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			
			// контроль выполнения интеграции в текущий момент
			Если ВыборкаДетальныеЗаписи.ДатаВозникновенияОшибки > ТекущаяДатаСеанса() Тогда
				ОтменитьТранзакцию();
				ТекстСообщения = НСтр("ru='В данный момент уже происходит итерация интеграции через RabbitMQ. Повторный запуск невозможен.'");
				ЗаписьЖурналаРегистрации("RabbitMQ.Интеграция",УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);			
				
			Иначе
				// если интеграция выполняется больше 20 минут - это ошибка.
				// закрываем такую интеграцию и начинаем новую
				МенеджерЗаписи = РегистрыСведений.КР_ИнтеграционнаяИнформация.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.КлючИнтеграции = ВыборкаДетальныеЗаписи.КлючИнтеграции;
				МенеджерЗаписи.Прочитать();
				МенеджерЗаписи.Статус = Перечисления.КР_СтатусыИнтеграции.Ошибка;	
				МенеджерЗаписи.ДатаОкончания = ТекущаяДатаСеанса();
				МенеджерЗаписи.Логирование = МенеджерЗаписи.Логирование + символы.ПС + 
					НСтр("ru='Прервывание выполнения интеграции по истечению таймаута'");
				МенеджерЗаписи.Записать(Истина);
				ЗафиксироватьТранзакцию();
			КонецЕсли;			
			
			// в любом случае не продолжаем итерацию, если были висящие записи			
			Возврат Неопределено;
			
		КонецЕсли;		
		
		ИнтеграционнаяИнформация = Новый Структура;
		ИнтеграционнаяИнформация.Вставить("КлючИнтеграции", Строка(Новый УникальныйИдентификатор));	
		ИнтеграционнаяИнформация.Вставить("Логирование", "");
		ИнтеграционнаяИнформация.Вставить("ЕстьОшибка", Ложь);
		ИнтеграционнаяИнформация.Вставить("УточненноеСостояние", Неопределено);
		ИнтеграционнаяИнформация.Вставить("ДатаНачала", ТекущаяДатаСеанса());
		ИнтеграционнаяИнформация.Вставить("ДатаОкончания", Дата(1,1,1));
		ИнтеграционнаяИнформация.Вставить("Длительность", ТекущаяУниверсальнаяДатаВМиллисекундах());
		ИнтеграционнаяИнформация.Вставить("ПолученоСообщений", 0);
		ИнтеграционнаяИнформация.Вставить("ОтправленоСообщений", 0);
		ИнтеграционнаяИнформация.Вставить("КоличествоОшибок", 0);
		ИнтеграционнаяИнформация.Вставить("СобытиеЖурналаРегистрации", "RabbitMQ.ИнтеграционнаяИнформация");
// << 18.12.2023 Петухов А.В., Фактор, #3530
		ИнтеграционнаяИнформация.Вставить("ЕстьСообщенияОтСебя", Ложь);
// >> 18.12.2023 Петухов А.В., Фактор, #3530
				
		МенеджерЗаписи = РегистрыСведений.КР_ИнтеграционнаяИнформация.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ИнтеграционнаяИнформация);
		МенеджерЗаписи.Статус = Перечисления.КР_СтатусыИнтеграции.Выполняется;
		МенеджерЗаписи.Записать(Истина);
		
		ОшибочныеСообщения = Новый ТаблицаЗначений;
		ОшибочныеСообщения.Колонки.Добавить("ИмяОчереди");
		ОшибочныеСообщения.Колонки.Добавить("ВходящееСообщение");
		ОшибочныеСообщения.Колонки.Добавить("ТекстОшибки");
		ИнтеграционнаяИнформация.Вставить("ОшибочныеСообщения", ОшибочныеСообщения);
		
		ТекстСообщения = НСтр("ru='Старт итерации обмена'");
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
			
		ЗафиксироватьТранзакцию();	
			
		Возврат ИнтеграционнаяИнформация;
		
	Исключение		
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru='Исключительная ошибка запуска итерации обмена:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации("RabbitMQ.Интеграция",УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// Фиксация результатов итерации обмена
//
// Параметры:
//  ИнтеграционнаяИнформация  - Структура - структура данных об итерации обмена, 
//                 полученная в функции НачатьИтерациюОбмена()
//
Процедура ЗакончитьИтерациюОбмена(ИнтеграционнаяИнформация)

	НачатьТранзакцию();
	Попытка
		
		// Блокируем целевой регистр интеграционной информации, чтобы в системе не было две интеграции в один момент времени
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КР_ИнтеграционнаяИнформация");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ИнтеграционнаяИнформация.ДатаОкончания = ТекущаяДатаСеанса();
		ИнтеграционнаяИнформация.Длительность = ТекущаяУниверсальнаяДатаВМиллисекундах() - ИнтеграционнаяИнформация.Длительность;
		
		ТекстСообщения = НСтр("ru='Закончили все операции обмена. Фиксируем записи.'");
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
		
		МенеджерЗаписи = РегистрыСведений.КР_ИнтеграционнаяИнформация.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.КлючИнтеграции = ИнтеграционнаяИнформация.КлючИнтеграции;
		МенеджерЗаписи.Прочитать();		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ИнтеграционнаяИнформация, , "ОшибочныеСообщения");
		МенеджерЗаписи.ОшибочныеСообщения = Новый ХранилищеЗначения(ИнтеграционнаяИнформация.ОшибочныеСообщения, Новый СжатиеДанных(9));
		Если ИнтеграционнаяИнформация.ЕстьОшибка Тогда
			МенеджерЗаписи.Статус = Перечисления.КР_СтатусыИнтеграции.Ошибка;	
		Иначе
			МенеджерЗаписи.Статус = Перечисления.КР_СтатусыИнтеграции.Завершено;
		КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
		
		ЗафиксироватьТранзакцию();		
	
	Исключение		
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru='Исключительная ошибка завершения итерации обмена:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации("RabbitMQ.Интеграция",УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		
	КонецПопытки;	
	
КонецПроцедуры

#Область ВзаимодействиеСRabbit

Функция ПолучитьСоединениеСКлиентомОбмена(ИнтеграционнаяИнформация)

	ДанныеИБ = КР_ОбменRabbitОбщиеМеханизмыПовтИсп.ПолучитьТекущуюИнформационнуюБазу();
	НастройкиПодключения = КР_ОбменRabbitОбщиеМеханизмыПовтИсп.ПолучитьНастройкиПодключенияКRabbit(ДанныеИБ.Ссылка);
	
	ИнтеграционнаяИнформация.Вставить("ТекущаяИБ", ДанныеИБ.Ссылка);
	ИнтеграционнаяИнформация.Вставить("ТекущаяИБНаименование", ДанныеИБ.Наименование);
	ИнтеграционнаяИнформация.Вставить("НастройкиПодключения", НастройкиПодключения);
		
	Если НастройкиПодключения = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Не заданы настройки подключения для текущей ИБ'");
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Успешно прочитаны настройки подключения для ИБ %1'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, ДанныеИБ.Наименование);
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
	
    Попытка
		// Подключаем компоненту и создаем клиент
		ПодключитьВнешнююКомпоненту("ОбщийМакет.КР_КомпонентаОбменаRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native, ТипПодключенияВнешнейКомпоненты.Изолированно);
		Клиент = Новый("AddIn.BITERP.PinkRabbitMQ");
	Исключение
		ТекстСообщения = НСтр("ru='Не удалось подключиться к внешней компоненте по причине:
			|%1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		Клиент = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	Попытка
		// Подключились к RabbitMQ
		Клиент.Connect(
			НастройкиПодключения.АдресСервера, 
			НастройкиПодключения.Порт, 
			НастройкиПодключения.Пользователь, 
			НастройкиПодключения.Пароль, 
			НастройкиПодключения.Хост,
			,
			,
			30);
	Исключение
		
		ТекстСообщения = НСтр("ru='Не удалось подключиться к серверу RabbitMQ по причине:
			|%1
			|%2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, 
			ПолучитьОшибкуRabbitMQ(Клиент), 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
		Клиент = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	ТекстСообщения = НСтр("ru='Успешно установлено соединение с RabbitMQ'");
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
	
	Возврат Клиент; 
	
КонецФункции

Процедура ВыгрузитьСообщенияВRabbit(Клиент, ИнтеграционнаяИнформация, МассивКлючей)

	// Выгрузим сообщения
	ДанныеСообщений = КР_ОбменRabbitОбработкаСообщенийОбмена.ПолучитьДанныеИсходящихСообщений(МассивКлючей, ИнтеграционнаяИнформация);
	
	Для Каждого ТочкаМассивСообщений Из ДанныеСообщений Цикл
		ТочкаОбмена = ТочкаМассивСообщений.Ключ;
		МассивСообщений = ТочкаМассивСообщений.Значение;
		
		Если Не ИнициализироватьТочкуОбмена(Клиент, ТочкаОбмена, ИнтеграционнаяИнформация) Тогда
			ТекстСообщения = НСтр("ru='Ошибка инициализации точки обмена %1 RabbitMQ'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ТочкаОбмена);
			КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
				КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
			Продолжить;
		КонецЕсли;	
		
		ТекстСообщения = НСтр("ru='Выбрано %1 сообщений для выгрузки в очередь %2 RabbitMQ'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, МассивСообщений.Количество(), ТочкаОбмена);
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());		
		
		Для Каждого СтруктураСообщения Из МассивСообщений Цикл				
			ОтправитьСообщениеВRabbit(Клиент, СтруктураСообщения, ИнтеграционнаяИнформация);
			КР_ОбменRabbitОбработкаСообщенийОбмена.ЗарегистрироватьОтправкуСообщенияОбмена(СтруктураСообщения, ИнтеграционнаяИнформация);		
		КонецЦикла;
		
	КонецЦикла;
	
	ТекстСообщения = НСтр("ru='Завершена итерация выгрузки сообщений в RabbitMQ'");
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
	
КонецПроцедуры

Функция ИнициализироватьТочкуОбмена(Клиент, ТочкаОбмена, ИнтеграционнаяИнформация)
	
	Возврат Истина;
	
	Попытка
		// Создаем новый обмен		
		//ТипТочки = "topic";
		ТипТочки = "direct";

		Клиент.DeclareExchange(ТочкаОбмена, ТипТочки, Ложь, Истина, Ложь);
		
		ТекстСообщения = НСтр("ru='Успешно инициализирована точка обмена %1 типа %2 RabbitMQ'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ТочкаОбмена, ТипТочки);
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
		
	Исключение
		
		ТекстСообщения = НСтр("ru='Не удалось создать новый (найти существующий) обмен ""%1"" на сервере RabbitMQ по причине:
			|%2
			|%3'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ТочкаОбмена, 
			ПолучитьОшибкуRabbitMQ(Клиент),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
			
		Возврат Ложь;
	КонецПопытки;
	
	//Попытка
	//	// Создаем новую очередь
	//	Клиент.DeclareQueue(СтруктураСообщения.ОчередьОбмена, Ложь, Ложь, Ложь, Ложь);
	//Исключение
	//	ТекстСообщения = НСтр("ru='Не удалось создать новую (найти существующую) очередь ""%1"" на сервере RabbitMQ по причине:
	//		|%2
	//		|%3'");
	//	ТекстСообщения = СтрШаблон(ТекстСообщения, СтруктураСообщения.ОчередьОбмена, 
	//		ПолучитьОшибкуRabbitMQ(Клиент),
	//		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	//	
	//	КР_ОбработкаСообщенийОбмена.ДобавитьЗаписьЛогирования(СтруктураЛогирования, ТекстСообщения, Истина);
	//	КР_ОбработкаСообщенийОбмена.ЗаписатьЛокальнуюОшибкуОбработкиСообщения(СтруктураСообщения, СтруктураЛогирования);
	//	
	//	Возврат Ложь;
	//КонецПопытки;
	
	//Попытка
	//	// Связываем созданный обмен с очередью
	//	// здесь следует понимать, что происходит не "связь" очереди и обмена, а в Обмене создается правило маршрутизации,
	//	// которое будет перенаправлять все получаемые сообщения в необходимую очередь
	//	// в компоненте маршрутизация опредеяется вторым параметром, передаваемым в BasicPublish
	//
	//	Клиент.BindQueue(СтруктураСообщения.ОчередьОбмена, СтруктураСообщения.ТочкаОбмена, "#" + СтруктураСообщения.ОчередьОбмена + "#");
	//Исключение
	//	ТекстСообщения = НСтр("ru='Не удалось связать очередь ""%1"" с обменом ""%2"" на сервере RabbitMQ по причине:
	//		|%3
	//		|%4'");
	//	ТекстСообщения = СтрШаблон(ТекстСообщения, СтруктураСообщения.ОчередьОбмена, СтруктураСообщения.ТочкаОбмена, 
	//		ПолучитьОшибкуRabbitMQ(Клиент),
	//		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	//	
	//	КР_ОбработкаСообщенийОбмена.ДобавитьЗаписьЛогирования(СтруктураЛогирования, ТекстСообщения, Истина);
	//	КР_ОбработкаСообщенийОбмена.ЗаписатьЛокальнуюОшибкуОбработкиСообщения(СтруктураСообщения, СтруктураЛогирования);
	//	
	//	Возврат Ложь;
	//КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Процедура ОтправитьСообщениеВRabbit(Клиент, СтруктураСообщения, ИнтеграционнаяИнформация)	
	
	// Конвертируем созданное сообщение в текст для отправки
	ОтправляемоеСообщение = КР_ФункцииРаботыJSON.СериализоватьXDTOВJSON(СтруктураСообщения.ОбъектСообщение);
	
	Попытка		
		ЗаписьЖурналаРегистрации("RabbitMQ.ОбменСообщениями", УровеньЖурналаРегистрации.Информация, Метаданные.РегламентныеЗадания.КР_ОбменRabbitИнтеграция, , "Отправка сообщения " + СтруктураСообщения.КлючСообщения);
		// Отправляем сообщение в очередь:
		Клиент.BasicPublish(СтруктураСообщения.ТочкаОбмена, СтруктураСообщения.Маршрутизация, ОтправляемоеСообщение, 0, Истина);
	Исключение
		ТекстСообщения = НСтр("ru='Не удалось отправить сообщение ""%1"" в Точку Обмена ""%2"" на сервер RabbitMQ по причине:
			|%3
			|%4'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, СтруктураСообщения.КлючСообщения, 
			СтруктураСообщения.ТочкаОбмена,
			ПолучитьОшибкуRabbitMQ(Клиент),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ЗаписьЖурналаРегистрации("RabbitMQ.ОбменСообщениями", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегламентныеЗадания.КР_ОбменRabbitИнтеграция, , ТекстСообщения);
		
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
			
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СтруктураСообщения, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
			
		// #3382..
		Клиент = Неопределено;
		Клиент = ПолучитьСоединениеСКлиентомОбмена(ИнтеграционнаяИнформация);
		// ..#3382
		
		Возврат;
	КонецПопытки;	
	
КонецПроцедуры

Процедура ЗагрузитьСообщенияИзRabbit(Клиент, ИнтеграционнаяИнформация)
	
	ПодписчикОчередей = ИнтеграционнаяИнформация.НастройкиПодключения.ПодписчикОчередей;
	Если ТипЗнч(ПодписчикОчередей) <> Тип("Массив")
		Или ПодписчикОчередей.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='В настройках интеграции не задан список очередей для чтения сообщений. Получение выполняться не будет.'");
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Информационная база является подписчиком очередей: %1'");
	ТекстСообщения = СтрШаблон(ТекстСообщения, СтрСоединить(ПодписчикОчередей, ", "));
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
	
	Для Каждого ИмяОчереди Из ПодписчикОчередей Цикл
		
		ТекстСообщения = НСтр("ru='Старт чтения сообщения из очереди: %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ИмяОчереди);
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
			КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
		
		// Начинаем чтение сообщений из очереди
		Попытка
			
			ВходящееСообщение = ""; // здесь будет сообщение, полученное от Rabbit
			ТегСообщения = 0; // тег, сообщения, присваемыей ему Rabbit. По нему будет отправляться квитанция в Rabbit
			
			Потребитель = Клиент.BasicConsume(ИмяОчереди, "", Ложь, Ложь, 20);
			
		Исключение
			
			ТекстСообщения = НСтр("ru='Не удалось создать новую (найти существующую) очередь ""%1"" на сервере RabbitMQ по причине:
				|%2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения,
				ИмяОчереди, 
				ПолучитьОшибкуRabbitMQ(Клиент));
			
			КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
				КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
			
		КонецПопытки;
		
		// Чтение сообщений
		// #3548..
		МаксЧислоПопыток = 3;
		ЧислоПопыток = 0;
		// ..#3548
		Пока Истина Цикл
			
			Попытка
				СообщениеПолучено = Клиент.BasicConsumeMessage("", ВходящееСообщение, ТегСообщения, 15000);
				
				// Если сообщений больше нет, прерываем цикл чтения.
				// #3548..
				// Было:
				//Если НЕ СообщениеПолучено Тогда
				//	Прервать;
				//КонецЕсли;
				// Стало:
				Если СообщениеПолучено Тогда
					ЧислоПопыток = 0;
				Иначе
					ЧислоПопыток = ЧислоПопыток + 1;
					Если ЧислоПопыток >= МаксЧислоПопыток Тогда
						Прервать;
					Иначе
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				// ..#3548
				
				ТекстОшибки = "";
				
				Если КР_ОбменRabbitОбработкаСообщенийОбмена.ЗарегистрироватьВходящееСообщение(
						ИмяОчереди, 
						ВходящееСообщение, 
						ИнтеграционнаяИнформация,
					 	ТекстОшибки) Тогда
						
					Клиент.BasicAck(ТегСообщения); // подтверждаем серверу чтение сообщения
					
				Иначе	
					
					// Зафиксируем в интеграционной информации ошибочное сообщение, чтобы была возможность его исправить и разобрать
					СтрокаОшибочногоСообщения = ИнтеграционнаяИнформация.ОшибочныеСообщения.Добавить();
					СтрокаОшибочногоСообщения.ТекстОшибки = ТекстОшибки;
					СтрокаОшибочногоСообщения.ВходящееСообщение = ВходящееСообщение;
					СтрокаОшибочногоСообщения.ИмяОчереди = ИмяОчереди;					
					
					//Клиент.BasicReject(ТегСообщения); // Отказываемся от сообщения
					Клиент.BasicAck(ТегСообщения); // подтверждаем серверу чтение сообщения
					
				КонецЕсли;
				
			Исключение
				
				ТекстСообщения = НСтр("ru='Не удалось прочитать сообщение из очереди ""%1"" на сервере RabbitMQ по причине:
					|%2'");
				ТекстСообщения = СтрШаблон(ТекстСообщения,
					ИмяОчереди, 
					ПолучитьОшибкуRabbitMQ(Клиент));
					
				ЗаписьЖурналаРегистрации("RabbitMQ.ОбменСообщениями", УровеньЖурналаРегистрации.Ошибка, Метаданные.РегламентныеЗадания.КР_ОбменRabbitИнтеграция, , ТекстСообщения);
				
				КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
					КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка());
				
			КонецПопытки;
			
			ВходящееСообщение = "";
			ТегСообщения = 0;
			
		КонецЦикла;
		
		ВходящееСообщение = "";
		ТегСообщения = 0;
		// Закрыть канал чтения сообщений
		Клиент.BasicCancel("");
		
	КонецЦикла;
	
	ТекстСообщения = НСтр("ru='Закончили читать сообщения из всех очередей из настроек'");
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(ИнтеграционнаяИнформация, ТекстСообщения, 
		КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация());
	
КонецПроцедуры

Функция ПолучитьОшибкуRabbitMQ(Клиент)

	Если Клиент = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Клиент обмена не инициирован'");
	Иначе
		Попытка
			ТекстОшибки = Клиент.GetLastError();
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось получить с сервера RabbitMQ информацию об ошибке'");	
		КонецПопытки;	
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти

#КонецОбласти

