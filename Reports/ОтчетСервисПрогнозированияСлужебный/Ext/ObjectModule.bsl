﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводитьГруппировкуПоАналогамНоменклатуры = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек,
		"ВыводитьГруппировкуПоАналогамНоменклатуры");
	
	Если ВыводитьГруппировкуПоАналогамНоменклатуры <> Неопределено 
		И ВыводитьГруппировкуПоАналогамНоменклатуры.Использование
		И ВыводитьГруппировкуПоАналогамНоменклатуры.Значение Тогда
		
		НастройкиСервиса = СервисПрогнозирования.ПолучитьНастройкиСервиса();
		АналогСвойство = НастройкиСервиса.РеквизитАналогиТовараСвойство;
		Если ЗначениеЗаполнено(АналогСвойство) Тогда
			СтрокиКомпоновки = НастройкиОтчета.Структура[0].Строки;
			СтрокиКомпоновки.Очистить();
			
			ШаблонДопСвойства = "Номенклатура.[%1]";
			ПредставлениеСвойстваАналога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АналогСвойство, "Представление");
			
			КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(НастройкиОтчета, СтрШаблон(ШаблонДопСвойства, ПредставлениеСвойстваАналога));
			КомпоновкаДанныхКлиентСервер.ДобавитьГруппировку(НастройкиОтчета, "Номенклатура");
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	
	ПериодичностьОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодичностьОтчета");
	Если ПериодичностьОтчета <> Неопределено Тогда
		Если ПериодичностьОтчета.Значение = Перечисления.Периодичность.Неделя Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "НЕДЕЛЯ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Декада Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "ДЕКАДА)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Месяц Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "МЕСЯЦ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Квартал Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "КВАРТАЛ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Полугодие Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "ПОЛУГОДИЕ)");
		ИначеЕсли ПериодичностьОтчета.Значение = Перечисления.Периодичность.Год Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДЕНЬ)", "ГОД)");
		КонецЕсли;
	КонецЕсли;

	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
