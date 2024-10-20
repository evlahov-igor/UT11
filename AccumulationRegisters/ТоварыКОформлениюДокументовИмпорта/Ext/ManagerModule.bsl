﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Поставщик)
	|	И ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ТоварыКОформлениюДокументовИмпорта.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.7.126";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("12c0fce0-9961-446f-9e68-a714ef28900c");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ТоварыКОформлениюДокументовИмпорта.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Товары к оформлению документов импорта"":
	|- Заполняет реквизит ""Тип документа импорта"" ссылкой на идентификатор объекта метаданных для документа ""Таможенная декларация (импорт)"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКОформлениюДокументовИмпорта.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ТоварыКОформлениюДокументовИмпорта.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ТоварыКОформлениюДокументовИмпорта";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыКОформлениюДокументовИмпорта.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюДокументовИмпорта КАК ТоварыКОформлениюДокументовИмпорта
	|ГДЕ
	|	ТоварыКОформлениюДокументовИмпорта.ТипДокументаИмпорта = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	ПолноеИмяРегистра = "РегистрНакопления.ТоварыКОформлениюДокументовИмпорта";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(
		Параметры.Очередь,
		Неопределено,
		ПолноеИмяРегистра);
		
	ИдентификаторТаможеннаяДекларацияИмпорт = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ТаможеннаяДекларацияИмпорт");	
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Выборка.Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
						
			Блокировка.Заблокировать();
			
			Набор = РегистрыНакопления.ТоварыКОформлениюДокументовИмпорта.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
			Набор.Прочитать();
			
			Для Каждого СтрокаНабора Из Набор Цикл
				Если Не ЗначениеЗаполнено(СтрокаНабора.ТипДокументаИмпорта) Тогда
					СтрокаНабора.ТипДокументаИмпорта = ИдентификаторТаможеннаяДекларацияИмпорт;	
				КонецЕсли;
			КонецЦикла;	
			Если Набор.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Регистратор, ДополнительныеПараметры);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Выборка.Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				Выборка.Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
