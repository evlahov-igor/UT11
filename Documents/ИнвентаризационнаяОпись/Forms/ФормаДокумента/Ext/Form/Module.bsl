﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	УстановитьВидимостьВидЦены(Объект.ИсточникИнформацииОЦенахДляПечати);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Элементы.ДекорацияСостояниеЭДО.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
	КР_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	// >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриЧтенииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриЧтенииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ИнвентаризационнаяОпись", ПараметрыЗаписи, Объект.Ссылка);
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПослеЗаписи_ФормаДокумента(ЭтаФорма, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзменении(Элемент)
	
	ИсточникИнформацииОЦенахДляПечатиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Если Объект.ДатаНачала > Объект.ДатаОкончания И Объект.ДатаОкончания <> '000101010000' Тогда
		Объект.ДатаОкончания = Объект.ДатаНачала;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	Если Объект.ДатаОкончания < Объект.ДатаНачала И Объект.ДатаНачала <> '000101010000' Тогда
		Объект.ДатаНачала = Объект.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаДокумента(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры  

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачала", "ДатаОкончания"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()

	Объект.ИсточникИнформацииОЦенахДляПечати = Справочники.Склады.ИсточникИнформацииОЦенахДляПечати(Объект.Склад);
	// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
	КР_УстановитьИсточникИнформацииОЦенахДляПечати();
	// >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
	ИсточникИнформацииОЦенахДляПечатиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзмененииНаСервере()
	
	ИсточникИнформацииОЦенахДляПечати = Объект.ИсточникИнформацииОЦенахДляПечати;
	УстановитьЗначениеВидЦены(ИсточникИнформацииОЦенахДляПечати);
	УстановитьВидимостьВидЦены(ИсточникИнформацииОЦенахДляПечати);
	
КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВидЦены(ИсточникИнформацииОЦенахДляПечати)
	
	Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		Элементы.ВидЦены.Доступность = Истина;
	ИначеЕсли ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		Элементы.ВидЦены.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеВидЦены(ИсточникИнформацииОЦенахДляПечати)
	
	Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		Объект.ВидЦены = Справочники.Склады.УчетныйВидЦены(Объект.Склад);
	ИначеЕсли ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		Объект.ВидЦены = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#КонецОбласти

#Область КР_ДобавленныеПроцедурыИФункции

// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
&НаСервере
Процедура КР_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	#Область СозданиеЭлементовФормы
	// КР_СтраницыФормы
	КР_СтраницыФормы = КР_МетодыМодификацииФорм.ВставитьГруппуФормы(ЭтотОбъект, "КР_СтраницыФормы");
	КР_СтраницыФормы.Вид = ВидГруппыФормы.Страницы;
	
	// КР_СтраницаОсновное
	КР_СтраницаОсновное = КР_МетодыМодификацииФорм.ВставитьГруппуФормы(ЭтотОбъект, "КР_СтраницаОсновное", КР_СтраницыФормы);
	КР_СтраницаОсновное.Вид = ВидГруппыФормы.Страница;
	КР_СтраницаОсновное.Заголовок = НСтр("ru='Основное'");
	
	// Переместим все типовые элементы на созданную страницу
	Элементы.Переместить(Элементы.Шапка, КР_СтраницаОсновное);
	Элементы.Переместить(Элементы.ГруппаДополнительныеРеквизиты, КР_СтраницаОсновное);
	Элементы.Переместить(Элементы.ГруппаКомментарий, КР_СтраницаОсновное);
	Элементы.Переместить(Элементы.Ответственный, КР_СтраницаОсновное);
	Элементы.Переместить(Элементы.ГруппаСостояниеЭДО, КР_СтраницаОсновное);
	
	// КР_СтраницаИнвентаризационнаяКомиссия
	КР_СтраницаИнвентаризационнаяКомиссия = КР_МетодыМодификацииФорм.ВставитьГруппуФормы(ЭтотОбъект, "КР_СтраницаИнвентаризационнаяКомиссия",
		КР_СтраницыФормы);
	КР_СтраницаИнвентаризационнаяКомиссия.Вид = ВидГруппыФормы.Страница;
	КР_СтраницаИнвентаризационнаяКомиссия.Заголовок = НСтр("ru='Инвентаризационная комиссия'");
	
	// КР_ИнвентаризационнаяКомиссия
	КР_ИнвентаризационнаяКомиссия = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(ЭтотОбъект,
		"Объект.КР_ИнвентаризационнаяКомиссия",
		КР_СтраницаИнвентаризационнаяКомиссия);
	КР_ИнвентаризационнаяКомиссия.УстановитьДействие("ПриНачалеРедактирования", "КР_ИнвентаризационнаяКомиссияПриНачалеРедактирования");
		
	// КР_ИнвентаризационнаяКомиссия.Сотрудник
	Сотрудник = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(ЭтотОбъект,
		"Объект.КР_ИнвентаризационнаяКомиссия.Сотрудник",
		КР_ИнвентаризационнаяКомиссия);
	
	// КР_ИнвентаризационнаяКомиссия.Председатель
	Председатель = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(ЭтотОбъект,
		"Объект.КР_ИнвентаризационнаяКомиссия.Председатель",
		КР_ИнвентаризационнаяКомиссия);
	Председатель.УстановитьДействие("ПриИзменении", "КР_ИнвентаризационнаяКомиссияПредседательПриИзменении");
	#КонецОбласти
	
	КР_УстановитьВидимостьДоступностьЭлементовФормы();
	
КонецПроцедуры // >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
&НаКлиенте
Процедура КР_ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)
	
	ПараметрыПоискаСтроки = Новый Структура("Председатель", Истина);
	МассивСтрок = Объект.КР_ИнвентаризационнаяКомиссия.НайтиСтроки(ПараметрыПоискаСтроки);
	Если МассивСтрок.Количество() > 1 Тогда
		Элементы["КР_ИнвентаризационнаяКомиссия"].ТекущиеДанные.Председатель = Ложь;
		ТекстСообщения = НСтр("ru='Только один сотрудник может являться председателем'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры // >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
&НаКлиенте
Процедура КР_ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		Элементы["КР_ИнвентаризационнаяКомиссия"].ТекущиеДанные.Председатель = Ложь;
	КонецЕсли;
	
КонецПроцедуры // >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
&НаСервере
Процедура КР_УстановитьВидимостьДоступностьЭлементовФормы()

	ЕстьПравоНаИзменениеСкладскихАктов = Пользователи.РолиДоступны("ДобавлениеИзменениеСкладскихАктов");
	Элементы.ИсточникИнформацииОЦенахДляПечати.Доступность = ЕстьПравоНаИзменениеСкладскихАктов;

КонецПроцедуры // >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

// << 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860
&НаСервере
Процедура КР_УстановитьИсточникИнформацииОЦенахДляПечати()
	
	ВидСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Склад, "КР_ВидСклада");
	Если ВидСклада = Перечисления.КР_ВидыСкладов.Магазин Тогда
		Объект.ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости;
	КонецЕсли;
	
КонецПроцедуры // >> 03.02.2023 Федоров Д.Е., КРОК, JIRA№A2105505-860

#КонецОбласти

