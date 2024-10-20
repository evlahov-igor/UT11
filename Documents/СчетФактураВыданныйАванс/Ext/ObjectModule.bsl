﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СчетФактураВыданныйАвансЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СчетФактураВыданныйАвансЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "Авансы";
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	
	Если ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатков")
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатковВзаиморасчетов")
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВзаимозачетЗадолженности") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(НомерПлатежноРасчетногоДокумента)
		И НЕ ЗначениеЗаполнено(ДатаПлатежноРасчетногоДокумента) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НомерПлатежноРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежноРасчетногоДокумента");
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетФактураОснование");
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	Если НЕ Корректировочный Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Авансы.ИсходныйСчетФактура");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетФактураВыданныйАвансЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьДублиСчетФактуры(Отказ);
	КонецЕсли;
	
	Сумма    = Авансы.Итог("Сумма");
	СуммаНДС = Авансы.Итог("СуммаНДС");
	
	СформироватьСтрокуРасчетноПлатежныхДокументов();
	ЗаполнитьДатуПолученияАванса();
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Авансы");
	
	СчетФактураВыданныйАвансЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		РучнаяКорректировкаЖурналаСФ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Исправление Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СчетФактураВыданныйАванс.Исправление
		|			ТОГДА СчетФактураВыданныйАванс.СчетФактураОснование
		|		ИНАЧЕ СчетФактураВыданныйАванс.Ссылка
		|	КОНЕЦ                          КАК Ссылка,
		|	СчетФактураВыданныйАванс.Номер КАК Номер
		|ПОМЕСТИТЬ ИсходныеДокументы
		|ИЗ Документ.СчетФактураВыданныйАванс КАК СчетФактураВыданныйАванс
		|ГДЕ
		|	СчетФактураВыданныйАванс.Ссылка = &СчетФактураОснование
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсходныеДокументы.Номер КАК Номер,
		|	ЕСТЬNULL(Исправления.НомерИсправления, 0) КАК НомерИсправления
		|ИЗ
		|	ИсходныеДокументы КАК ИсходныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданныйАванс КАК Исправления
		|		ПО ИсходныеДокументы.Ссылка = Исправления.СчетФактураОснование
		|			И ИсходныеДокументы.Ссылка <> Исправления.Ссылка
		|			И Исправления.Исправление
		|			И НЕ Исправления.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерИсправления УБЫВ");
		
		Запрос.УстановитьПараметр("СчетФактураОснование", СчетФактураОснование);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СтандартнаяОбработка = Ложь;
			// Установка номера и переопределение префикса информационной базы.
			ИспользоватьПрефикс = ПолучитьФункциональнуюОпцию("ВестиОтдельнуюНумерациюСчетовФактурНаАвансы");
			Если ИспользоватьПрефикс Тогда
				Префикс = "ИА";
				ДлинаПрефикса = 2;
			Иначе
				Префикс = "И";
				ДлинаПрефикса = 1;
			КонецЕсли;
			ПрефиксацияОбъектовСобытия.УстановитьПрефиксИнформационнойБазыИОрганизации(ЭтотОбъект, СтандартнаяОбработка, Префикс);
			
			НомерБезПрефикса = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(Выборка.Номер, Истина, Истина);
			Если СтрДлина(СокрП(НомерБезПрефикса)) = 7 Тогда
				НомерБезПрефикса = Прав(НомерБезПрефикса, СтрДлина(НомерБезПрефикса)-ДлинаПрефикса);
			КонецЕсли;
			Номер = Префикс + НомерБезПрефикса;
			НомерИсправления = Формат(Число(Выборка.НомерИсправления) + 1, "ЧЦ=10; ЧДЦ=0; ЧГ=0");
		КонецЕсли;
	Иначе
		ИспользоватьПрефикс = ПолучитьФункциональнуюОпцию("ВестиОтдельнуюНумерациюСчетовФактурНаАвансы");
		Если ИспользоватьПрефикс Тогда
			Префикс = "А";
		Иначе
			Префикс = "0";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Исправление") 
			 И ДанныеЗаполнения.Исправление
			 И ДанныеЗаполнения.Свойство("СчетФактураОснование") Тогда
			ЗаполнитьИсправлениеПоСчетуФактуре(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		РеквизитыЗаполнения = РеквизитыПриходныйКассовыйОрдер(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств") Тогда
		РеквизитыЗаполнения = РеквизитыПоступлениеБезналичныхДенежныхСредств(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетФактураПолученныйАванс") Тогда
		ЗаполнитьПоСчетуФактуреПолученномуАванс(ДанныеЗаполнения);
	КонецЕсли;
	
	СчетФактураВыданныйАвансЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Авансы");

	СчетФактураВыданныйАвансЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры
	

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если НЕ Отказ Тогда
		МассивДокументов= Новый Массив;
		МассивДокументов.Добавить(Ссылка);
		УчетНДСУП.СформироватьЗаданияПоДокументам(МассивДокументов);
	КонецЕсли;
	
	СчетФактураВыданныйАвансЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Подразделение") Тогда
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитыПриходныйКассовыйОрдер(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Дата					КАК Дата,
	|	ДанныеДокумента.Ссылка					КАК Ссылка,
	|	ДанныеДокумента.Проведен				КАК Проведен,
	|	ДанныеДокумента.ХозяйственнаяОперация	КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(тчРасшифровкаПлатежа.ОбъектРасчетов.Организация,
	|				ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация
	|		ИНАЧЕ
	|			тчРасшифровкаПлатежа.ОбъектРасчетов.Организация
	|	КОНЕЦ									КАК Организация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(тчРасшифровкаПлатежа.ОбъектРасчетов.Организация,
	|				ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Подразделение
	|		ИНАЧЕ
	|			тчРасшифровкаПлатежа.ОбъектРасчетов.Подразделение
	|	КОНЕЦ									КАК Подразделение,
	|	ВЫБОР КОГДА
	|		ДанныеДокумента.ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации)
	|		)
	|	ТОГДА
	|		ДанныеДокумента.КассаОтправитель.Владелец
	|	ИНАЧЕ
	|		ДанныеДокумента.Контрагент
	|	КОНЕЦ 									КАК Контрагент,
	|	ДанныеДокумента.НалогообложениеНДС		КАК НалогообложениеНДС
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК тчРасшифровкаПлатежа
	|			ПО ДанныеДокумента.Ссылка = тчРасшифровкаПлатежа.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция РеквизитыПоступлениеБезналичныхДенежныхСредств(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Дата					КАК Дата,
	|	ДанныеДокумента.Ссылка					КАК Ссылка,
	|	ДанныеДокумента.Проведен				КАК Проведен,
	|	ДанныеДокумента.ХозяйственнаяОперация	КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(тчРасшифровкаПлатежа.ОбъектРасчетов.Организация,
	|				ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация
	|		ИНАЧЕ
	|			тчРасшифровкаПлатежа.ОбъектРасчетов.Организация
	|	КОНЕЦ									КАК Организация,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(тчРасшифровкаПлатежа.ОбъектРасчетов.Организация,
	|				ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Подразделение
	|		ИНАЧЕ
	|			тчРасшифровкаПлатежа.ОбъектРасчетов.Подразделение
	|	КОНЕЦ									КАК Подразделение,
	|	ДанныеДокумента.ПроведеноБанком			КАК ПроведеноБанком,
	|	ВЫБОР КОГДА
	|		ДанныеДокумента.ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации)
	|		)
	|	ТОГДА
	|		ДанныеДокумента.БанковскийСчетОтправитель.Владелец
	|	ИНАЧЕ
	|		ДанныеДокумента.Контрагент
	|	КОНЕЦ 									КАК Контрагент,
	|	ДанныеДокумента.НалогообложениеНДС		КАК НалогообложениеНДС
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК тчРасшифровкаПлатежа
	|			ПО ДанныеДокумента.Ссылка = тчРасшифровкаПлатежа.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Процедура ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения)
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(РеквизитыЗаполнения.Ссылка, , НЕ РеквизитыЗаполнения.Проведен);
	
	ОперацииНДС = ХозяйственныеОперацииНДСАванс();
	Если ОперацииНДС.Найти(РеквизитыЗаполнения.ХозяйственнаяОперация) = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Не требуется вводить счет-фактуру на аванс на основании документа %Документ%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", РеквизитыЗаполнения.Ссылка);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(РеквизитыЗаполнения, "ПроведеноБанком")
		И РеквизитыЗаполнения.ПроведеноБанком <> Истина Тогда
		ТекстОшибки = НСтр("ru='Перед вводом счет-фактуры на аванс по документу %Документ% необходимо установить признак ""Проведено банком""'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", РеквизитыЗаполнения.Ссылка);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	НалогообложениеНДС = РеквизитыЗаполнения.НалогообложениеНДС;
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		КодВидаОперации = "33";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения, "Организация, Контрагент");
	РеквизитыКонтрагента = ПартнерыИКонтрагенты.РеквизитыКонтрагента(Контрагент, ТекущаяДатаСеанса());
	ИННКонтрагента = РеквизитыКонтрагента.ИНН;
	
	ДокументОснование	= РеквизитыЗаполнения.Ссылка;
	ДатаВыставления		= ТекущаяДатаСеанса();
	
	ВходящийНомерИДата = Документы.СчетФактураВыданныйАванс.ВходящийНомерИДатаДокумента(ДокументОснование, Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВходящийНомерИДата);
	
	Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		Запрос = Новый Запрос();
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
		|ГДЕ
		|	РасчетыСКлиентами.Регистратор = &Ссылка
		|	И РасчетыСКлиентами.Активность
		|";
		Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
		
		ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
		МассивАналитикУчетаПоПартнерам = ТаблицаАналитик.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам");
		
		Если МассивАналитикУчетаПоПартнерам.Количество() > 0 Тогда
			АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
			АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикУчетаПоПартнерам;
			Попытка
				РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(КонецМесяца(РеквизитыЗаполнения.Дата),АналитикиРасчета);
			Исключение
				ТекстСообщения = НСтр("ru ='Печатная форма сформирована по неактуальным данным.
				|Необходимо актуализировать взаиморасчеты вручную и переформировать печатную форму.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	ОтборАвансов = Документы.СчетФактураВыданныйАванс.ОтборПолученныхАвансов();
	ОтборАвансов.Вставить("НачалоПериода",		 НачалоДня(РеквизитыЗаполнения.Дата));
	ОтборАвансов.Вставить("КонецПериода",		 КонецКвартала(РеквизитыЗаполнения.Дата));
	ОтборАвансов.Вставить("Организация",		 Организация);
	ОтборАвансов.Вставить("РасчетныйДокумент",	 ДокументОснование);
	ОтборАвансов.Вставить("ПравилоОтбораАванса", Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.ВсеОплаты);
	
	ПолученныеАвансы = Документы.СчетФактураВыданныйАванс.ТаблицаПолученныеАвансы();
	Документы.СчетФактураВыданныйАванс.ЗаполнитьПолученныеАвансыДляСФ(ОтборАвансов, ПолученныеАвансы);
	
	ПравилоОтбораАванса = ОтборАвансов.ПравилоОтбораАванса;
	
	ПолученныеАвансы.Свернуть("СтавкаНДС,НаправлениеДеятельности", "Сумма, СуммаНДС");
	Для Каждого СтрокаАванса Из ПолученныеАвансы Цикл
		СтрокаДокумента = Авансы.Добавить();
		СтрокаДокумента.ТипЗапасов = Перечисления.ТипыЗапасов.Товар;
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаАванса);
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		// Заполним товары счета-фактуры по заказам
		Товары = Документы.СчетФактураВыданныйАванс.ТоварыЗаказовКлиентов(ДокументОснование);
		Если Товары.Количество() <> 0 Тогда
			ТаблицаАвансы = Авансы.Выгрузить();
			Документы.СчетФактураВыданныйАванс.РаспределитьАвансыПоТоварам(ТаблицаАвансы, Товары, ДокументОснование);
			Авансы.Загрузить(ТаблицаАвансы);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИсправлениеПоСчетуФактуре(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Основание = ДанныеЗаполнения.СчетФактураОснование;
	Иначе
		Основание = СчетФактураОснование;
		Исправление = Истина;
	КонецЕсли;
	
	ИсправляемыйДокументОбъект = Основание.ПолучитьОбъект();
	
	МассивИсключаемыхРеквизитов = Новый Массив;
	МассивИсключаемыхРеквизитов.Добавить("Номер");
	МассивИсключаемыхРеквизитов.Добавить("Дата");
	МассивИсключаемыхРеквизитов.Добавить("Проведен");
	МассивИсключаемыхРеквизитов.Добавить("ПометкаУдаления");
	МассивИсключаемыхРеквизитов.Добавить("Ссылка");
	МассивИсключаемыхРеквизитов.Добавить("Ответственный");
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ИсправляемыйДокументОбъект, , СтрСоединить(МассивИсключаемыхРеквизитов, ","));
	Для каждого ТабличнаяЧасть Из Метаданные().ТабличныеЧасти Цикл
		ЭтотОбъект[ТабличнаяЧасть.Имя].Загрузить(ИсправляемыйДокументОбъект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	Для каждого СтрокаАвансы Из ЭтотОбъект.Авансы Цикл
		СтрокаАвансы.ИдентификаторСтроки = "";
	КонецЦикла;
	
	Если ИсправляемыйДокументОбъект.Исправление Тогда
		СчетФактураОснование = ИсправляемыйДокументОбъект.СчетФактураОснование;
	Иначе
		СчетФактураОснование = ИсправляемыйДокументОбъект.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоСчетуФактуреПолученномуАванс(ДанныеЗаполнения)
	
	ДокументОснование = ДанныеЗаполнения;
	ПравилоОтбораАванса = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.ВсеОплаты;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, "Дата,Организация,НалогообложениеНДС,Подразделение");
	
	ВходящийНомерИДата = Документы.СчетФактураВыданныйАванс.ВходящийНомерИДатаДокумента(ДанныеЗаполнения.ДокументОснование, ДанныеЗаполнения.Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВходящийНомерИДата);
	
	Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Авансы Цикл
		СтрокаАванса = Авансы.Добавить();
		СтрокаАванса.ТипЗапасов = Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи;
		СтрокаАванса.Сумма = СтрокаТЧ.СуммаКомиссия;
		СтрокаАванса.СуммаНДС = СтрокаТЧ.СуммаНДСКомиссия;
		СтрокаАванса.СтавкаНДС = СтрокаТЧ.СтавкаНДС;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьДублиСчетФактуры(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка <> &Ссылка
	|	И ДанныеДокумента.ДокументОснование = &ДокументОснование
	|	И ДанныеДокумента.НалогообложениеНДС = &НалогообложениеНДС
	|	И ДанныеДокумента.Проведен
	|	И НЕ ДанныеДокумента.Исправление
	|	И ДанныеДокумента.Контрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если НЕ Исправление Тогда
		
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 уже введен счет-фактура %2'"),
				ДокументОснование,
				Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"ДокументОснование",
				,
				Отказ);
			
		ИначеЕсли Исправление И СчетФактураОснование <> Выборка.Ссылка Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На основании документа %1 введен счет-фактура %2. Недопустимо исправление счета-фактуры %3.'"),
				Выборка.ДокументОснование,
				Выборка.Ссылка,
				СчетФактураОснование);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				,
				,
				Отказ);
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСтрокуРасчетноПлатежныхДокументов()
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		СтрокаПлатежноРасчетныеДокументы = "";
		Возврат;
	КонецЕсли;
	
	СтрокаПлатежноРасчетныеДокументы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 от %2'"),
		НомерПлатежноРасчетногоДокумента,
		Формат(ДатаПлатежноРасчетногоДокумента, "ДЛФ=D"));

	Для Каждого СтрокаТаблицы Из ДокументыАвансовКомитента Цикл
		СтрокаПлатежноРасчетныеДокументы = СтрокаПлатежноРасчетныеДокументы
			+ ?(ПустаяСтрока(СтрокаПлатежноРасчетныеДокументы), "", ", ")
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 от %2'"),
				СтрокаТаблицы.НомерПлатежноРасчетногоДокумента,
				Формат(СтрокаТаблицы.ДатаПлатежноРасчетногоДокумента, "ДЛФ=D"));
	КонецЦикла;
		
КонецПроцедуры

Процедура ЗаполнитьДатуПолученияАванса()
	
	Если Исправление Тогда
		ДатаПолученияАванса = Дата;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РеестрДокументов.ДатаОтраженияВУчете, ДанныеПервичныхДокументов.ДатаРегистратора) КАК ДатаПолученияАванса
	|ИЗ
	|	РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО РеестрДокументов.Ссылка = &ДокументОснование
	|			И РеестрДокументов.Организация = &Организация
	|			И НЕ РеестрДокументов.ДополнительнаяЗапись
	|ГДЕ
	|	ДанныеПервичныхДокументов.Организация = &Организация
	|	И ДанныеПервичныхДокументов.Документ = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий()
		И ПравилоОтбораАванса <> Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеКвартала Тогда
			ДатаПолученияАванса = Выборка.ДатаПолученияАванса;
	Иначе
		ДатаПолученияАванса = Дата;
	КонецЕсли;
	
КонецПроцедуры

Функция ХозяйственныеОперацииНДСАванс()
	
	Операции = Новый Массив;
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации);
	
	Возврат Операции;
	
КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли
