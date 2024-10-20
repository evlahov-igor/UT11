﻿#Область ПрограммныйИнтерфейс

// Открыват форму для выбора шаблона этикетки для печати.
// 
// Параметры:
// 	ДанныеДляПечати - Структура - Структура данных для печати.
// 	Форма - ФормаКлиентскогоПриложения - Источник (фарма) команды печати.
// 	СтандартнаяОбработка - Булево - Признак необходимости выполнять печать БГосИС.
// 	ДополнительныеПараметры - Структура - Дополнительные параметры для открытия формы.
Процедура ОткрытьФормуВыбораШаблонаЭтикеткиИСМППоДаннымПечати(
	ДанныеДляПечати, Форма, СтандартнаяОбработка, ДополнительныеПараметры=Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Перем Оповещение;
	Перем ПереданныеПараметрыОткрытия;
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("АдресВХранилище", ПоместитьВоВременноеХранилище(ДанныеДляПечати));
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		ДополнительныеПараметры.Свойство("Оповещение", Оповещение);
		
		Если ДополнительныеПараметры.Свойство("Параметры", ПереданныеПараметрыОткрытия) Тогда
			Для Каждого КлючЗначение Из ПереданныеПараметрыОткрытия Цикл
				ПараметрыОткрытия.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаШтрихкодыЭтикетокИСМП",
		ПараметрыОткрытия,
		Форма,
		Новый УникальныйИдентификатор,,,
		Оповещение);
	//-- НЕ ГОСИС
	Возврат;
		
КонецПроцедуры

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//  ОбъектыПечати        - Структура        - структура с описанием данных печати:
//   * ОбъектыПечати - Массив из ПечатьЭтикетокИСМПКлиентСервер.СтруктураПечатиЭтикетки - строки описания товаров
//     и кодов для печати
//   * Документ - ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ,
//     ОпределеямыйТип.ОснованиеЗаказНаЭмиссиюКодовМаркировкиИСМП - Документ, в рамках которого выполняется печать.
//   * КаждаяЭтикеткаНаНовомЛисте - Булево - Выводить разрыв страницы после каждой этикетки (для термопечати этикетки).
//  Форма                - ФормаКлиентскогоПриложения - форма-владелец из которой выполняется печать.
//  СтандартнаяОбработка - Булево           - Отключает печать встроенными средставами библиотеки.
Процедура ПечатьЭтикеткиИСМП(ДанныеПечати, Форма, СтандартнаяОбработка) Экспорт

	//++ НЕ ГОСИС
	СтандартнаяОбработка = Ложь;
	
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Вид",            "Печать");
	ОписаниеКоманды.Вставить("Идентификатор",  "ЭтикеткаПоПереданнымДаннымОбувь");
	ОписаниеКоманды.Вставить("СтруктураДанных", ДанныеПечати);
	ОписаниеКоманды.Вставить("Представление",  НСтр("ru = 'Печать: Этикетка (обувь, одежда, табак...)'"));
	ОписаниеКоманды.Вставить("Форма",          Форма);
	
	УправлениеПечатьюУТКлиентЛокализация.ПечатьЭтикетокОбувь(ОписаниеКоманды);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти