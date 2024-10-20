﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет реквизиты выбранной статьи доходов.
//
// Параметры:
//  СтатьяДоходов - ПланВидовХарактеристикСсылка.СтатьиДоходов - Ссылка на статью доходов.
//
// Возвращаемое значение:
//	Структура - реквизиты статьи доходов.
//
Функция ПолучитьРеквизитыСтатьиДоходов(СтатьяДоходов) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СтатьиДоходов.СпособРаспределения КАК СпособРаспределения,
	|	СтатьиДоходов.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиДоходов КАК СтатьиДоходов
	|ГДЕ
	|	СтатьиДоходов.Ссылка = &СтатьяДоходов
	|");
	
	Запрос.УстановитьПараметр("СтатьяДоходов", СтатьяДоходов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СпособРаспределения = Выборка.СпособРаспределения;
		ТребуетсяСпособРаспределения = Не Выборка.ТипЗначения.СодержитТип(Тип("СправочникСсылка.НаправленияДеятельности"));
	Иначе
		СпособРаспределения = Неопределено;
		ТребуетсяСпособРаспределения = Ложь;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("СпособРаспределения, ТребуетсяСпособРаспределения",
		СпособРаспределения,
		ТребуетсяСпособРаспределения);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Функция определяет аналитику доходов для подстановки в документ по статье доходов.
//
// Параметры:
//  СтатьяДоходов - ПланВидовХарактеристикСсылка.СтатьиДоходов - Ссылка на статью доходов
//	Объект - ДанныеФормыСтруктура - Текущий объект 
//	Подразделение - СправочникСсылка.СтруктураПредприятия - Ссылка на подразделение, указанное в документе.
//
// Возвращаемое значение:
//	СправочникСсылка - значение аналитики доходов.
//
Функция ПолучитьАналитикуДоходовПоУмолчанию(СтатьяДоходов, Объект, Подразделение) Экспорт
	
	ОписаниеТипов = Новый ОписаниеТипов(СтатьяДоходов.ТипЗначения);
	АналитикаДоходов = ОписаниеТипов.ПривестиЗначение();
	
	Если СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Партнеры")
		И Объект.Свойство("Партнер") Тогда
		
		АналитикаДоходов = Объект.Партнер;	
		
	ИначеЕсли СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации")
	   И Объект.Свойство("Организация") Тогда
	   
		АналитикаДоходов = Объект.Организация;
		
	ИначеЕсли СтатьяДоходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия") Тогда
		
		Если Объект.Свойство("Подразделение") Тогда
			АналитикаДоходов = Объект.Подразделение;
		Иначе
			АналитикаДоходов = Подразделение;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат АналитикаДоходов;
	
КонецФункции

// Производит проверку заполнения реквизитов аналитик статей доходов в переданном объекте.
//
// Параметры:
// 		Объект - СправочникОбъект, ДокументОбъект, ДанныеФормыСтруктура - Объект ИБ предназначенный для проверки
// 		Реквизиты - Строка, Структура, Массив - Реквизиты статей доходов для проверки
// 			<Строка> Перечисление пар реквизитов для проверки в формате "СтатьяДоходов1, АналитикаДоходов1, СтатьяДоходов2, АналитикаДоходов2, ..."
// 				Пустая строка трактуется как "СтатьяДоходов, АналитикаДоходов"
// 			<Структура> Ключ: Строка с именем табличной части; Значение - Строка в нотации как у параметра типа <Строка>
// 			<Массив> Массив, элементы которого либо структуры в нотации как у параметра с типа <Структура>, либо строки в нотации <Строка>
// 		НепроверяемыеРеквизиты - Массив - Массив для накопления не проверяемых реквизитов переданного объекта
// 		Отказ - Булево - Признак наличия ошибок заполнения аналитик переданного объекта
// 		ДополнительныеПараметры - Структура - При наличии свойства "ПрограммнаяПроверка", ошибки записываются в эту структуру, пользователю не выводятся.
//
Процедура ПроверитьЗаполнениеАналитик(Объект, Реквизиты = "", НепроверяемыеРеквизиты = Неопределено, Отказ = Ложь,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	Ошибки = Новый Структура;
	Ошибки.Вставить("СписокОшибок", Новый Массив);
	Ошибки.Вставить("ГруппыОшибок", Новый Соответствие);
	Ошибки.Вставить("ПрефиксОбъекта", ?(ТипЗнч(Объект)=Тип("ФормаКлиентскогоПриложения"), "", "Объект."));
	
	МассивОбработки = Новый Массив;
	Если ТипЗнч(Реквизиты) = Тип("Массив") Тогда
		МассивОбработки = Реквизиты;
	Иначе
		МассивОбработки.Добавить(Реквизиты);
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из МассивОбработки Цикл
		
		Если ТипЗнч(ЭлементМассива) = Тип("Структура") Тогда
			ПроверкаЗаполненияАналитикТЧОбъекта(Объект, ЭлементМассива, НепроверяемыеРеквизиты, Ошибки);
		Иначе
			ПроверкаЗаполненияАналитикОбъекта(Объект, ЭлементМассива, НепроверяемыеРеквизиты, Ошибки);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ПрограммнаяПроверка") Тогда
		ДополнительныеПараметры.Вставить("Ошибки", Ошибки);
	Иначе
		Если Ошибки.СписокОшибок.Количество() <> 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает статьи доходов, использование которых запрещено
//
// Возвращаемое значение:
// 	СписокЗначений - Список заблокированных статей доходов.
//
Функция ЗаблокированныеСтатьиДоходов() Экспорт
	
	ЗаблокированныеСтатьи = Новый СписокЗначений;
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ЗакрытиеРезервовПоСомнительнымДолгам);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
		ЗаблокированныеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС);
	КонецЕсли;
	
	Возврат ЗаблокированныеСтатьи;
	
КонецФункции

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	#Область ВыручкаОтПродаж
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ВыручкаОтПродаж";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.НаправленияДеятельности"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Выручка от продаж'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000001";
	Элемент.РеквизитДопУпорядочивания = 1;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область ДоходыПриКонвертацииВалюты
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ДоходыПриКонвертацииВалюты";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.АналитикаКурсовыхРазниц"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Доходы при конвертации валюты'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000007";
	Элемент.РеквизитДопУпорядочивания = 4;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область ЗакрытиеРезервовПоСомнительнымДолгам
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ЗакрытиеРезервовПоСомнительнымДолгам";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Закрытие резервов по сомнительным долгам'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000006";
	Элемент.РеквизитДопУпорядочивания = 2;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область КурсовыеРазницы
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "КурсовыеРазницы";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ПеречислениеСсылка.АналитикаКурсовыхРазниц"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Курсовые разницы'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000002";
	Элемент.РеквизитДопУпорядочивания = 3;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область ПрибыльУбытокПрошлыхЛет
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПрибыльУбытокПрошлыхЛет";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Организации"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Прибыль (убыток) прошлых лет'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000005";
	Элемент.РеквизитДопУпорядочивания = 5;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Партнеры"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
	МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Разницы стоимости возврата и фактической стоимости товаров'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000003";
	Элемент.РеквизитДопУпорядочивания = 6;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	#КонецОбласти

	#Область ОтклонениеВСтоимостиТоваров
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОтклонениеВСтоимостиТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.Номенклатура"));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	Элемент.ТипЗначения = ОписаниеТипа;
    МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", "ru = 'Отклонение в стоимости товаров'", КодыЯзыков); // @НСтр-2
	Элемент.Код = "000000008";
	Элемент.РеквизитДопУпорядочивания = 8;
	Элемент.ДоговорыКредитовИДепозитов = Ложь;
	Элемент.ПринятиеКНалоговомуУчету = Истина;
	Элемент.ДоходыПоОбъектамЭксплуатации = Ложь;
	Элемент.ДоходыПоНМАиНИОКР = Ложь;
	Элемент.КонтролироватьЗаполнениеАналитики = Ложь;
	
	#КонецОбласти

КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - ПланВидовХарактеристикОбъект.СтатьиДоходов - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Заполняет реквизиты параметров настройки счетов учета доходов, которые влияют на настройку,
// 	соответствующими им именам реквизитов аналитики учета.
//
// Параметры:
// 	СоответствиеИмен - Соответствие - ключом выступает имя реквизита, используемое в настройке счетов учета,
// 		значением является соответствующее имя реквизита аналитики учета.
// 
Процедура ЗаполнитьСоответствиеРеквизитовНастройкиСчетовУчета(СоответствиеИмен) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДоходыИРасходыСервер.ОбработкаПолученияДанныхВыбораПВХСтатьиДоходов(ДанныеВыбора, Параметры, СтандартнаяОбработка);

КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункцииЗаполненияАналитик

Функция ОбязательныеСтатьи(МассивСтатей)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Статьи.Ссылка КАК Ссылка
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиДоходов КАК Статьи
	|ГДЕ
	|	Статьи.Ссылка В (&МассивСтатей)
	|	И Статьи.КонтролироватьЗаполнениеАналитики");
	
	Запрос.УстановитьПараметр("МассивСтатей", МассивСтатей);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция ИменаРеквизитовСтатьиИАналитики(СтрокаРеквизитов, НепроверяемыеРеквизиты = Неопределено, ПрефиксТабличнойЧасти = "")
	
	Если ПустаяСтрока(СтрокаРеквизитов) Тогда
		Если НепроверяемыеРеквизиты <> Неопределено Тогда
			НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + "АналитикаДоходов");
		КонецЕсли;
		Возврат Новый Структура("СтатьяДоходов", "АналитикаДоходов");
	КонецЕсли;
	
	СтруктураОбработки = Новый Структура(СтрокаРеквизитов);
	СтруктураВозврата = Новый Структура;
	ПредыдущийКлюч = Неопределено;
	Для Каждого КлючИЗначение Из СтруктураОбработки Цикл
		Если ПредыдущийКлюч = Неопределено Тогда
			ПредыдущийКлюч = КлючИЗначение.Ключ;
		Иначе
			СтруктураВозврата.Вставить(ПредыдущийКлюч, КлючИЗначение.Ключ);
			ПредыдущийКлюч = Неопределено;
			Если НепроверяемыеРеквизиты <> Неопределено Тогда
				НепроверяемыеРеквизиты.Добавить(ПрефиксТабличнойЧасти + КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура ПроверкаЗаполненияАналитикОбъекта(Объект, Реквизиты, НепроверяемыеРеквизиты, Ошибки)
	
	СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(Реквизиты, НепроверяемыеРеквизиты);
	МассивСтатей = Новый Массив;
	
	// Определим список статей для контроля
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		Статья = Объект[КлючИЗначение.Ключ];
		
		Если ЗначениеЗаполнено(Статья) Тогда
			МассивСтатей.Добавить(Статья);
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверим заполнение аналитики
	ОбязательныеСтатьи = ОбязательныеСтатьи(МассивСтатей);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		
		Статья = Объект[КлючИЗначение.Ключ];
		Аналитика = Объект[КлючИЗначение.Значение];
		
		Если Не (ОбязательныеСтатьи.Найти(Статья) = Неопределено Или ЗначениеЗаполнено(Аналитика)) Тогда
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки,
				Ошибки.ПрефиксОбъекта + КлючИЗначение.Значение,
				НСтр("ru='Аналитика доходов не заполнена'"), "");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаЗаполненияАналитикТЧОбъекта(Объект, Реквизиты, НепроверяемыеРеквизиты, Ошибки)
	
	// Определим список статей для контроля
	ОбщийМассивСтатей = Новый Массив;
	Для Каждого ОписаниеТЧ Из Реквизиты Цикл
		
		ИмяТЧ = ОписаниеТЧ.Ключ;
		
		СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(ОписаниеТЧ.Значение, НепроверяемыеРеквизиты, ИмяТЧ + ".");
		
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			
			МассивСтатей = Объект[ИмяТЧ].ВыгрузитьКолонку(КлючИЗначение.Ключ);
			Для Каждого Статья Из МассивСтатей Цикл
				ОбщийМассивСтатей.Добавить(Статья);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Проверим заполнение аналитики
	ОбязательныеСтатьи = ОбязательныеСтатьи(ОбщийМассивСтатей);
	Для Каждого ОписаниеТЧ Из Реквизиты Цикл // Табличные части
		
		ИмяТЧ = ОписаниеТЧ.Ключ;
		ТЧ = Объект[ИмяТЧ];
		
		МетаданныеОбъекта = Объект.Метаданные();
		ТабличнаяЧасть = МетаданныеОбъекта.ТабличныеЧасти.Найти(ИмяТЧ);
		
		СтруктураРеквизитов = ИменаРеквизитовСтатьиИАналитики(ОписаниеТЧ.Значение, Неопределено, ИмяТЧ + ".");
		
		Для Индекс = 0 По ТЧ.Количество() - 1 Цикл // Строки табличной части
			
			СтрокаТЧ = ТЧ[Индекс];
			
			Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
				
				РеквизитАналитика = ТабличнаяЧасть.Реквизиты.Найти(КлючИЗначение.Значение);
				
				Статья = СтрокаТЧ[КлючИЗначение.Ключ];
				Аналитика = СтрокаТЧ[КлючИЗначение.Значение];
				
				Если Не (ОбязательныеСтатьи.Найти(Статья) = Неопределено Или ЗначениеЗаполнено(Аналитика)) Тогда
					
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
						Ошибки,
						Ошибки.ПрефиксОбъекта + ИмяТЧ + "[%1]." + КлючИЗначение.Значение,
						СтрШаблон(НСтр("ru='Не заполнено поле ""%1"" в строке %2 списка ""%3""'"), 
							РеквизитАналитика.Синоним, СтрокаТЧ.НомерСтроки, ТабличнаяЧасть.Синоним),
						ИмяТЧ,
						Индекс,
						СтрШаблон(НСтр("ru='Не заполнено поле ""%1"" в строке %2 списка ""%3""'"), 
							РеквизитАналитика.Синоним, СтрокаТЧ.НомерСтроки, ТабличнаяЧасть.Синоним));
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновленияУТ(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ПланыВидовХарактеристик.СтатьиДоходов.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "11.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1986adbd-e9cf-4a2a-8ea0-c0b01ed6f39b");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ПланыВидовХарактеристик.СтатьиДоходов.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиДоходов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиДоходов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.ПланыВидовХарактеристик.СтатьиДоходов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();


КонецПроцедуры

// Регистрирует данные для обработчика обновления.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	СтатьиДоходовЛокализация.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// Обработчик обновления 2.5.5.
// Заполняет реквизит ВидПрочихДоходовИРасходов для статьи доходов "Отклонение в стоимости товаров". 
// 
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "ПланВидовХарактеристик.СтатьиДоходов";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			
			Блокировка.Заблокировать();
			
			ДанныеОбъекта = Выборка.Ссылка.ПолучитьОбъект();
			Если ДанныеОбъекта = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			СтатьиДоходовЛокализация.ЗаполнитьРеквизитыПредопределеннойСтатьиДоходов(ДанныеОбъекта);
			
			Если ДанныеОбъекта.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДанныеОбъекта);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать объект: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									Выборка.Ссылка.Метаданные(),
									Выборка.Ссылка,
									ТекстСообщения);
									
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

//-- НЕ УТ

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.ПланыВидовХарактеристик.СтатьиДоходов);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.ПланыВидовХарактеристик.СтатьиДоходов, Ложь, "Наименование");
	
КонецПроцедуры

Процедура ЗаполнитьПредопределенныеСтатьиДоходов() Экспорт
	
	МассивСтатейДоходов = Новый Массив;
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ЗакрытиеРезервовПоСомнительнымДолгам);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ДоходыПриКонвертацииВалюты);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ПрибыльУбытокПрошлыхЛет);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС);
	МассивСтатейДоходов.Добавить(ПланыВидовХарактеристик.СтатьиДоходов.ОтклонениеВСтоимостиТоваров);
	
	Для каждого Статья Из МассивСтатейДоходов Цикл
		
		СтатьиДоходовОбъект = Статья.ПолучитьОбъект();
		
		Если Статья = ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.НаправленияДеятельности");
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.КурсовыеРазницы Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.ДоходыПриКонвертацииВалюты Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.РеализацияОС Тогда
			Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
				СтатьиДоходовОбъект.Наименование = НСтр("ru = 'Реализация прочих активов'");
				СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
			КонецЕсли;
		ИначеЕсли Статья = ПланыВидовХарактеристик.СтатьиДоходов.ОтклонениеВСтоимостиТоваров Тогда
			СтатьиДоходовОбъект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Номенклатура");
		КонецЕсли;
		СтатьиДоходовЛокализация.ЗаполнитьРеквизитыПредопределеннойСтатьиДоходов(СтатьиДоходовОбъект);
		
		СтатьиДоходовОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
