﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Функция СформироватьНаименованиеПоРеквизитам()
//	
//	
//	Для Каждого Строка Из РеквизитыОбъекта.РеквизитыХарактеристикДляКлючаЦен Цикл
//		Если Строка.ЭтоДопРеквизит Тогда
////			НоваяСтрокаДополнительныхРеквизитов = СерияЦенообразования.ДополнительныеРеквизитыЦенообразования.Добавить();
////			ЗаполнитьЗначенияСвойств(НоваяСтрокаДополнительныхРеквизитов, Строка);
//		Иначе
////			СерияЦенообразования[Строка.ИмяРеквизита] = Строка.Значение;
//		КонецЕсли;
//	КонецЦикла;
//	
//	
//КонецФункции

#КонецОбласти

#КонецЕсли
