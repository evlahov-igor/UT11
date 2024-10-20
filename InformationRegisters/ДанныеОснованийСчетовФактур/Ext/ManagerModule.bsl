﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти
	
#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.ДанныеОснованийСчетовФактур.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.3.19";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("2528db9e-5e11-4a33-92ea-d629112ba24f");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ДанныеОснованийСчетовФактур.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит ""Ставка НДС""
	|Удалеет записи регистра с типом счетов-фактур Счет-фактура полученный'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.ДанныеОснованийСчетовФактур.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.СтавкиНДС.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ДанныеОснованийСчетовФактур.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ДанныеОснованийСчетовФактур.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры = Неопределено) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.ДанныеОснованийСчетовФактур";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеОснованийСчетовФактур.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОснованийСчетовФактур
	|ГДЕ
	|	ДанныеОснованийСчетовФактур.СтавкаНДС = ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)
	|	И НЕ ДанныеОснованийСчетовФактур.УдалитьСтавкаНДС = &ПустаяСтавкаНДС
	|	ИЛИ ДанныеОснованийСчетовФактур.ТипСчетаФактуры = &ИдентификаторСчетФактураПолученный";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	УчетНДСЛокализация.УстановитьПараметрЗапросаПустаяСтавкаНДСПеречислением(Запрос);
	
	ИдентификаторСчетовФактур = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученный");
	Запрос.УстановитьПараметр("ИдентификаторСчетФактураПолученный", ИдентификаторСчетовФактур);
	
	ИдентификаторСчетовФактур = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученный");
	Запрос.УстановитьПараметр("ИдентификаторСчетФактураПолученный", ИдентификаторСчетовФактур);
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, 
		Регистраторы,
		ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.ДанныеОснованийСчетовФактур;
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ИдентификаторСчетовФактур = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученный");
	
	Для Каждого Выборка Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			Блокировка.Заблокировать();
							
			НаборЗаписей = РегистрыСведений.ДанныеОснованийСчетовФактур.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Прочитать();
			НаборИзменен = Ложь;
			
			КолвоЗаписей = НаборЗаписей.Количество();
			Для ОбратныйИндекс = 1 По КолвоЗаписей Цикл
				СтрокаНабораЗаписей = НаборЗаписей[КолвоЗаписей - ОбратныйИндекс];
				
				// Записи с типом Счет-фактура полученный удаляем.
				
				Если СтрокаНабораЗаписей.ТипСчетаФактуры = ИдентификаторСчетовФактур Тогда
					НаборЗаписей.Удалить(КолвоЗаписей - ОбратныйИндекс);
					НаборИзменен = Истина;
				ИначеЕсли Не ЗначениеЗаполнено(СтрокаНабораЗаписей.СтавкаНДС) Тогда
					СтрокаНабораЗаписей.СтавкаНДС = УчетНДСЛокализация.СтавкаНДСПоПеречислению(СтрокаНабораЗаписей.УдалитьСтавкаНДС);
					СтрокаНабораЗаписей.УдалитьСтавкаНДС = Неопределено;
					НаборИзменен = Истина;
				КонецЕсли;
			КонецЦикла;
			
			Если НаборИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			Шаблон = НСтр("ru = 'Не удалось записать данные в регистр %1 по регистратору ""%2"", по причине: %3'");
			ТекстСообщения = 
				СтрШаблон(Шаблон, 
					ПолноеИмяРегистра, 
					Выборка.Регистратор, 
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, 
				, 
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
		
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
