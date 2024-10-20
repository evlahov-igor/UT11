﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ФормаОплаты");
	Результат.Добавить("Календарь");
	Результат.Добавить("Этапы");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "11.5.8.85";
	Обработчик.Процедура           = "Справочники.ГрафикиОплаты.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.РежимВыполнения     = "Отложенно";
	Обработчик.Идентификатор       = Новый УникальныйИдентификатор("d476f231-bd29-42c0-b9cf-601afd318698");
	Обработчик.Многопоточный       = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ГрафикиОплаты.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий         = НСтр("ru = 'Заполняет варианты отсчета графика и заменяет вариант оплаты ""Кредит (плановый)"" на ""Кредит (после отгрузки)"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ГрафикиОплаты.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ГрафикиОплаты.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ГрафикиОплаты.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.ГрафикиОплаты";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГрафикиОплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГрафикиОплаты.Этапы КАК ГрафикиОплаты
	|ГДЕ
	|	ГрафикиОплаты.ВариантОтсчета = ЗНАЧЕНИЕ(Перечисление.ВариантыОтсчетаДатыПлатежа.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта        = "Справочник.ГрафикиОплаты";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для Каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбъектИзменен = Ложь;
			
			Для Каждого Стр Из СправочникОбъект.Этапы Цикл
				
				Если НЕ ЗначениеЗаполнено(Стр.ВариантОтсчета) Тогда
					
					КредитныйЭтап = Стр.ВариантОплаты = Перечисления.ВариантыКонтроляОплатыКлиентом.КредитСдвиг
						ИЛИ Стр.ВариантОплаты = Перечисления.ВариантыКонтроляОплатыКлиентом.КредитПослеОтгрузки;
					
					Стр.ВариантОтсчета = ?(КредитныйЭтап,
						Перечисления.ВариантыОтсчетаДатыПлатежа.ОтДатыОтгрузки,
						Перечисления.ВариантыОтсчетаДатыПлатежа.ОтДатыЗаказа);
					ОбъектИзменен = Истина;
					
				КонецЕсли;
			КонецЦикла;
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли