﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// В модуле реализованы клиент-серверные процедуры и функции, предназначенные для работы с текущими делами EDI
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область Разделы

// Возвращает массив разделов виджета "Закупки"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаЗакупки() Экспорт

	РазделыВиджета = Новый Массив;
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.АрхивЗакупки"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ВРаботеЗакупки"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ОтклоненияПриВыполненииЗакупки"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ПоследниеСобытияЗакупки"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ЗаказыПоставщикуДоступныеДляОтправки"));
	
	Возврат РазделыВиджета;

КонецФункции

// Возвращает массив разделов виджета "Продажи"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаПродажи() Экспорт

	РазделыВиджета = Новый Массив;
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.АрхивПродажи"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ВРаботеПродажи"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ОтклоненияПриВыполненииПродажи"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.ПоследниеСобытияПродажи"));
	
	Возврат РазделыВиджета;

КонецФункции

// Возвращает массив разделов виджета "Контроль поступлений"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаКонтрольПоступлений() Экспорт

	РазделыВиджета = Новый Массив;
	
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольПоступленийПросрочено"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольПоступленийСегодня"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольПоступленийЗавтра"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольПоступленийТриДня"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольПоступленийНеделя"));
	
	Возврат РазделыВиджета;

КонецФункции

// Возвращает массив разделов виджета "Контроль отгрузок"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаКонтрольОтгрузок() Экспорт

	РазделыВиджета = Новый Массив;
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольОтгрузокПросрочено"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольОтгрузокСегодня"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольОтгрузокЗавтра"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольОтгрузокТриДня"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.КонтрольОтгрузокНеделя"));
	
	Возврат РазделыВиджета;

КонецФункции

// Возвращает массив разделов виджета "Купить"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаКупить() Экспорт
	
	РазделыВиджета = Новый Массив;
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.СоздатьЗаказПоставщику"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.НайтиТорговоеПредложение"));
	
	Возврат РазделыВиджета;
	
КонецФункции

// Возвращает массив разделов виджета "Настройки и справочники"
// 
// Возвращаемое значение:
// 	Массив - массив разделов виджета.
//
Функция РазделыВиджетаНастройкиСправочники() Экспорт

	РазделыВиджета = Новый Массив;
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.Номенклатура"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.Контрагенты"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.НоменклатураКонтрагентов"));
	РазделыВиджета.Добавить(ПредопределенноеЗначение("Перечисление.РазделыВиджетовEDI.Настройки"));
	
	Возврат РазделыВиджета;

КонецФункции

#КонецОбласти

#КонецОбласти



