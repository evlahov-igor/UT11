﻿#Область ПрограммныйИнтерфейс

// Обновляет статус проверки маркируемой продукции при изменении количества/состава строк по кешированным данным
//   состава табличной части "Штрихкоды упаковок".
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - редактируемая форма.
//   ТабличнаяЧастьТовары - ДанныеФормыКоллекция - редактируемая таблица.
//   ДанныеСтроки - ДанныеФормыЭлементКоллекции - редактируемая строка.
//   ДанныеКешаСтроки - Структура - данные строки перед редактированием.
//   ВсеТоварыМаркируемые - Булево - Обработка всех маркируемых товаров.
//   ДополнительныеКлючи - Строка - дополнительные ключи связи строк товаров и кеша штрихкодов упаковок.
//   ИмяКолонкиКоличество - Строка - имя колонки "Количество" в табличной части документа.
// Возвращаемое значение:
//   Булево - требуется пересчет кеша для всей табличной части.
Функция ПрименитьКешПоСтроке(Форма, ТабличнаяЧастьТовары, ДанныеСтроки, ДанныеКешаСтроки, ВсеТоварыМаркируемые = Ложь, ДополнительныеКлючи = "", ИмяКолонкиКоличество = "Количество") Экспорт
	
	КлючСвязиИзменен = ДанныеСтроки.Номенклатура<>ДанныеКешаСтроки.Номенклатура
		ИЛИ (ДанныеКешаСтроки.Свойство("Характеристика")
			И ДанныеСтроки.Характеристика<>ДанныеКешаСтроки.Характеристика)
		ИЛИ (ДанныеКешаСтроки.Свойство("Серия")
			И ДанныеСтроки.Серия<>ДанныеКешаСтроки.Серия);
	Для Каждого КлючСвязи Из СтрРазделить(ДополнительныеКлючи, ",", Ложь) Цикл
		КлючСвязиИзменен = КлючСвязиИзменен ИЛИ ДанныеСтроки[СокрЛП(КлючСвязи)]<>ДанныеКешаСтроки[СокрЛП(КлючСвязи)];
	КонецЦикла;

	МассивКлючейСвязи = Новый Массив;
	МассивКлючейСвязи.Добавить("Номенклатура");
	Если ДанныеКешаСтроки.Свойство("Характеристика") Тогда
		МассивКлючейСвязи.Добавить("Характеристика");
	КонецЕсли;
	Если ДанныеКешаСтроки.Свойство("Серия") Тогда
		МассивКлючейСвязи.Добавить("Серия");
	КонецЕсли;
	Для Каждого КлючСвязи Из СтрРазделить(ДополнительныеКлючи, ",", Ложь) Цикл
		МассивКлючейСвязи.Добавить(СокрЛП(КлючСвязи));
	КонецЦикла;
	
	СтруктураПоиска = Новый Структура(СтрСоединить(МассивКлючейСвязи, ","));
	
	// Дополнительное поле сравнения
	ЕстьКоличествоПотребительскихКодов = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеСтроки, "КоличествоПотребительскихУпаковок");
	
	Если КлючСвязиИзменен И (ВсеТоварыМаркируемые Или ДанныеКешаСтроки.МаркируемаяПродукция) Тогда
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ДанныеКешаСтроки);
		
		СтрокиКеша = Форма.ДанныеШтрихкодовУпаковокГосИС.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокиКеша.Количество() Тогда
			
			СтрокиТовары = ТабличнаяЧастьТовары.НайтиСтроки(СтруктураПоиска);
			Если НЕ СтрокиТовары.Количество() Тогда
				Возврат Истина; // Требуется удалить штрихкоды из табличной части штрихкодов и пересчитать кеш
			КонецЕсли;
			
			КоличествоПоКлючу = 0;
			КоличествоКодовПоКлючу = 0;
			Для Каждого СтрокаПоКлючу Из СтрокиТовары Цикл
				КоличествоПоКлючу = КоличествоПоКлючу + СтрокаПоКлючу[ИмяКолонкиКоличество];
				Если ЕстьКоличествоПотребительскихКодов Тогда
					КоличествоКодовПоКлючу = КоличествоКодовПоКлючу + СтрокаПоКлючу.КоличествоПотребительскихУпаковок;
				КонецЕсли;
			КонецЦикла;
			
			Если КоличествоПоКлючу = СтрокиКеша[0].Количество
				И (Не ЕстьКоличествоПотребительскихКодов Или КоличествоКодовПоКлючу = СтрокиКеша[0].КоличествоПотребительскихУпаковок)Тогда
				СтатусПроверкиГосИС = 1;
			ИначеЕсли СтрокиКеша[0].БезКоличества И Не ЕстьКоличествоПотребительскихКодов Тогда
				СтатусПроверкиГосИС = 3;
			Иначе
				СтатусПроверкиГосИС = 2;
			КонецЕсли;
			Для Каждого СтрокаПоКлючу Из СтрокиТовары Цикл
				СтрокаПоКлючу.СтатусПроверкиГосИС = СтатусПроверкиГосИС;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВсеТоварыМаркируемые Или ДанныеСтроки.МаркируемаяПродукция Тогда
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, ДанныеСтроки);
		СтрокиКеша = Форма.ДанныеШтрихкодовУпаковокГосИС.НайтиСтроки(СтруктураПоиска);
		СтрокиТовары = ТабличнаяЧастьТовары.НайтиСтроки(СтруктураПоиска);
		
		КоличествоПоКлючу = 0;
		КоличествоКодовПоКлючу = 0;
		Для Каждого СтрокаПоКлючу Из СтрокиТовары Цикл
			КоличествоПоКлючу = КоличествоПоКлючу + СтрокаПоКлючу[ИмяКолонкиКоличество];
			Если ЕстьКоличествоПотребительскихКодов Тогда
				КоличествоКодовПоКлючу = КоличествоКодовПоКлючу + СтрокаПоКлючу.КоличествоПотребительскихУпаковок;
			КонецЕсли;
		КонецЦикла;
		
		Если СтрокиКеша.Количество() = 0 Тогда
			СтатусПроверкиГосИС = 2;
		ИначеЕсли (КоличествоПоКлючу = СтрокиКеша[0].Количество)
				И (Не ЕстьКоличествоПотребительскихКодов Или КоличествоКодовПоКлючу = СтрокиКеша[0].КоличествоПотребительскихУпаковок) Тогда
			СтатусПроверкиГосИС = 1;
		ИначеЕсли СтрокиКеша[0].БезКоличества И Не ЕстьКоличествоПотребительскихКодов Тогда
			СтатусПроверкиГосИС = 3;
		Иначе
			СтатусПроверкиГосИС = 2;
		КонецЕсли;
		Для Каждого СтрокаПоКлючу Из СтрокиТовары Цикл
			СтрокаПоКлючу.СтатусПроверкиГосИС = СтатусПроверкиГосИС;
		КонецЦикла;
		
	Иначе
		ДанныеСтроки.СтатусПроверкиГосИС = 0;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

Процедура ЗаполнитьЗначенияСтрокДереваДляРасчетаХешСумм(ЗначенияСтрокДерева, СтрокиДереваУпаковок) Экспорт
	
	Для Каждого СтрокаДереваУпаковок Из СтрокиДереваУпаковок Цикл
		ДанныеСтроки = Новый Структура();
		
		ДанныеСтроки.Вставить("ТипУпаковки");
		ДанныеСтроки.Вставить("СтатусПроверки");
		ДанныеСтроки.Вставить("Штрихкод");
		ДанныеСтроки.Вставить("ХешСуммаНормализации");
		
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаДереваУпаковок);
		
		ДанныеСтроки.Вставить("ИдентификаторСтроки", СтрокаДереваУпаковок.ПолучитьИдентификатор());
		ДанныеСтроки.Вставить("ХешСумма",            "");
		ДанныеСтроки.Вставить("Строки",              Новый Массив());
		
		ПодчиненныеСтрокиДереваУпаковок = СтрокаДереваУпаковок.ПолучитьЭлементы();
		
		Если ПодчиненныеСтрокиДереваУпаковок.Количество() > 0 Тогда
			ЗаполнитьЗначенияСтрокДереваДляРасчетаХешСумм(ДанныеСтроки.Строки, ПодчиненныеСтрокиДереваУпаковок);
		КонецЕсли;
		
		ЗначенияСтрокДерева.Добавить(ДанныеСтроки);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьХешСуммыВСтрокахДереваУпаковок(ЗначенияСтрокДерева, ДеревоУпаковок) Экспорт
	
	Для Каждого ДанныеСтроки Из ЗначенияСтрокДерева Цикл
		СтрокаДереваУпаковок = ДеревоУпаковок.НайтиПоИдентификатору(ДанныеСтроки.ИдентификаторСтроки);
		
		Если СтрокаДереваУпаковок <> Неопределено Тогда
			СтрокаДереваУпаковок.ХешСумма = ДанныеСтроки.ХешСумма;
		КонецЕсли;
		
		Если ДанныеСтроки.Строки.Количество() > 0 Тогда
			ЗаполнитьХешСуммыВСтрокахДереваУпаковок(ДанныеСтроки.Строки, ДеревоУпаковок);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

