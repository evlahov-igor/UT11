﻿
#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	
	КопируемыеНастройки = Параметры.НазваниеНастройки;
	
	ТСДИсточник = ПланыОбмена.ДатаМобайл_СписокТСД.НайтиПоКоду(Параметры.КодТСД);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДатаМобайл_СписокТСД.Ссылка КАК ТСДПриемник,
	|	ЛОЖЬ КАК Выбран
	|ИЗ
	|	ПланОбмена.ДатаМобайл_СписокТСД КАК ДатаМобайл_СписокТСД
	|ГДЕ
	|	ДатаМобайл_СписокТСД.ПометкаУдаления = ЛОЖЬ
	|	И ДатаМобайл_СписокТСД.ЭтотУзел = ЛОЖЬ
	|	И НЕ ДатаМобайл_СписокТСД.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаМобайл_СписокТСД.Код";
	Запрос.УстановитьПараметр("Ссылка", ТСДИсточник);
	СписокТСД.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаСервере
Процедура СкопироватьНастройкиНаСервере()
	
	Счетчик = 0;  
	
	СтруктураПоиска = Новый Структура;  
	
	Для каждого Строка Из СписокТСД Цикл
		
		Если Строка.Выбран Тогда
			ТСДОбъект = Строка.ТСДПриемник.ПолучитьОбъект();			
			ТСДОбъект[КопируемыеНастройки].Загрузить(ТСДИсточник[КопируемыеНастройки].Выгрузить()); 		 	
			Попытка
				ТСДОбъект.Записать();
				Счетчик = Счетчик + 1;
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;	
		КонецЕсли;	
		
	КонецЦикла;	   
	
	Если Счетчик = 0 Тогда
		Сообщить("Выберите ТСД, в которые нужно скопировать настройки!");
	Иначе	
		Сообщить("Копирование настроек в выбранные ТСД завершена!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьНастройки(Команда)
	
	СкопироватьНастройкиНаСервере();
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсеСтроки(Команда)
	
	Для каждого Строка Из СписокТСД Цикл
		Строка.Выбран = Истина;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	Для каждого Строка Из СписокТСД Цикл
		Строка.Выбран = Ложь;	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти