﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	
	Результат.Добавить("Владелец");
	Результат.Добавить("НастройкаАдресногоХранения");
	Результат.Добавить("ДатаНачалаАдресногоХраненияОстатков");
	Возврат Результат;

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Владелец")
		Или Не ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область КР_ДобавленныеПроцедурыИФункции  

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// << 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
// Возвращает первое не помеченное на удаление помещение с типом СкладМагазина, 
//	владельцем которого является указанный склад
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад по которому требуется получить помещение
//
// Возвращаемое значение:
//   СправочникСсылка.СкладскиеПомещения - Элемент справочника или пустое значение
//
Функция КР_СкладскоеПомещениеПоТипу(ТипСкладскогоПомещения, Склад, НаДату) Экспорт 

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СкладскиеПомещения КАК Т
	|		ПО Склады.Ссылка = Т.Владелец
	|			И (НЕ Т.ПометкаУдаления)
	|			И (Т.КР_ТипСкладскогоПомещения = &ТипСкладскогоПомещения)
	|ГДЕ
	|	Склады.Ссылка = &Склад
	|	И Склады.ИспользоватьСкладскиеПомещения
	|	И Склады.ДатаНачалаИспользованияСкладскихПомещений <= &НаДату");  
	
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ТипСкладскогоПомещения", ТипСкладскогоПомещения);
	Запрос.УстановитьПараметр("НаДату", НаДату);
	РезультатЗапроса = Запрос.Выполнить(); 
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;	
	Иначе
	    Возврат Справочники.СкладскиеПомещения.ПустаяСсылка();
	КонецЕсли;

КонецФункции // >> 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751

// << 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
// Возвращает первое не помеченное на удаление помещение с типом СкладМагазина, 
//	владельцем которого является указанный склад
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад по которому требуется получить помещение
//
// Возвращаемое значение:
//   СправочникСсылка.СкладскиеПомещения - Элемент справочника или пустое значение
//
Функция КР_СкладскоеПомещениеСкладМагазина(Склад, Знач НаДату = Неопределено) Экспорт 

	Если НаДату = Неопределено Тогда 
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат КР_СкладскоеПомещениеПоТипу(Перечисления.КР_ТипыСкладскихПомещений.СкладМагазина, Склад, НаДату);	

КонецФункции // >> 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751

// << 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
// Возвращает первое не помеченное на удаление помещение с типом ТорговыйЗал, 
//	владельцем которого является указанный склад
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад по которому требуется получить помещение
//
// Возвращаемое значение:
//   СправочникСсылка.СкладскиеПомещения - Элемент справочника или пустое значение
//
Функция КР_СкладскоеПомещениеТорговыйЗал(Склад, Знач НаДату = Неопределено) Экспорт 

	Если НаДату = Неопределено Тогда 
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат КР_СкладскоеПомещениеПоТипу(Перечисления.КР_ТипыСкладскихПомещений.ТорговыйЗал, Склад, НаДату);	
	
КонецФункции // >> 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751

// << 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
// Возвращает первое не помеченное на удаление помещение с типом ТорговыйЗал, 
//	владельцем которого является указанный склад
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад по которому требуется получить помещение
//
// Возвращаемое значение:
//   СправочникСсылка.СкладскиеПомещения - Элемент справочника или пустое значение
//
Функция КР_СкладскоеПомещениеИнтернетТорговля(Склад, Знач НаДату = Неопределено) Экспорт 

	Если НаДату = Неопределено Тогда 
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат КР_СкладскоеПомещениеПоТипу(Перечисления.КР_ТипыСкладскихПомещений.ИнтернетТорговля, Склад, НаДату);	
	
КонецФункции // >> 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751

// << 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
// Возвращает первое не помеченное на удаление помещение с ИспользоватьАдресноеХранение = Истина, 
//	владельцем которого является указанный склад
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад по которому требуется получить помещение
//
// Возвращаемое значение:
//   СправочникСсылка.СкладскиеПомещения - Элемент справочника или пустое значение
//
Функция КР_СкладскоеПомещениеСАдреснымХранением(Склад) Экспорт 

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СкладскиеПомещения КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И Т.Владелец = &Склад
	|	И Т.ИспользоватьАдресноеХранение");  
	Запрос.УстановитьПараметр("Склад", Склад);
	РезультатЗапроса = Запрос.Выполнить(); 
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;	
	Иначе
	    Возврат Справочники.СкладскиеПомещения.ПустаяСсылка();
	КонецЕсли;

КонецФункции // >> 02.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751

// << 01.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1262
Функция КР_СоздатьСкладскоеПомещениеПоТипу(Склад, ТипСкладскогоПомещения, Обновлять = Ложь) Экспорт

	Если Не ЗначениеЗаполнено(Склад)
		Или Не ЗначениеЗаполнено(ТипСкладскогоПомещения) Тогда 
	    Возврат Справочники.СкладскиеПомещения.ПустаяСсылка();
	КонецЕсли;
	
	// Сформируем данные для GUID 
	ДанныеДляGUID = XMLСтрока(Склад) + XMLСтрока(ТипСкладскогоПомещения);
	GUID = КР_ОбщегоНазначениеСервер.GUIDИзСтроки(ДанныеДляGUID);
	
	Ссылка = XMLЗначение(Тип("СправочникСсылка.СкладскиеПомещения"), GUID);
	Если Не ОбщегоНазначения.СсылкаСуществует(Ссылка) Тогда 
		
		ПомещениеОбъект = Справочники.СкладскиеПомещения.СоздатьЭлемент();  
		ПомещениеОбъект.УстановитьСсылкуНового(Ссылка);
		ПомещениеОбъект.Владелец = Склад;
		ПомещениеОбъект.КР_ТипСкладскогоПомещения = ТипСкладскогоПомещения;
		
	Иначе  
		
		Если Не Обновлять Тогда 
			Возврат Ссылка;   
		КонецЕсли;
		
		ПомещениеОбъект = Ссылка.ПолучитьОбъект();
		
	КонецЕсли;	    
	
	ТипыСкладскихПомещений = Перечисления.КР_ТипыСкладскихПомещений;
	НастройкиАдресногоХранения = Перечисления.НастройкиАдресногоХранения;
	ИспользованиеСкладскихРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков;
	
	//
	ПомещениеОбъект.Наименование = ТипСкладскогоПомещения;
	ПомещениеОбъект.ИспользованиеРабочихУчастков = ИспользованиеСкладскихРабочихУчастков.НеИспользовать;
	Если ТипСкладскогоПомещения = ТипыСкладскихПомещений.СкладМагазина Тогда 
		ПомещениеОбъект.ИспользоватьАдресноеХранение = Истина;
		ПомещениеОбъект.НастройкаАдресногоХранения = НастройкиАдресногоХранения.ЯчейкиОстатки;
	ИначеЕсли ТипСкладскогоПомещения = ТипыСкладскихПомещений.ТорговыйЗал
		Или ТипСкладскогоПомещения = ТипыСкладскихПомещений.ИнтернетТорговля Тогда
		ПомещениеОбъект.ИспользоватьАдресноеХранение = Ложь;
		ПомещениеОбъект.НастройкаАдресногоХранения = НастройкиАдресногоХранения.НеИспользовать;   
	Иначе 
		ТекстИсключения = НСтр("ru = 'Не определена логика формирования складского помещения на основании типа %1'");  
		ТекстИсключения = СтрШаблон(ТекстИсключения, ТипСкладскогоПомещения);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	ПомещениеОбъект.ОбменДанными.Загрузка = Истина;
	ПомещениеОбъект.Записать();
	
	// A2105505-1599 
	// Так как запись помещения происходит в режиме Загрузка = Истина то надо выполнить код "При записи"
	РегистрыСведений.НастройкиАдресныхСкладов.УстановитьНастройкиПоУмолчанию(
		ПомещениеОбъект.Владелец,
		ПомещениеОбъект.Ссылка,
		ПомещениеОбъект.ИспользоватьАдресноеХранение,
		ПомещениеОбъект.ДатаНачалаАдресногоХраненияОстатков,
		ПомещениеОбъект.ИспользоватьАдресноеХранениеСправочно,
		ПомещениеОбъект.ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.Использовать,
		ПомещениеОбъект.ЭтоНовый());
	//
	
	Возврат Ссылка;
	
КонецФункции // >> 01.03.2023 Марченко С.Н., КРОК, JIRA№A2105505-1262

#КонецОбласти

#КонецЕсли

#КонецОбласти