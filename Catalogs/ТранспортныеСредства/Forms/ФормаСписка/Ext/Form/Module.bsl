﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ТранспортныеСредства);
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// << 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880
	КР_ПриСозданииНаСервереДополнительно(Отказ, СтандартнаяОбработка);
	// >> 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область КР_ДобавленныеПроцедурыИФункции

#Область КР_ОбработчикиСобытийФормы

// << 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880
&НаСервере
Процедура КР_ПриСозданииНаСервереДополнительно(Отказ, СтандартнаяОбработка) 
	
	КР_ТранспортРозницыЭлемент = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(
		ЭтотОбъект, "Список.КР_ТранспортРозницы", Элементы.Список);
	
	КР_УстановитьОтборТранспортРозницы();
	
КонецПроцедуры // >> 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880

#КонецОбласти

// << 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880
&НаСервере
Процедура КР_УстановитьОтборТранспортРозницы()
	
	// Использован платформенный метод РольДоступна(), т.к. роль
	// используется как маркер выполнения логики алгоритма.
	// Использование метода Пользователи.РолиДоступны() не подходит, т.к.
	// для полноправного пользователя логика не должна выполняться.
	Если РольДоступна("КР_ДобавлениеИзменениеТранспортныхСредствРозница") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "КР_ТранспортРозницы", Истина, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;
	
КонецПроцедуры // >> 25.11.2022, Маскаев П.Ю., КРОК, Jira№ A2105505-880

#КонецОбласти
