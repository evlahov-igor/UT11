﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Сертификат", Сертификат);
	Параметры.Свойство("Организация", Организация);
	
	Отбор = МашиночитаемыеДоверенности.НовыйОтборМЧД();
	Отбор.Доверитель = Организация;
	Отбор.Сертификат = Сертификат;
	Доверенности = МашиночитаемыеДоверенности.ПолучитьДоверенностиОрганизации(Отбор);
	Элементы.Доверенность.СписокВыбора.ЗагрузитьЗначения(Доверенности);
	
	Если Элементы.Доверенность.СписокВыбора.Количество() = 1 Тогда
		Доверенность = Элементы.Доверенность.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Подписать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Закрыть(Доверенность);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
