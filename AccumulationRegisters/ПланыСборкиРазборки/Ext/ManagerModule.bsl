﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(Сценарий)
	|	И ЗначениеРазрешено(ВидПлана)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ПланыСборкиРазборки.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.3.10";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("70a6e8c4-011c-4d99-8cf5-b8c8ed1d809f");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПланыСборкиРазборки.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документа ""Планы сборки (разборки)"" по регистру накопления ""Планы сборки (разборки)"":
	| - заполняет ресурс ""К заказу"" и ""Количество"" в соответствии с признаками ""Замещен"" и ""Замещен к заказу""
	| - заполняет измерение ""Вид плана"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ПланСборкиРазборки.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПланыСборкиРазборки.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

КонецПроцедуры

// Процедура регистрации данных для обработчика обновления ОбработатьДанныеДляПереходаНаВерсию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПланСборкиРазборки";
	ПолноеИмяРегистра = "РегистрНакопления.ПланыСборкиРазборки";
	ИмяРегистра       = "ПланыСборкиРазборки";
	
	ТекстЗапроса = Документы.ПланСборкиРазборки.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапроса, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.ПланСборкиРазборки.ТекстЗапросаДанныеКОбработке();
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Регистраторы, ЗапросПакет[4].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ПланСборкиРазборки");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
		"РегистрНакопления.ПланыСборкиРазборки", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
