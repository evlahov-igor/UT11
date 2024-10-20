﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "Документ.ПриобретениеТоваровУслуг";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаЗаявленияОВвозеТоваров();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокПриобретенияТоваровУслуг, СвойстваСписка);
	
	УстановитьОтборыПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаявкаНаРасходованиеДенежныхСредств"
		Или ИмяСобытия = "Запись_СписаниеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_ЗаявлениеОВвозеТоваров" Тогда
		
		ЭтаФорма.Элементы.СписокПриобретенияТоваровУслуг.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	Если ОрганизацияСохраненноеЗначение <> Организация Тогда
		
		УстановитьОтборыПоОрганизации();
		ОрганизацияСохраненноеЗначение = Организация;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналЗакупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьЗаявлениеОВвозеТоваров(Команда)
	
	Список = Элементы.СписокПриобретенияТоваровУслуг;
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	Если Не ОбщегоНазначенияУТКЛиент.ВыбраныДокументыКОформлению(ВыделенныеСтроки,ПараметрыЖурнала()) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыделенныеСтроки.Количество() = 1
		И ТипЗнч(Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
		
	МассивСсылок = Новый Массив();
		
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		МассивСсылок.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если МассивСсылок.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Не выбрано ни одного документа для ввода на основании!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Для Каждого Заявление Из МассивСсылок Цикл
		ОткрытьФорму("Документ.ЗаявлениеОВвозеТоваров.ФормаОбъекта", Новый Структура("Основание", Список.ТекущаяСтрока), , Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокПриобретенияТоваровУслуг.Дата", "СписокПриобретенияТоваровУслугДата");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоОрганизации()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокПриобретенияТоваровУслуг,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(Организация));
		
	Элементы.СписокПриобретенияТоваровУслугОрганизация.Видимость = Не ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		Параметры.СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЖурнала()
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",Организация);
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора",СтруктураБыстрогоОтбора);
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы", "ЗаявленияОВвозеТоваров");
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста","ЖурналДокументовЗакупки");
	ПараметрыЖурнала.Вставить("СинонимЖурнала",НСтр("ru = 'Документы закупки'"));
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

Функция ТекстЗапросаЗаявленияОВвозеТоваров()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументПриобретениеТоваровУслуг.Ссылка КАК Ссылка,
	|	ВЫРАЗИТЬ(ДокументПриобретениеТоваровУслуг.Номер КАК СТРОКА(12)) КАК Номер,
	|	ДокументПриобретениеТоваровУслуг.Дата КАК Дата,
	|	ДокументПриобретениеТоваровУслуг.Валюта КАК Валюта,
	|	ДокументПриобретениеТоваровУслуг.Контрагент КАК Контрагент,
	|	ДокументПриобретениеТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	|	ДокументПриобретениеТоваровУслуг.Организация КАК Организация
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ДокументПриобретениеТоваровУслуг
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюЗаявленийОВвозе.Остатки КАК ТоварыКОформлениюЗаявленийОВвозеОстатки
	|		ПО ДокументПриобретениеТоваровУслуг.Ссылка = ТоварыКОформлениюЗаявленийОВвозеОстатки.ДокументПоступления
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументПриобретениеТоваровУслуг.Ссылка,
	|	ДокументПриобретениеТоваровУслуг.Дата,
	|	ДокументПриобретениеТоваровУслуг.Валюта,
	|	ДокументПриобретениеТоваровУслуг.Контрагент,
	|	ДокументПриобретениеТоваровУслуг.СуммаДокумента,
	|	ДокументПриобретениеТоваровУслуг.Организация,
	|	ВЫРАЗИТЬ(ДокументПриобретениеТоваровУслуг.Номер КАК СТРОКА(12))";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти