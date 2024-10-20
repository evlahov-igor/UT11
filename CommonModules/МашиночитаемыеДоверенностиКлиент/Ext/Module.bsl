﻿#Область ПрограммныйИнтерфейс

// Открывает форму списка машиночитаемых доверенностей.
//
// Параметры:
//  Организация - ОпределяемыйТип.Организация - Организация
Процедура ОткрытьСписокМЧД(Организация = Неопределено) Экспорт
	
	НастройкиОтбора   = Новый Структура;
	Если Организация <> Неопределено Тогда
		НастройкиОтбора.Вставить("Организация", Организация);
	КонецЕсли;
	ПараметрыОткрытия = Новый Структура("Отбор", НастройкиОтбора);
	
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаСписка", ПараметрыОткрытия);
	
КонецПроцедуры

// Загружает из РР в длительной операции частичные и полные данные МЧД
//
// Параметры:
//  ДанныеМЧД - Массив из Структура:
//  * НомерДоверенности - Строка
//  * ИННДоверителя - Строка
//  Оповещение - ОписаниеОповещения
//  Форма - ФормаКлиентскогоПриложения
Процедура ЗагрузитьСведенияМЧД(ДанныеМЧД, Оповещение, Форма) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДанныеМЧД", ДанныеМЧД);
	СтруктураПараметров.Вставить("ИдентификаторФормы", Форма.УникальныйИдентификатор);
	
	ДлительнаяОперация = МашиночитаемыеДоверенностиВызовСервера.НачатьЗагрузкуСведенийМЧД(СтруктураПараметров);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ДополнительныеПараметры = Новый Структура("Оповещение", Оповещение);
	ОповещениеОЗавершении = 
		Новый ОписаниеОповещения("ЗагрузитьСведенияМЧДЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает номер (GUID) для новой машиночитаемой доверенности и записывает в реквизит доверенности
// или поле формы, предполагается использование при открытии формы доверенности, фоновое обновление.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - структура:
//      * НомерДоверенности - Строка - при ошибке возвращается пустая строка, выводится сообщение об ошибке
//   СсылкаНаДоверенность  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//   ФормаДоверенности     - ФормаКлиентскогоПриложения
//
Процедура ПолучитьНомерМЧД(
		ОповещениеОЗавершении = Неопределено,
		СсылкаНаДоверенность = Неопределено,
		ФормаДоверенности = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НомерДоверенности", "");
	
	Результат.НомерДоверенности = МашиночитаемыеДоверенностиВызовСервера.ПолучитьНомерМЧД().НомерДоверенности;
	Если ФормаДоверенности <> Неопределено Тогда
		ФормаДоверенности.Объект.НомерДоверенности = Результат.НомерДоверенности;
	КонецЕсли;
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Сохраняет форму при заданной форме, выгружает машиночитаемую доверенность, предлагает выбрать/подтвердить выбор
// сертификата, подписывает, отправляет на регистрацию в распределенном реестре ФНС, ожидает регистрации 1-3 минуты,
// получает статус, обновляет статус в записе справочника доверенностей, в том числе запоминает идентификатор
// транзакции.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - структура:
//      * ИдентификаторТранзакции - Строка - при ошибке отправки на регистрацию выводится сообщение об ошибке
//                                           и возвращается пустая строка, при успехе идентификатор запоминается
//                                           в записи справочника
//      * СтатусТранзакции        - Строка - "PENDING" - транзакция майнится, "SUCCESS" - транзакция смайнилась,
//                                           "FAILURE" - ошибка при майнинге транзакции, при ошибке получения
//                                           статуса возвращается пустая строка и выводится сообщение об ошибке,
//                                           статус обновляется в записи справочника и на форме, если передана
//      * ДатаВремяТранзакции     - Дата
//      * ХешДоверенности         - Строка - хеш доверенности
//      * НомерДоверенности       - Строка - номер, извлеченный из доверенности
//      * ИННДоверителя           - Строка - ИНН доверителя, извлеченный из доверенности
//   СсылкаНаДоверенность  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//   ФормаДоверенности     - ФормаКлиентскогоПриложения
//
Процедура ЗарегистрироватьМЧД(
		ОповещениеОЗавершении = Неопределено,
		СсылкаНаДоверенность = Неопределено,
		ФормаДоверенности = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторТранзакции", 	"");
	Результат.Вставить("СтатусТранзакции", 			"");
	Результат.Вставить("ДатаВремяТранзакции", 		Неопределено);
	Результат.Вставить("ХешДоверенности", 			"");
	Результат.Вставить("НомерДоверенности", 		"");
	Результат.Вставить("ИННДоверителя", 			"");
	
	Если ФормаДоверенности <> Неопределено И НЕ ФормаДоверенности.Записать() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось сохранить доверенность'"));
		Если ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	СсылкаНаДоверенностьСУчетомФормы = ?(ФормаДоверенности = Неопределено, СсылкаНаДоверенность,
		ФормаДоверенности.Объект.Ссылка);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", 	ОповещениеОЗавершении);
	ДополнительныеПараметры.Вставить("СсылкаНаДоверенность", 	СсылкаНаДоверенностьСУчетомФормы);
	ДополнительныеПараметры.Вставить("ФормаДоверенности", 		ФормаДоверенности);
	ДополнительныеПараметры.Вставить("Результат", 				Результат);

	НаборДействий = Новый Соответствие;	
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать"));
		
	ДополнительныеПараметры.Вставить("ОповещениеУспешногоЗавершения",
		Новый ОписаниеОповещения("ЗарегистрироватьМЧДПослеПодписи", ЭтотОбъект, НаборДействий));
	РезультатВыгрузки = МашиночитаемыеДоверенностиВызовСервера.ВыгрузитьМЧД(ДополнительныеПараметры.СсылкаНаДоверенность);
	ДополнительныеПараметры.Вставить("РезультатВыгрузки", РезультатВыгрузки);
	ДанныеXMLВыгрузки = ПолучитьДвоичныеДанныеИзСтроки(ДополнительныеПараметры.РезультатВыгрузки.Содержимое, "windows-1251");
	ДополнительныеПараметры.Вставить("ДанныеXMLВыгрузки", ДанныеXMLВыгрузки);

	Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДО", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
	ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
	
	ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.МЧД.Добавить(ДополнительныеПараметры.СсылкаНаДоверенность);
	
	ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);
	
КонецПроцедуры

Функция РезультатПодписать()
	
	Результат = Новый Структура;
	Результат.Вставить("ПодписьВыполнена", Ложь);
	Результат.Вставить("ПодписанныеДанные", Неопределено);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("МенеджерКриптографии", Неопределено);
	
	Возврат Результат;
	
КонецФункции

Процедура ПослеВыполненияДействийПоЭДООтзыв(РезультатПодписания, ДополнительныеПараметры) Экспорт
	
	Если РезультатПодписания.ОшибкиФормирования.Количество() = 0
		И РезультатПодписания.Свойство("СвойстваПодписи") Тогда
		
		Результат = РезультатПодписать();
		Результат.ПодписьВыполнена = Истина;
		Результат.ПодписанныеДанные = РезультатПодписания.СвойстваПодписи.Подпись;
		Результат.ОписаниеОшибки = "";
		ДополнительныеПараметры.Вставить("ОтпечатокСертификатаАбонента", РезультатПодписания.СвойстваПодписи.Отпечаток);
		ОтменитьМЧДПослеПодписи(Результат, ДополнительныеПараметры);
	
	Иначе
		
		ПоказатьПредупреждение(, "Подписание завершено с ошибками!");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыполненияДействийПоЭДО(РезультатПодписания, ДополнительныеПараметры) Экспорт
	
	Если РезультатПодписания.ОшибкиФормирования.Количество() = 0
		И РезультатПодписания.Свойство("СвойстваПодписи") Тогда
		
		Результат = РезультатПодписать();
		Результат.ПодписьВыполнена = Истина;
		Результат.ПодписанныеДанные = РезультатПодписания.СвойстваПодписи.Подпись;
		Результат.ОписаниеОшибки = "";
		ДополнительныеПараметры.Вставить("ОтпечатокСертификатаАбонента", РезультатПодписания.СвойстваПодписи.Отпечаток);
		ЗарегистрироватьМЧДПослеПодписи(Результат, ДополнительныеПараметры);
	
	Иначе
		
		ПоказатьПредупреждение(, "Подписание завершено с ошибками!");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьМЧДПослеПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.ПодписьВыполнена Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(
			НСтр("ru = 'Не удалось подписать доверенность: %1'"),
			Результат.ОписаниеОшибки));
		Если ДополнительныеПараметры.ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ФормаДоверенности = ДополнительныеПараметры.ФормаДоверенности;
	
	РезультатРегистрации = МашиночитаемыеДоверенностиВызовСервера.ЗарегистрироватьМЧД(
		ДополнительныеПараметры.РезультатВыгрузки.ИмяФайла + ".xml",
		ДополнительныеПараметры.ДанныеXMLВыгрузки,
		Результат.ПодписанныеДанные,,
		?(ФормаДоверенности = Неопределено, "", ФормаДоверенности.Объект.НомерДоверенности),
		ФормаДоверенности.Объект.Ссылка);
	
	СтатусТранзакции = ?(ЗначениеЗаполнено(РезультатРегистрации.ИдентификаторТранзакции), "PENDING", "");
	
	ДополнительныеПараметры.Результат.ИдентификаторТранзакции 	= РезультатРегистрации.ИдентификаторТранзакции;
	ДополнительныеПараметры.Результат.СтатусТранзакции 			= СтатусТранзакции;
	ДополнительныеПараметры.Результат.ДатаВремяТранзакции 		= Неопределено;
	ДополнительныеПараметры.Результат.ХешДоверенности 			= РезультатРегистрации.ХешДоверенности;
	ДополнительныеПараметры.Результат.НомерДоверенности 		= РезультатРегистрации.НомерДоверенности;
	ДополнительныеПараметры.Результат.ИННДоверителя 			= РезультатРегистрации.ИННДоверителя;
	
	Если ФормаДоверенности <> Неопределено И ЗначениеЗаполнено(РезультатРегистрации.ИдентификаторТранзакции) Тогда
		ФормаДоверенности.Прочитать();
		ФормаДоверенности.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Отправлено");
		ФормаДоверенности.Объект.ДатаОтправки = ОбщегоНазначенияКлиент.ДатаСеанса();
		ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ФормаДоверенности.Объект.ДатаОтправки;
		ФормаДоверенности.Объект.ИдентификаторТранзакции = РезультатРегистрации.ИдентификаторТранзакции;
		ФормаДоверенности.Объект.ИмяФайлаВыгрузка = ДополнительныеПараметры.РезультатВыгрузки.ИмяФайла + ".xml";
		ФормаДоверенности.Объект.ОтпечатокСертификата = ДополнительныеПараметры.ОтпечатокСертификатаАбонента;
		ФормаДоверенности.Записать();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
	
КонецПроцедуры

// Получает частичные (открытые) данные доверенности и обновляет реквизит состояния доверенности, обновляет данные для
// панели состояния в форме, если передана форма.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - структура:
//      * ХешДоверенности    - Строка - хеш доверенности
//      * НомерДоверенности  - Строка - номер, извлеченный из доверенности
//      * ДатаВыдачи         - Дата - дата начала действия доверенности
//      * ДатаОкончания      - Дата - дата завершения действия доверенности
//      * СтатусДоверенности - Строка - "CREATED" - дата начала действия не наступила, "ACTIVE" - действует,
//                                      "EXPIRED" - истекла, "DECLINED" - отменена (отозвана), "" - не запрашивался
//      * ПубличныйКлюч      - Строка - публичный ключ эмитента доверенности
//   СсылкаНаДоверенность  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//   ФормаДоверенности     - ФормаКлиентскогоПриложения
//
Процедура ОбновитьСостояниеМЧД(
		ОповещениеОЗавершении = Неопределено,
		СсылкаНаДоверенность = Неопределено,
		ФормаДоверенности = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ХешДоверенности", 		"");
	Результат.Вставить("НомерДоверенности", 	"");
	Результат.Вставить("ДатаВыдачи", 			Неопределено);
	Результат.Вставить("ДатаОкончания", 		Неопределено);
	Результат.Вставить("СтатусДоверенности", 	"");
	Результат.Вставить("ПубличныйКлюч", 		"");
	
	Если ФормаДоверенности <> Неопределено И НЕ ФормаДоверенности.Записать() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось сохранить доверенность'"));
		Если ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СостояниеИзменено = Ложь;
	ТокенДоступа = "";
	СтраницаНеНайдена = Ложь;
	Если ФормаДоверенности.Объект.Статус =
		ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Отправлено") Тогда
		
		СведенияСтатусаТранзакции = МашиночитаемыеДоверенностиВызовСервера.ПолучитьСтатусТранзакцииМЧД(
			ФормаДоверенности.Объект.ИдентификаторТранзакции,
			ТокенДоступа,
			ФормаДоверенности.Объект.НомерДоверенности);
		
		Если СведенияСтатусаТранзакции.СтатусТранзакции = "SUCCESS" Тогда
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Зарегистрировано");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			ФормаДоверенности.Объект.ИдентификаторТранзакции = "";
			СостояниеИзменено = Истина;
			
		ИначеЕсли СведенияСтатусаТранзакции.СтатусТранзакции = "FAILURE" Тогда
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ОшибкаРегистрации");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			ФормаДоверенности.Объект.ИдентификаторТранзакции = "";
			СостояниеИзменено = Истина;
		ИначеЕсли СведенияСтатусаТранзакции.СтатусТранзакции = 404 Тогда
			СтраницаНеНайдена = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если (ФормаДоверенности.Объект.Статус <>
		ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Отправлено")
		И ФормаДоверенности.Объект.Статус <>
		ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ОшибкаРегистрации"))
		ИЛИ СтраницаНеНайдена Тогда
		
		СведенияСтатусаДоверенности = МашиночитаемыеДоверенностиВызовСервера.ПолучитьЧастичныеДанныеДоверенностиНаСервереМЧД(
			ФормаДоверенности.Объект.НомерДоверенности,
			ТокенДоступа);
		Результат.ХешДоверенности = СведенияСтатусаДоверенности.ХешДоверенности;
		Результат.НомерДоверенности = СведенияСтатусаДоверенности.НомерДоверенности;
		Результат.ДатаВыдачи = СведенияСтатусаДоверенности.ДатаВыдачи;
		Результат.ДатаОкончания = СведенияСтатусаДоверенности.ДатаОкончания;
		Результат.СтатусДоверенности = СведенияСтатусаДоверенности.СтатусДоверенности;
		Результат.ПубличныйКлюч = СведенияСтатусаДоверенности.ПубличныйКлюч;
		
		Если СведенияСтатусаДоверенности.СтатусДоверенности = "CREATED"
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ДатаНачалаДействияНеНаступила") Тогда
			
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ДатаНачалаДействияНеНаступила");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			СостояниеИзменено = Истина;
			
		ИначеЕсли СведенияСтатусаДоверенности.СтатусДоверенности = "ACTIVE"
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Зарегистрировано")
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ОтправленоЗаявлениеНаОтзыв")
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ОшибкаОтзыва") Тогда
			
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Зарегистрировано");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			СостояниеИзменено = Истина;
			
		ИначеЕсли СведенияСтатусаДоверенности.СтатусДоверенности = "EXPIRED"
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ИстекСрокДействия") Тогда
			
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ИстекСрокДействия");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			СостояниеИзменено = Истина;
			
		ИначеЕсли (СведенияСтатусаДоверенности.СтатусДоверенности = "DECLINED"
			ИЛИ СведенияСтатусаДоверенности.СтатусДоверенности = "REVOKED")
			И ФормаДоверенности.Объект.Статус <>
			ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Отозвано") Тогда
			
			ФормаДоверенности.Объект.Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.Отозвано");
			ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ОбщегоНазначенияКлиент.ДатаСеанса();
			СостояниеИзменено = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ФормаДоверенности <> Неопределено И СостояниеИзменено И НЕ ФормаДоверенности.Записать() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось сохранить доверенность'"));
		Если ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
	КонецЕсли;
	
КонецПроцедуры

// Запрашивает номер и ИНН доверенности, если не переданы, и отправляет запрос на получение полных данных
// машиночитаемой доверенности, при успехе создает и заполняет полученными данными запись справочника машиночитаемых
// доверенностей, ожидает обработки запроса до 1-3 минуты.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - структура:
//      * СсылкаНаДоверенность - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций - задана при успехе
//      * СтатусПолучения      - "PENDING" - операция выполняется, идет запрос данных с узла ФНС, повторить попытку
//                               позже, возвращается, если за 3 минуты не удалось получить данные доверенности,
//                               при ошибке получения статуса возвращается пустая строка и выводится сообщение
//                               об ошибке
//   РеквизитыДоверенности - Неопределено или структура:
//    * НомерДоверенности     - Строка - если не задан и не указан в форме, запрашивается
//    * ИННДоверителя         - Строка - если не задан и не указан в форме, запрашивается организация доверителя
//                              с возможностью ввести ИНН вручную
//   ФормаВладелец         - ФормаКлиентскогоПриложения
//
Процедура ПолучитьДанныеМЧД(
		ОповещениеОЗавершении = Неопределено,
		РеквизитыДоверенности = Неопределено,
		ФормаВладелец = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СсылкаНаДоверенность", 	Неопределено);
	Результат.Вставить("СтатусПолучения", 		"");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", 	ОповещениеОЗавершении);
	ДополнительныеПараметры.Вставить("Результат", 				Результат);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьДанныеМЧДПослеВводаРеквизитов",
		ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаЗагрузки",,
		ФормаВладелец,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПолучитьДанныеМЧДПослеВводаРеквизитов(
		СтруктураДанных,
		ДополнительныеПараметры) Экспорт
	
	Если СтруктураДанных = Неопределено Тогда
		Если ДополнительныеПараметры.ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СведенияДоверенности = МашиночитаемыеДоверенностиВызовСервера.ПолучитьПолныеДанныеДоверенностиНаСервереМЧД(
		СтруктураДанных.НомерДоверенности,
		СтруктураДанных.ИННДоверителя);
	
	ДополнительныеПараметры.Результат.СтатусПолучения = СведенияДоверенности.СтатусПолучения;
	
	Если СведенияДоверенности.СтатусПолучения = "PENDING" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьДанныеМЧДПослеПоказаПредупреждения",
			ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьПредупреждение(ОписаниеОповещения,
			НСтр("ru = 'Запрос данных доверенности отправлен успешно, повторите попытку загрузки через несколько минут'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СведенияДоверенности.ДанныеВыгрузки) Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
		Возврат;
	КонецЕсли;
	
	РезультатЗагрузки =
		МашиночитаемыеДоверенностиВызовСервера.ЗагрузитьМЧД(СведенияДоверенности.ДанныеВыгрузки, Истина);
		
	Если НЕ РезультатЗагрузки.Выполнено Тогда
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Не удалось загрузить полученные данные доверенности. %1'"),
			РезультатЗагрузки.Ошибка);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Результат.СсылкаНаДоверенность = РезультатЗагрузки.Ссылка;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
	
КонецПроцедуры

Процедура ПолучитьДанныеМЧДПослеПоказаПредупреждения(
		ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
	
КонецПроцедуры

// Запрашивает текст причины отмены (отзыва), выгружает заявление на отмену машиночитаемой доверенности, предлагает
// выбрать/подтвердить выбор сертификата, подписывает и отправляет заявление на регистрацию в распределенном реестре
// ФНС, ожидает 1-3 минуты, получает статус транзакции заявления, обновляет статус в записе справочника доверенностей,
// в том числе запоминает идентификатор транзакции.
//
// Параметры:
//   ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//     Результат - структура:
//      * ИдентификаторТранзакции - Строка - при ошибке отправки на регистрацию выводится сообщение об ошибке
//                                           и возвращается пустая строка
//      * СтатусТранзакции        - Строка - "PENDING" - транзакция майнится, "SUCCESS" - транзакция смайнилась,
//                                           "FAILURE" - ошибка при майнинге транзакции, при ошибке получения
//                                           статуса возвращается пустая строка и выводится сообщение об ошибке
//      * ДатаВремяТранзакции     - Дата
//   СсылкаНаДоверенность  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//   ФормаДоверенности     - ФормаКлиентскогоПриложения
//
Процедура ОтменитьМЧД(
		ОповещениеОЗавершении = Неопределено,
		СсылкаНаДоверенность = Неопределено,
		ФормаДоверенности = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторТранзакции", 	"");
	Результат.Вставить("СтатусТранзакции", 			"");
	Результат.Вставить("ДатаВремяТранзакции", 		Неопределено);
	
	Если ФормаДоверенности <> Неопределено И НЕ ФормаДоверенности.Записать() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось сохранить доверенность'"));
		Если ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	СсылкаНаДоверенностьСУчетомФормы = ?(ФормаДоверенности = Неопределено, СсылкаНаДоверенность,
		ФормаДоверенности.Объект.Ссылка);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", 	ОповещениеОЗавершении);
	ДополнительныеПараметры.Вставить("СсылкаНаДоверенность", 	СсылкаНаДоверенностьСУчетомФормы);
	ДополнительныеПараметры.Вставить("ФормаДоверенности", 		ФормаДоверенности);
	ДополнительныеПараметры.Вставить("Результат", 				Результат);

	НаборДействий = Новый Соответствие;	
	ЭлектронныеДокументыЭДОКлиентСервер.ДобавитьДействие(НаборДействий, ПредопределенноеЗначение("Перечисление.ДействияПоЭДО.Подписать"));
		
	ДополнительныеПараметры.Вставить("ОповещениеУспешногоЗавершения",
		Новый ОписаниеОповещения("ОтменитьМЧДПослеПодписи", ЭтотОбъект, НаборДействий));
		
	НомерДоверенности = "";
	Если ФормаДоверенности = Неопределено Тогда
		Доверенности = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СсылкаНаДоверенность);
		НомераДоверенностей = МашиночитаемыеДоверенностиВызовСервера.ПолучитьНомераДоверенностей(Доверенности);
		НомерДоверенности = НомераДоверенностей[СсылкаНаДоверенность];
	Иначе
		НомерДоверенности = ФормаДоверенности.Объект.НомерДоверенности;
	КонецЕсли;
	РезультатВыгрузки = МашиночитаемыеДоверенностиВызовСервера.ВыгрузитьЗаявлениеНаОтменуМЧД(НомерДоверенности, "Отзыв");
	ДополнительныеПараметры.Вставить("РезультатВыгрузки", РезультатВыгрузки);
	ДанныеXMLВыгрузки = ПолучитьДвоичныеДанныеИзСтроки(ДополнительныеПараметры.РезультатВыгрузки.Содержимое, "windows-1251");
	ДополнительныеПараметры.Вставить("ДанныеXMLВыгрузки", ДанныеXMLВыгрузки);

	Оповещение = Новый ОписаниеОповещения("ПослеВыполненияДействийПоЭДООтзыв", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыВыполненияДействийПоЭДО = ЭлектронныеДокументыЭДОКлиентСервер.НовыеПараметрыВыполненияДействийПоЭДО();
	ПараметрыВыполненияДействийПоЭДО.НаборДействий = НаборДействий;
	
	ПараметрыВыполненияДействийПоЭДО.ОбъектыДействий.МЧД.Добавить(ДополнительныеПараметры.СсылкаНаДоверенность);
	
	ЭлектронныеДокументыЭДОКлиент.НачатьВыполнениеДействийПоЭДО(Оповещение, ПараметрыВыполненияДействийПоЭДО);
	
КонецПроцедуры

Процедура ОтменитьМЧДПослеПодписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.ПодписьВыполнена Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(
			НСтр("ru = 'Не удалось подписать заявление на отмену доверенности: %1'"),
			Результат.ОписаниеОшибки));
		Если ДополнительныеПараметры.ОповещениеОЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ФормаДоверенности = ДополнительныеПараметры.ФормаДоверенности;
	
	ИмяФайлаЗаявленияНаОтзыв = "revoke.xml";
	РезультатРегистрации = МашиночитаемыеДоверенностиВызовСервера.ОтменитьМЧД(
		ИмяФайлаЗаявленияНаОтзыв,
		ДополнительныеПараметры.ДанныеXMLВыгрузки,
		Результат.ПодписанныеДанные,,
		?(ФормаДоверенности = Неопределено, "", ФормаДоверенности.Объект.НомерДоверенности),
		ДополнительныеПараметры.СсылкаНаДоверенность);
	
	СтатусТранзакции = ?(ЗначениеЗаполнено(РезультатРегистрации.ИдентификаторТранзакции), "PENDING", "");
	
	ДополнительныеПараметры.Результат.ИдентификаторТранзакции 	= РезультатРегистрации.ИдентификаторТранзакции;
	ДополнительныеПараметры.Результат.СтатусТранзакции 			= СтатусТранзакции;
	ДополнительныеПараметры.Результат.ДатаВремяТранзакции 		= Неопределено;
	
	Если ФормаДоверенности <> Неопределено И ЗначениеЗаполнено(РезультатРегистрации.ИдентификаторТранзакции) Тогда
		ФормаДоверенности.Прочитать();
		ФормаДоверенности.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыМашиночитаемойДоверенности.ОтправленоЗаявлениеНаОтзыв");
		ФормаДоверенности.Объект.ДатаОтправкиЗаявленияНаОтзыв = ОбщегоНазначенияКлиент.ДатаСеанса();
		ФормаДоверенности.Объект.ДатаОбновленияСтатуса = ФормаДоверенности.Объект.ДатаОтправкиЗаявленияНаОтзыв;
		ФормаДоверенности.Объект.ИдентификаторТранзакции = РезультатРегистрации.ИдентификаторТранзакции;
		ФормаДоверенности.Объект.ИмяФайлаЗаявленияНаОтзыв = ИмяФайлаЗаявленияНаОтзыв;
		ФормаДоверенности.Объект.ОтпечатокСертификата = ДополнительныеПараметры.ОтпечатокСертификатаАбонента;
		ФормаДоверенности.Записать();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, ДополнительныеПараметры.Результат);
	
КонецПроцедуры

Процедура ЗагрузитьСведенияМЧДЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Неопределено;
	
	Если Результат.Статус = "Выполнено" Тогда
		Ответ = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		УдалитьИзВременногоХранилища(Результат.АдресРезультата)
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, Ответ);
	
КонецПроцедуры

#КонецОбласти       

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму результатов проверки подписи 
// 
// Параметры:
// 	ПараметрыФормы - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыФормы
// 	ПараметрыОткрытия - см. ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД.ПараметрыОткрытияФормы
Процедура ОткрытьРезультатыПроверкиПодписи(ПараметрыФормы = Неопределено, ПараметрыОткрытия = Неопределено) Экспорт
	
	ОбщегоНазначенияБЭДКлиент.ОткрытьФормуБЭД(
		"Обработка.РезультатыПроверкиПодписи.Форма.РезультатыПроверкиПодписи", ПараметрыФормы, ПараметрыОткрытия);
		
КонецПроцедуры   

#КонецОбласти  