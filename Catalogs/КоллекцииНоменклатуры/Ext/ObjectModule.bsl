﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДатаНачалаЗакупок) 
		И ЗначениеЗаполнено(ДатаЗапретаЗакупки) 
		И ДатаНачалаЗакупок = ДатаЗапретаЗакупки Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Период закупок должен быть больше одного дня.'"),
			ЭтотОбъект,
			"ДатаЗапретаЗакупки",
			,
			Отказ);
		
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ДатаНачалаПродаж) 
		И ЗначениеЗаполнено(ДатаЗапретаПродажи) 
		И ДатаНачалаПродаж = ДатаЗапретаПродажи Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Период продаж должен быть больше одного дня.'"),
			ЭтотОбъект,
			"ДатаЗапретаПродажи",
			,
			Отказ);
		
	КонецЕсли;
	
	// << 05.08.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-324
	КР_ОбработкаПроверкиЗаполненияДополнительно(Отказ, ПроверяемыеРеквизиты);
	// >> 05.08.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-324
	
КонецПроцедуры

#КонецОбласти

#Область КР_ДобавленныеПроцедурыИФункции 

// << 05.08.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-324
Процедура КР_ОбработкаПроверкиЗаполненияДополнительно(Отказ, ПроверяемыеРеквизиты)
	
	МассивПроверяемыхРеквизитов = Новый Массив;
	МассивПроверяемыхРеквизитов.Добавить("Код");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПроверяемыеРеквизиты, МассивПроверяемыхРеквизитов, Истина);
	
КонецПроцедуры // >> 05.08.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-324
        
#КонецОбласти

#КонецЕсли