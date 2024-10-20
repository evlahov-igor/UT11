﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Объект.Ссылка = ПланыОбмена.МобильноеПриложениеТорговыйПредставитель.ЭтотУзел() Тогда
		Элементы.Пользователь.Видимость = Ложь;
		Элементы.ИмяПользователя.Видимость = Ложь;
		Элементы.МобильныйКомпьютер.Видимость = Ложь;
		Элементы.ВерсияМобильногоПриложения.Видимость = Ложь;
		Элементы.Пароль.Видимость = Ложь;
		Элементы.НастройкаОтборов.Видимость = Ложь;
		Элементы.ДополнительныеНастройки.Видимость = Ложь;
	КонецЕсли;
	
	ЗагрузитьНастройкиОтбора();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НастройкиДляСохранения = КомпоновщикНастроек.ПолучитьНастройки();
	СтруктураНастроек = МобильныеПриложения.ОписаниеОтбораКомпоновкиДанных(НастройкиДляСохранения.Отбор);
	Хранилище = Новый ХранилищеЗначения(СтруктураНастроек);
	ТекущийОбъект.ХранилищеОтбораСхемыОбмена = Хранилище;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВерсияМобильногоПриложенияПриИзменении(Элемент)
	
	ЗагрузитьНастройкиОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВерсияМобильногоПриложенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеКонтактнойИнформацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВосстановитьСтандартныеНастройки(Команда)
	
	ЗагрузитьСтандартныеНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Выполняет заполнение настроек компоновщика на основе переданных параметров.
//
// Параметры:
//  СхемаКомпоновки - схема компоновки данных, для которой компонуются настройки.
//  НастройкиКомпоновки - настройки компоновки, загружаемые в компоновщик.
//
Процедура ЗаполнитьНастройкиКомпоновщика(СхемаКомпоновки, НастройкиКомпоновки)
	
	Адрес = Новый УникальныйИдентификатор();
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, Адрес);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновки);
	
КонецПроцедуры	

&НаСервере
// Заполняет настройки компоновщика ранее сохраненными данными отбора.
//
Процедура ЗагрузитьНастройкиОтбора()
	
	СхемаКомпоновки = ПланыОбмена.МобильноеПриложениеТорговыйПредставитель.ПолучитьМакет("СхемаКомпоновкиНастроекОбмена");
	НастройкиКомпоновки = СхемаКомпоновки.НастройкиПоУмолчанию;
	ЗаполнитьНастройкиКомпоновщика(СхемаКомпоновки, НастройкиКомпоновки);
	
	ОбъектУзла = РеквизитФормыВЗначение("Объект");
	СтруктураОтбора = ОбъектУзла.ХранилищеОтбораСхемыОбмена.Получить();
	
	Если ТипЗнч(СтруктураОтбора) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураОтбора.Количество() > 0 Тогда	
		МобильныеПриложения.ЗаполнитьОтборКомпоновкиИзСтруктуры(КомпоновщикНастроек.Настройки.Отбор, СтруктураОтбора);
	КонецЕсли;

КонецПроцедуры

&НаСервере
// Заполняет настройки компоновщика стандартными настройками, определенными при разработке.
//
Процедура ЗагрузитьСтандартныеНастройки()
	
	СхемаКомпоновки = ПланыОбмена.МобильноеПриложениеТорговыйПредставитель.ПолучитьМакет("СхемаКомпоновкиНастроекОбмена");
	НастройкиКомпоновки = СхемаКомпоновки.НастройкиПоУмолчанию;
	ЗаполнитьНастройкиКомпоновщика(СхемаКомпоновки, НастройкиКомпоновки);
	
КонецПроцедуры

#КонецОбласти
