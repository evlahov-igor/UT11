﻿
////////////////////////////////////////////////////
//// Общий модуль "КР_Демо_УТ11_ЗагрузкаДанныхСервер"
//// Создан: 06.12.2022, Федотов А.М., КРОК, JIRA№ A2105505-749
//// Разработка по ФДР С32.004 Интеграция ImportDepartment-УТ11

#Область ПрограммныйИнтерфейс

Функция ДобавитьНастройкиЗагрузкиОбъектов(ПараметрыЗагрузки) Экспорт
	
	// << 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749
	// заполнение ТЧ «Расшифровка платежа» документа «Списание безналичных денежных средств»
	СтрокаЗагрузки = НастройкаЗагрузки(ПараметрыЗагрузки, "OutgoingPaymentDetailsObject");
	// >> 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749

	Возврат ПараметрыЗагрузки; 
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфес

#Область ПравилаЗагрузкиОбъектов

// << 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749
Процедура ПЗО_OutgoingPaymentDetailsObject(СообщениеОбмена) Экспорт
	
	// Получаем пакет
	ПакетДанных = СообщениеОбмена.Данные;
	// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
	ПКО_ДокументОбъект_ВзаимозачетЗадолженности(ПакетДанных, СообщениеОбмена);
	// >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
	
КонецПроцедуры // >> 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749

#КонецОбласти

#КонецОбласти

#Область ПравилаКонвертации

#Область Справочники


#КонецОбласти

#Область Документы

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ПКО_ДокументОбъект_ВзаимозачетЗадолженности(ПакетДанных, СообщениеОбмена)
	
	ОтказОтЗаписи = Ложь;
	ИмяДокументаСтрокой = "Списание безналичных денежных средств";
	ДокументСписаниеБезналичныхДС = НайтиДокумент(ПакетДанных, СообщениеОбмена, ИмяДокументаСтрокой, ОтказОтЗаписи);
	
	ТаблицаЗаказов = СоздатьЗаполнитьТаблицуЗаказыПоставщику(ПакетДанных, СообщениеОбмена, ОтказОтЗаписи);
	
	Если ОтказОтЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектРасчетаСБДС = ПолучитьОбъектыРасчетов(ДокументСписаниеБезналичныхДС, СообщениеОбмена);
	Если Не ЗначениеЗаполнено(ОбъектРасчетаСБДС) Тогда
		ОтказОтЗаписи = Истина;
		Возврат;
	КонецЕсли;
	РезультатЗапросаВзаимозачетЗадолженности = ПолучитьДокументыВзаимозачетЗадолженности(ОбъектРасчетаСБДС, ТаблицаЗаказов);

	ОбработатьДанныеВзаимозачетаЗадолженности(РезультатЗапросаВзаимозачетЗадолженности, ОбъектРасчетаСБДС, СообщениеОбмена);
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиЗагрузкиОбъектов

Функция НастройкаЗагрузки(ПараметрыЗагрузки, ТипДанных)
	
	ШаблонПравилаЗагрузки = "КР_ImportDepartment_УТ11_ЗагрузкаДанныхСервер.ПЗО_%1";
	
	СтрокаЗагрузки = ПараметрыЗагрузки.Добавить();
	СтрокаЗагрузки.ТипДанных = ТипДанных;
	СтрокаЗагрузки.Отправитель = ""; // любой
	СтрокаЗагрузки.ОчередьОбмена = ""; // любой
	СтрокаЗагрузки.ПравилоЗагрузки = СтрШаблон(ШаблонПравилаЗагрузки, ТипДанных);
	СтрокаЗагрузки.ДополнительныеПараметры = Новый Структура;
	
	Возврат СтрокаЗагрузки;
	
КонецФункции

#КонецОбласти

#Область Алгоритмы

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция ПолучитьОбъектыРасчетов(Ссылка, СообщениеОбмена)
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДополнительныеКритерииПоиска = ОбъектыРасчетовСервер.ДополнительныеКритерииПоиска();
	ДополнительныеКритерииПоиска.ВернутьПервый = Истина;
	
	СоответствиеОбъектыРасчетовПоСсылкам = ОбъектыРасчетовСервер.ПолучитьОбъектыРасчетовПоСсылкам(МассивСсылок,
		, , ДополнительныеКритерииПоиска);
	ОбъектыРасчета = СоответствиеОбъектыРасчетовПоСсылкам.Получить(Ссылка);
	
	Если Не ЗначениеЗаполнено(ОбъектыРасчета) Тогда
		ОбработатьОшибкуПоискаОбъектаРасчета(Ссылка, Ложь, СообщениеОбмена);
	КонецЕсли;

	Возврат ОбъектыРасчета;
	
КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ЗаполнитьОбъектыРасчетовДляЗаказов(ТаблицаЗаказов, СообщениеОбмена, ОтказОтЗаписи)
	
	МассивСсылок				= Новый Массив;
	Для Каждого СтрокаТаблицы Из ТаблицаЗаказов Цикл
		МассивСсылок.Добавить(СтрокаТаблицы.ЗаказПоставщику);
	КонецЦикла;
	
	ДополнительныеКритерииПоиска = ОбъектыРасчетовСервер.ДополнительныеКритерииПоиска();
	ДополнительныеКритерииПоиска.ВернутьПервый = Истина;
	
	ОбъектыРасчетовПоСсылкам 	= ОбъектыРасчетовСервер.ПолучитьОбъектыРасчетовПоСсылкам(МассивСсылок,
		, , ДополнительныеКритерииПоиска);
	Для Каждого СтрокаТаблицы Из ТаблицаЗаказов Цикл
		ТекущийОбъектРасчетов = ОбъектыРасчетовПоСсылкам.Получить(СтрокаТаблицы.ЗаказПоставщику);
		Если ЗначениеЗаполнено(ТекущийОбъектРасчетов) Тогда
			СтрокаТаблицы.ОбъектРасчетов = ТекущийОбъектРасчетов;
		Иначе
			ОтказОтЗаписи = Истина;
			ОбработатьОшибкуПоискаОбъектаРасчета(СтрокаТаблицы.ЗаказПоставщику, Истина, СообщениеОбмена);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ОбработатьОшибкуПоискаОбъектаРасчета(Ссылка, ЭтоЗаказ, СообщениеОбмена)
	
	Если ЭтоЗаказ Тогда
		МетаданныеДокумента = Метаданные.Документы.ЗаказПоставщику
	Иначе
		МетаданныеДокумента = Метаданные.Документы.СписаниеБезналичныхДенежныхСредств;
	КонецЕсли;
	
	ШаблонОшибки = 	НСтр("ru = 'Не найден объекта расчета для документа ""%1"".'");
	ТекстОшибки =	СтрШаблон(ШаблонОшибки, Ссылка);
	
	ТипОшибкиПоиска = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_ОшибкаПоискаСсылки(МетаданныеДокумента);
	
	КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстОшибки, ТипОшибкиПоиска);
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ОбработатьДанныеВзаимозачетаЗадолженности(РезультатЗапроса, ОбъектРасчетаСБДС, СообщениеОбмена)
	
	ДокументОбъект = Неопределено;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ВзаимозачетЗадолженности) Тогда
			ДокументОбъект = Выборка.ВзаимозачетЗадолженности.ПолучитьОбъект();
			ДокументОбъект.КредиторскаяЗадолженность.Очистить();
			ДокументОбъект.ДебиторскаяЗадолженность.Очистить();
		Иначе
			ДокументОбъект 						= Документы.ВзаимозачетЗадолженности.СоздатьДокумент();
		КонецЕсли;
		
		// << 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
		ЗаполнитьОбновитьШапкуДокумента(ДокументОбъект, Выборка, СообщениеОбмена);
		ДобавитьСтроку("КТ", ДокументОбъект, Выборка.ОбъектРасчетов, Выборка.Сумма);
		ДобавитьСтроку("ДТ", ДокументОбъект, ОбъектРасчетаСБДС);
		// >> 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
		
		ОбработкаЗаписьДокумента(ДокументОбъект, ОбъектРасчетаСБДС, СообщениеОбмена)
		
	КонецЦикла;
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ЗаполнитьОбновитьШапкуДокумента(ДокументОбъект, Данные, СообщениеОбмена)
	
	ОрганизацияПоУмолчанию 				= Справочники.Организации.ОрганизацияПоУмолчанию();
	ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаПоставщикуОрганизацияКонтрагент;
	КомментарийШаблон					= НСтр("ru='Создан при обработке сообщения обмена [%1]'");
	Комментарий							= СтрШаблон(КомментарийШаблон, СообщениеОбмена.КлючСообщения);
	
	ДокументОбъект.Дата					= Данные.Дата;
	ДокументОбъект.Ответственный		= Пользователи.ТекущийПользователь();

	ДокументОбъект.Организация			= ОрганизацияПоУмолчанию;
	ДокументОбъект.ОрганизацияКредитор	= ОрганизацияПоУмолчанию;
	ДокументОбъект.ВидОперации			= ВидОперации;
	ДокументОбъект.ТипДебитора			= Перечисления.ТипыУчастниковВзаимозачета.Поставщик;
	ДокументОбъект.ТипКредитора			= Перечисления.ТипыУчастниковВзаимозачета.Поставщик;
	ДокументОбъект.Комментарий			= Комментарий;
	
КонецПроцедуры // >> 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ДобавитьСтроку(ТипСтроки, ДокументОбъект, ОбъектРасчета, СуммаВзаиморасчетов = Неопределено)
	
	СтрокаДТ = (ТипСтроки = "ДТ");
	
	Если СтрокаДТ Тогда
		НоваяСтрока = ДокументОбъект.ДебиторскаяЗадолженность.Добавить();
	Иначе
		НоваяСтрока = ДокументОбъект.КредиторскаяЗадолженность.Добавить();
	КонецЕсли;
	НоваяСтрока.ОбъектРасчетов = ОбъектРасчета;
	
	ДанныеОбъектаРасчета = ПолучитьСтруктуруДанныхОбъектаРасчета(ОбъектРасчета);
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеОбъектаРасчета);
	
	Если СтрокаДТ Тогда
		ДокументОбъект.КонтрагентДебитор =  ДанныеОбъектаРасчета.Контрагент;
	Иначе
		ДокументОбъект.КонтрагентКредитор = ДанныеОбъектаРасчета.Контрагент;
	КонецЕсли;
	
	Если СуммаВзаиморасчетов <> Неопределено Тогда
		НоваяСтрока.СуммаВзаиморасчетов = СуммаВзаиморасчетов;
		ПересчитатьВалютуПоСтроке(ДокументОбъект, НоваяСтрока);
		ДокументОбъект.СуммаРегл 				= НоваяСтрока.СуммаРегл;
		ДокументОбъект.СуммаУпр 				= НоваяСтрока.СуммаУпр;
		ДокументОбъект.Валюта					= НоваяСтрока.ВалютаВзаиморасчетов;
	Иначе
		ТекущаяСтрокаКТ 						= ДокументОбъект.КредиторскаяЗадолженность[0];
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрокаКТ,
			"Сумма, СуммаВзаиморасчетов, ВалютаВзаиморасчетов, СуммаРегл, СуммаУпр");
	КонецЕсли;
	
КонецПроцедуры // >> 03.04.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция ПолучитьСтруктуруДанныхОбъектаРасчета(ОбъектРасчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДанныеОбъектаРасчета();
	Запрос.УстановитьПараметр("ОбъектРасчета", ОбъектРасчета);
	
	РезультатЗапроса= Запрос.Выполнить();
	
	СтруктураДанных = ОбменДаннымиСлужебный.РезультатЗапросаВСтруктуру(РезультатЗапроса);
	
	Возврат СтруктураДанных;

КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ПересчитатьВалютуПоСтроке(ДокументОбъект, СтрокаДанных)
	
	ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
	ВалютаРегламентированногоУчета 		= ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ОрганизацияПоУмолчанию);
	ВалютаУправленческогоУчета			= ЗначениеНастроекПовтИсп.ВалютаУправленческогоУчета();
	
	Если Не ЗначениеЗаполнено(СтрокаДанных.ВалютаВзаиморасчетов) Тогда
		СтрокаДанных.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
	КонецЕсли;

	Если СтрокаДанных.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
		СтрокаДанных.СуммаРегл 	= СтрокаДанных.СуммаВзаиморасчетов;
	Иначе
		СтрокаДанных.СуммаРегл = РаботаСКурсамиВалютУТ.ПересчитатьВВалюту(
			СтрокаДанных.СуммаВзаиморасчетов,
			ВалютаРегламентированногоУчета,
			СтрокаДанных.ВалютаВзаиморасчетов,
			ВалютаРегламентированногоУчета,
			ДокументОбъект.Дата);
	КонецЕсли;
	СтрокаДанных.Сумма 		= СтрокаДанных.СуммаРегл;
	
	Если СтрокаДанных.ВалютаВзаиморасчетов = ВалютаУправленческогоУчета Тогда
		СтрокаДанных.СуммаУпр = СтрокаДанных.СуммаВзаиморасчетов;
	Иначе
		СтрокаДанных.СуммаУпр = РаботаСКурсамиВалютУТ.ПересчитатьВВалюту(
			СтрокаДанных.СуммаВзаиморасчетов,
			ВалютаРегламентированногоУчета,
			СтрокаДанных.ВалютаВзаиморасчетов,
			ВалютаУправленческогоУчета,
			ДокументОбъект.Дата);
	КонецЕсли;
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция СоздатьЗаполнитьТаблицуЗаказыПоставщику(ПакетДанных, СообщениеОбмена, ОтказОтЗаписи)
	
	ИмяДокументаСтрокой = "Заказ поставщику";
	ТаблицаЗаказов = Новый ТаблицаЗначений;
	ТаблицаЗаказов.Колонки.Добавить("ЗаказПоставщику", 			Новый ОписаниеТипов("ДокументСсылка.ЗаказПоставщику"));
	ТаблицаЗаказов.Колонки.Добавить("Сумма", 					ОбщегоНазначения.ОписаниеТипаЧисло(18, 2));
	ТаблицаЗаказов.Колонки.Добавить("ОбъектРасчетов", 			Новый ОписаниеТипов("СправочникСсылка.ОбъектыРасчетов"));
	ТаблицаЗаказов.Колонки.Добавить("ЗаказПоставщикуДата", 		ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	
	Для Каждого ДетальнаяСтрока Из ПакетДанных.OutgoingPaymentDetailsRows.OutgoingPaymentDetailsSingleRow Цикл
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("PurchaseOrderLot", ДетальнаяСтрока.PurchaseOrderLot);
		ДокументЗаказПоставщику = НайтиДокумент(СтруктураДанных, СообщениеОбмена, ИмяДокументаСтрокой, ОтказОтЗаписи);
		Если ЗначениеЗаполнено(ДокументЗаказПоставщику) Тогда
			СтрокаЗаказа 						= ТаблицаЗаказов.Добавить();
			СтрокаЗаказа.ЗаказПоставщику 		= ДокументЗаказПоставщику;
			СтрокаЗаказа.ЗаказПоставщикуДата	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаЗаказа.ЗаказПоставщику, "Дата");
			СтрокаЗаказа.Сумма					= ДетальнаяСтрока.Amount;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьОбъектыРасчетовДляЗаказов(ТаблицаЗаказов, СообщениеОбмена, ОтказОтЗаписи);
	
	Возврат ТаблицаЗаказов;
	
КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749
Функция НайтиДокумент(ПакетДанных, СообщениеОбмена, ИмяДокумента, Отказ)
	
	Если ИмяДокумента = "Списание безналичных денежных средств" Тогда
		МетаданныеДокумента = Метаданные.Документы.СписаниеБезналичныхДенежныхСредств;
	Иначе
		МетаданныеДокумента = Метаданные.Документы.ЗаказПоставщику;
	КонецЕсли;
	
	ТекстОшибки					= НСтр("ru = 'Не найден документ ""%3"" №%1 %2'");
	ТекстОшибкиДубля			= НСтр("ru = 'Найдено больше одного документа ""%3"" №%1%2'");
	
	ТипОшибки = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Ошибка(МетаданныеДокумента);
	ТипОшибкиПоиска = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_ОшибкаПоискаСсылки(МетаданныеДокумента);
	
	Если ИмяДокумента = "Списание безналичных денежных средств" Тогда
		НомерДокумента			= ПакетДанных.DocNumber;
		ДатаДокумента			= ПакетДанных.DocDate;
		ДатаДокументаСтрокой 	= Формат(ДатаДокумента, " ДФ=dd.MM.yy");
	Иначе
		НомерДокумента			= ПакетДанных.PurchaseOrderLot;
		ДатаДокументаСтрокой		= "";
	КонецЕсли;
	
	Если ПакетДанных = Неопределено Тогда
		Отказ = Истина;
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(
			СообщениеОбмена, НСтр("ru = 'Данные загрузки не определены.'"), ТипОшибки);
		Возврат Неопределено;
	Иначе
		ТекстОшибки							= СтрШаблон(ТекстОшибки, НомерДокумента, ДатаДокументаСтрокой, ИмяДокумента);
		ТекстОшибкиДубля					= СтрШаблон(ТекстОшибкиДубля, НомерДокумента, ДатаДокументаСтрокой, ИмяДокумента);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Если ИмяДокумента = "Списание безналичных денежных средств" Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СписаниеБезналичныхДенежныхСредств.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
		|ГДЕ
		|	СписаниеБезналичныхДенежныхСредств.Номер = &Номер
		|	И НАЧАЛОПЕРИОДА(СписаниеБезналичныхДенежныхСредств.Дата, ДЕНЬ) = &Дата
		|	И Проведен";
		
		Запрос.УстановитьПараметр("Дата", 	НачалоДня(ДатаДокумента));
		Запрос.УстановитьПараметр("Номер",	НомерДокумента);
		
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.НомерПоДаннымПоставщика = &НомерПоДаннымПоставщика
		|	И Проведен";
		
		Запрос.УстановитьПараметр("НомерПоДаннымПоставщика", 	НомерДокумента);
		
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи	= РезультатЗапроса.Выбрать();
		Если ВыборкаДетальныеЗаписи.Количество() > 1 Тогда
			Отказ = Истина;
			КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстОшибкиДубля, ТипОшибки);
			Возврат Неопределено;
		Иначе
			ВыборкаДетальныеЗаписи.Следующий();
			Возврат ВыборкаДетальныеЗаписи.Ссылка;
		КонецЕсли;
	Иначе
		Отказ = Истина;
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ТекстОшибки, ТипОшибкиПоиска);
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // >> 22.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-749

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция ПолучитьДокументыВзаимозачетЗадолженности(ОбъектРасчетаСБДС, ТаблицаЗаказов)

	Запрос			= Новый Запрос;
	Запрос.Текст	= ТекстЗапросаПолучитьДокументыВзаимозачетЗадолженности();
	
	ДатаСБДС 		= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетаСБДС, "Ссылка.Дата");
	Запрос.УстановитьПараметр("ТаблицаЗаказов", 	ТаблицаЗаказов);
	Запрос.УстановитьПараметр("ОбъектРасчетаСБДС", 	ОбъектРасчетаСБДС);
	Запрос.УстановитьПараметр("ДатаСБДС", 			ДатаСБДС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Процедура ОбработкаЗаписьДокумента(ДокументОбъект, ОбъектРасчетаСБДС, СообщениеОбмена)
	
	ДокументОбъект.Проведен = Истина;
	УспешноеПроведение = КР_ОбменRabbitОбщиеМеханизмыКонвертации.ДокументОбъектЗаписать(ДокументОбъект, СообщениеОбмена);
	Если УспешноеПроведение Тогда
		ИнформационноеСообщениеШаблон	= НСтр("ru='Успешно проведен документ %1'");
		ИнформационноеСообщение 		= СтрШаблон(ИнформационноеСообщениеШаблон, ДокументОбъект.Ссылка);
		МетаданныеДокумента = Метаданные.Документы.ВзаимозачетЗадолженности;
		ТипЗаписиВЛог = КР_ОбменRabbitОбработкаСообщенийОбмена.ТипЗаписиВЛог_Информация(МетаданныеДокумента);
		КР_ОбменRabbitОбработкаСообщенийОбмена.ДобавитьЗаписьВЛог(СообщениеОбмена, ИнформационноеСообщение, ТипЗаписиВЛог);
	КонецЕсли;
	
КонецПроцедуры // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

#КонецОбласти

#Область ТекстыЗапросов

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция ТекстЗапросаПолучитьДокументыВзаимозачетЗадолженности()
	
	Возврат
	"ВЫБРАТЬ
	|	ТаблицаЗаказов.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ТаблицаЗаказов.ЗаказПоставщикуДата КАК ЗаказПоставщикуДата,
	|	ТаблицаЗаказов.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ТаблицаЗаказов.Сумма КАК Сумма
	|ПОМЕСТИТЬ ДанныеЗаказов
	|ИЗ
	|	&ТаблицаЗаказов КАК ТаблицаЗаказов
	|ГДЕ
	|	ТаблицаЗаказов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказПоставщику
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвиженияКонтрагентКонтрагентОбороты.Регистратор КАК Регистратор,
	|	ДвиженияКонтрагентКонтрагентОбороты.КорОбъектРасчетов КАК ОбъектРасчетов,
	|	ВЫРАЗИТЬ(ДвиженияКонтрагентКонтрагентОбороты.Регистратор КАК Документ.ВзаимозачетЗадолженности).Дата КАК Дата
	|ПОМЕСТИТЬ ОборотыКонтрагентов
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентКонтрагент.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			ОбъектРасчетов = &ОбъектРасчетаСБДС
	|				И КорОбъектРасчетов В
	|					(ВЫБРАТЬ
	|						ДанныеЗаказов.ОбъектРасчетов КАК ОбъектРасчетов
	|					ИЗ
	|						ДанныеЗаказов КАК ДанныеЗаказов)) КАК ДвиженияКонтрагентКонтрагентОбороты
	|ГДЕ
	|	ДвиженияКонтрагентКонтрагентОбороты.Регистратор ССЫЛКА Документ.ВзаимозачетЗадолженности
	|	И ВЫРАЗИТЬ(ДвиженияКонтрагентКонтрагентОбороты.Регистратор КАК Документ.ВзаимозачетЗадолженности).ВидОперации =
	|		Значение(Перечисление.ВидыОперацийВзаимозачетаЗадолженности.ПереносАвансаПоставщикуОрганизацияКонтрагент)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектРасчетов,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОборотыКонтрагентов.ОбъектРасчетов КАК ОбъектРасчетов,
	|	МАКСИМУМ(ОборотыКонтрагентов.Дата) КАК Дата
	|ПОМЕСТИТЬ МаксДата
	|ИЗ
	|	ОборотыКонтрагентов КАК ОборотыКонтрагентов
	|
	|СГРУППИРОВАТЬ ПО
	|	ОборотыКонтрагентов.ОбъектРасчетов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектРасчетов,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МаксДата.ОбъектРасчетов КАК ОбъектРасчетов,
	|	МаксДата.Дата КАК Дата,
	|	МАКСИМУМ(ОборотыКонтрагентов.Регистратор) КАК Регистратор
	|ПОМЕСТИТЬ РезультатОборотыКонтрагентов
	|ИЗ
	|	МаксДата КАК МаксДата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОборотыКонтрагентов КАК ОборотыКонтрагентов
	|		ПО МаксДата.ОбъектРасчетов = ОборотыКонтрагентов.ОбъектРасчетов
	|			И МаксДата.Дата = ОборотыКонтрагентов.Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	МаксДата.ОбъектРасчетов,
	|	МаксДата.Дата
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОбъектРасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеЗаказов.ЗаказПоставщику КАК ЗаказПоставщику,
	|	ДанныеЗаказов.ЗаказПоставщикуДата КАК ЗаказПоставщикуДата,
	|	ДанныеЗаказов.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ДанныеЗаказов.Сумма КАК Сумма,
	|	ЕСТЬNULL(РезультатОборотыКонтрагентов.Регистратор, ЗНАЧЕНИЕ(Документ.ВзаимозачетЗадолженности.ПустаяСсылка)) КАК Регистратор,
	|	ЕСТЬNULL(РезультатОборотыКонтрагентов.Регистратор, ЗНАЧЕНИЕ(Документ.ВзаимозачетЗадолженности.ПустаяСсылка)) КАК ВзаимозачетЗадолженности,
	|	ВЫБОР
	|		КОГДА ДанныеЗаказов.ЗаказПоставщикуДата >= &ДатаСБДС
	|			ТОГДА ДанныеЗаказов.ЗаказПоставщикуДата
	|		ИНАЧЕ &ДатаСБДС
	|	КОНЕЦ КАК Дата
	|ПОМЕСТИТЬ Итог
	|ИЗ
	|	ДанныеЗаказов КАК ДанныеЗаказов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РезультатОборотыКонтрагентов КАК РезультатОборотыКонтрагентов
	|		ПО ДанныеЗаказов.ОбъектРасчетов = РезультатОборотыКонтрагентов.ОбъектРасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Итог.ЗаказПоставщику КАК ЗаказПоставщику,
	|	Итог.ОбъектРасчетов КАК ОбъектРасчетов,
	|	Итог.Сумма КАК Сумма,
	|	Итог.Дата КАК Дата,
	|	Итог.ВзаимозачетЗадолженности КАК ВзаимозачетЗадолженности
	|ИЗ
	|	Итог КАК Итог";

КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

// << 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411
Функция ТекстЗапросаДанныеОбъектаРасчета()
	
	Возврат
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбъектыРасчетов.Ссылка КАК ОбъектРасчетов,
	|	ОбъектыРасчетов.ТипРасчетов КАК ТипРасчетов,
	|	ОбъектыРасчетов.Валюта КАК Валюта,
	|	ОбъектыРасчетов.Партнер КАК Партнер,
	|	ОбъектыРасчетов.Организация КАК Организация,
	|	ОбъектыРасчетов.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ОбъектыРасчетов.УникальныйИдентификатор КАК ИдентификаторСтроки,
	|	ОбъектыРасчетов.Контрагент КАК Контрагент
	|ИЗ
	|	Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|ГДЕ
	|	ОбъектыРасчетов.Ссылка = &ОбъектРасчета";
	
КонецФункции // >> 15.03.2023,  Федоров Д.Е.,  КРОК,  Jira№ A2105505-1411

#КонецОбласти

#КонецОбласти
