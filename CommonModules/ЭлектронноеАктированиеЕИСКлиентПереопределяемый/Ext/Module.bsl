﻿#Область ПрограммныйИнтерфейс

// Открыть форму контракта ЕИС.
// 
// Параметры:
//  Форма - Форма
//  СсылкаНаКонтракт - ОпределяемыйТип.ГосударственныеКонтрактыБЭД- Ссылка на контракт
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - оповещение о закрытии.
Процедура ОткрытьФормуКонтракта(Форма, СсылкаНаКонтракт, ОповещениеОЗавершении) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Открыть форму выбора контракта.
// 
// Параметры:
//  Организация - ОпределяемыйТип.Организация - организация.
//  Контрагент - ОпределяемыйТип.КонтрагентБЭД - контрагент.
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма владелец.
//  ОповещениеОЗакрытии - ОписаниеОповещения, Неопределено - оповещение о закрытии.
Процедура ОткрытьФормуВыбораКонтракта(Организация,
		Контрагент,
		ФормаВладелец,
		ОповещениеОЗакрытии = Неопределено) Экспорт

	
	Возврат;
	
КонецПроцедуры

//Возвращает форму выбора контракта.
//
// Возвращаемое значение:
//  Строка - имя формы выбора.
//
Функция ИмяФормыВыбораГосударственногоКонтракта() Экспорт
	
	
	Возврат "";
	
КонецФункции

Процедура ОткрытьГосударственныйКонтракт(СсылкаНаКонтракт, Параметры = Неопределено) Экспорт

	
	Возврат;
	
КонецПроцедуры

Процедура ОткрытьФормуПозицииПоТорговомуНаименованиюЛП(ПараметрыФормы) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

Процедура ОткрытьФормуПозицииМНН(ПараметрыФормы) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти