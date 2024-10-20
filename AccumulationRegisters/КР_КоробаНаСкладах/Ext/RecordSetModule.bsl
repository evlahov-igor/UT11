﻿////////////////////////////////////////////////////
//// Модуль набора записей регистра накопления "КР_КоробаНаСкладах"
//// Создан: 01.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
//// Разработка по ФДР С11.032 Документы "Отбор (размещение) товаров" и "Перемещение товаров"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// << 11.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
	КР_ПроведениеДокументовПереопределяемый.МагазинВыполнитьОтсечениеДвиженийПоСкладам(ЭтотОбъект);
	// >> 11.11.2022 Марченко С.Н., КРОК, JIRA№A2105505-751
	
	ОбщегоНазначенияУТ.СвернутьНаборЗаписей(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Или 
		Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
			
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу "ДвиженияПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый", ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Склад КАК Склад,
	|	Таблица.Короб КАК Короб,
	// << 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтгрузке
	|		ИНАЧЕ -Таблица.КОтгрузке
	|	КОНЕЦ КАК КОтгрузкеПередЗаписью,
	// >> 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.ВНаличии
	|		ИНАЧЕ -Таблица.ВНаличии
	|	КОНЕЦ КАК ВНаличииПередЗаписью
	|ПОМЕСТИТЬ ДвиженияПередЗаписью
	|ИЗ
	|	РегистрНакопления.КР_КоробаНаСкладах КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка 
		Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Склад КАК Склад,
	|	ТаблицаИзменений.Короб КАК Короб,
	// << 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|	СУММА(ТаблицаИзменений.КОтгрузкеИзменение) КАК КОтгрузкеИзменение,
	// >> 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение) КАК ВНаличииИзменение
	|ПОМЕСТИТЬ КР_ДвиженияКоробаНаСкладахИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Склад КАК Склад,
	|		Таблица.Короб КАК Короб,
		// << 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|		Таблица.КОтгрузкеПередЗаписью КАК КОтгрузкеИзменение,
	// >> 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|		Таблица.ВНаличииПередЗаписью КАК ВНаличииИзменение
	|	ИЗ
	|		ДвиженияПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Склад,
	|		Таблица.Короб,
	// << 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КОтгрузке
	|			ИНАЧЕ Таблица.КОтгрузке
	|		КОНЕЦ,
	// >> 28.11.2022,  Федоров Д.Е.,  КРОК,  Jira№A2105505-933
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.ВНаличии
	|			ИНАЧЕ Таблица.ВНаличии
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.КР_КоробаНаСкладах КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.Короб
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.ВНаличииИзменение) > 0
	// << 06.04.2023  Федоров Д.Е.,  КРОК,  JIRA№A2105505-955
	// При уменьшении количества проверка отрицательных остатков не требуется.
	|	ИЛИ СУММА(ТаблицаИзменений.КОтгрузкеИзменение) > 0
	// >> 06.04.2022,  Федоров Д.Е.,  КРОК,  Jira№JIRA№A2105505-955
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияПередЗаписью";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет()[0]; // РезультатЗапроса
	Выборка = РезультатЗапроса.Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"КР_ДвиженияКоробаНаСкладахИзменение", Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли