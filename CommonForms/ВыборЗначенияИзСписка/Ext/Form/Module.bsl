﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ЗначенияДляВыбора) = Тип("СписокЗначений") Тогда
		Список.ТипЗначения = Параметры.ЗначенияДляВыбора.ТипЗначения;
		ОбщегоНазначенияУТ.ДобавитьСтрокиВТаблицу(Список, Параметры.ЗначенияДляВыбора);
	ИначеЕсли ТипЗнч(Параметры.ЗначенияДляВыбора) = Тип("Массив") Тогда
		Список.ЗагрузитьЗначения(Параметры.ЗначенияДляВыбора);
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок = Параметры.Заголовок;
		ЭтаФорма.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(Элементы.Список.ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.Список.ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти
