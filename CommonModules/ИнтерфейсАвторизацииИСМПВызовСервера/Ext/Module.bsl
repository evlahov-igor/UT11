﻿#Область ПрограммныйИнтерфейс

#Область Авторизация

// Возвращает текущий ключ сессии для обмена с ИСМП.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДейтвия - Дата, Неопределено - Срок действия ключа сессии.
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
	
Функция ТекущийКлючСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	Попытка
		ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
	Исключение
		ДанныеКлючаСессии = Неопределено;
	КонецПопытки;
	
	// Ключ сессии еще не установлен
	Если ДанныеКлючаСессии = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДанныеКлючаСессии.Количество() = 0 Тогда
		ДанныеКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
	КонецЕсли;
	
	ДанныеКлючаСессииДляОрганизации = ИнтерфейсАвторизацииИСМПСлужебный.АктуальныеПараметрыКлючаСессии(ПараметрыЗапроса, ДанныеКлючаСессии, СрокДействия);
	
	Если ДанныеКлючаСессииДляОрганизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КлючСессии = ДанныеКлючаСессииДляОрганизации.КлючСессии;
	
	Возврат КлючСессии;
	
КонецФункции

// Проверить актуальность ключа сессии.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии).
// 	СрокДействия - Дата, Неопределено - Требуемый срок действия ключа сессии.
// Возвращаемое значение:
// 	Булево - Необходимость обновления ключа сессии.
Функция ТребуетсяОбновлениеКлючаСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено) Экспорт
	
	КлючСессии = ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновление = (КлючСессии = Неопределено);
	
	Если Не ТребуетсяОбновление Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КлючСессииОбновлен = ИнтерфейсАвторизацииИСМПСлужебный.ОбновитьКлючСессииНаСервере(ПараметрыЗапроса);
	
	Возврат Не КлючСессииОбновлен;
	
КонецФункции

// Запросить из сервиса ИС МП параметры авторизации.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * ПараметрыАвторизации - (См. ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации). - Параметры авторизации
//                        - Неопределено - Если при получении параметров авторизации возникла ошибка.
// * ТекстОшибки          - Строка - Текст сообщения об ошибке.
Функция ЗапроситьПараметрыАвторизации(ПараметрыЗапроса) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыАвторизации", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	РезультатЗапроса = ИнтеграцияИСМП.ПолучитьДанныеИзСервиса(
		ПараметрыЗапроса.АдресЗапросаПараметровАвторизации, Неопределено,
		ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ИнтерфейсМОТПСлужебный.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ИнтерфейсМОТПСлужебный.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ПараметрыАвторизации = ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации();
				ПараметрыАвторизации.Идентификатор = ДанныеОтвета.uuid;
				ПараметрыАвторизации.Данные        = ДанныеОтвета.data;
				
				ВозвращаемоеЗначение.ПараметрыАвторизации = ПараметрыАвторизации;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапроса.АдресЗапросаПараметровАвторизации,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Выполнить запрос ключа сессии в МОТП.
// 
// Параметры:
// 	ПараметрыЗапросаПоОрганизации - Структура - Структура со свойствами:
//	* ПараметрыЗапроса
//	* ПараметрыАвторизации
//	* СвойстваПодписи
//
// Возвращаемое значение:
// 	Структура - Описание:
// * Результат   - (См. ИнтерфейсМОТПСлужебный.ПараметрыКлючаСессии).
//               - Неопределено - При получении параметров ключа сессии произошла ошибка.
// * ТекстОшибки - Строка - Текст ошибки.
Функция ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ПараметрыКлючаСессии", Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	ТелоЗапроса = Новый Структура;
	ТелоЗапроса.Вставить("uuid", ПараметрыЗапросаПоОрганизации.ПараметрыАвторизации.Идентификатор);
	ТелоЗапроса.Вставить("data", ИнтеграцияИСКлиентСервер.ДвоичныеДанныеBase64(
		ИнтеграцияИСМПСлужебный.ПодписьИзСвойствПодписи(ПараметрыЗапросаПоОрганизации.СвойстваПодписи)));
	
	РезультатЗапроса = ИнтеграцияИСМП.ОтправитьДанныеВСервис(
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии, ТелоЗапроса, Неопределено, "POST",
		ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса);
	
	РезультатОтправкиЗапроса = ИнтерфейсМОТПСлужебный.ОбработатьРезультатОтправкиHTTPЗапросаКакJSON(РезультатЗапроса);
	
	Если РезультатОтправкиЗапроса.ОтветПолучен Тогда
		
		Если РезультатОтправкиЗапроса.КодСостояния = 200 Тогда
			
			ДанныеОтвета = ИнтерфейсМОТПСлужебный.ТекстJSONВОбъект(РезультатОтправкиЗапроса.ТекстВходящегоСообщенияJSON);
			
			Если ДанныеОтвета = Неопределено
				Или Не ДанныеОтвета.Свойство("token") Тогда
				
				ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
					ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
					РезультатОтправкиЗапроса);
				
			Иначе
				
				ДействуетДо = ТекущаяДатаСеанса() + ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.ВремяЖизни;
				
				Если ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.ИмяПараметраСеанса = Метаданные.ПараметрыСеанса.ДанныеКлючаСессииИСМП.Имя Тогда
					
					РезультатРазбора = ИнтерфейсМОТПСлужебный.РасшифроватьТокенJWT(ДанныеОтвета.token);
					Если РезультатРазбора.Данные <> Неопределено Тогда
						ДействуетДо = ИнтеграцияИС.ДатаИзСтрокиUNIX(РезультатРазбора.Данные.exp, 1);
					КонецЕсли;
					
				КонецЕсли;
				
				ПараметрыКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыКлючаСессии();
				ПараметрыКлючаСессии.КлючСессии  = ДанныеОтвета.token;
				ПараметрыКлючаСессии.ДействуетДо = ДействуетДо;
				
				ВозвращаемоеЗначение.ПараметрыКлючаСессии = ПараметрыКлючаСессии;
				
			КонецЕсли;
			
		Иначе
			
			ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
				РезультатОтправкиЗапроса);
			
		КонецЕсли;
		
	Иначе
		
		ВозвращаемоеЗначение.ТекстОшибки = ИнтерфейсМОТПСлужебный.ТекстОшибкиПоРезультатуОтправкиЗапроса(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.АдресЗапросаКлючаСессии,
			РезультатОтправкиЗапроса);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет запрос ключа сессии для организации с учетом результата подписания.
// 
// Параметры:
// 	ПараметрыЗапросовПоОрганизациям - (См. ИнтерфейсАвторизацииИСМПСлужебныйКлиент.РезультатПодписания).
// Возвращаемое значение:
// 	Соответствие - Результат запроса ключей сессий по организациям.
Функция ЗапроситьКлючиСессий(ПараметрыЗапросовПоОрганизациям) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Для Каждого ПараметрыЗапросаПоОрганизации Из ПараметрыЗапросовПоОрганизациям Цикл
		
		РезультатЗапросаКлючаСессии = ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
		
		Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
			
			ИнтерфейсАвторизацииИСМПСлужебный.УстановитьКлючСессии(
				ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса,
				РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
			
			// Ключ сессии обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, Истина);
			
		Иначе
			
			// Ключ сессии не обновлен
			ВозвращаемоеЗначение.Вставить(ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса.Организация, РезультатЗапросаКлючаСессии.ТекстОшибки);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти