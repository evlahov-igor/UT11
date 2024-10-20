﻿	   
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ИзмененыПунктыМаршрута Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодтвержденияОбновленияНаименования", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Пункты маршрута были изменены. Желаете обновить наименование?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИзмененыПунктыМаршрута = Ложь;
	
КонецПроцедуры

#КонецОбласти	   
	   
#Область ОбработчикиСобытийЭлементовТаблицыФормыПунктыМаршрута

&НаКлиенте
Процедура ПунктыМаршрутаПриИзменении(Элемент)
	
	ИзмененыПунктыМаршрута = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктыМаршрутаСкладМагазинПриИзменении(Элемент)

	ТекущиеДанные = Элементы.ПунктыМаршрута.ТекущиеДанные; 
	СкладМагазин = ТекущиеДанные.СкладМагазин;
	
	Если Не ЗначениеЗаполнено(СкладМагазин) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(СкладМагазин) = Тип("СправочникСсылка.Склады") Тогда
		ДанныеСклада = ПолучитьДанныеСклада(СкладМагазин); 
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСклада);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьНаименование(Команда)
	
	СформироватьНаименованиеНаСервере();
	
КонецПроцедуры

#КонецОбласти      

#Область СлужебныеПроцедурыИФункции

// << 26.08.2022, Мельников А.А., КРОК, Jira№ A2105505-325 
// Параметры:
// Склад - СправочникСсылка.Склады - Склад для которого требуется узнать данные для заполнения
// Возвращаемое значение:
// Структура("АдресМагазина, Город")
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеСклада(Склад)
	
	Результат = Новый Структура("АдресМагазина, Город");
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СкладыКонтактнаяИнформация.Представление, """") КАК АдресМагазина,
		|	Склады.БизнесРегион КАК Город
		|ИЗ
		|	Справочник.Склады КАК Склады
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады.КонтактнаяИнформация КАК СкладыКонтактнаяИнформация
		|		ПО Склады.Ссылка = СкладыКонтактнаяИнформация.Ссылка
		|			И (СкладыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресСклада))
		|ГДЕ
		|	Склады.Ссылка = &Склад";
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 
	ВыборкаДетальныеЗаписи.Следующий(); 	
	ЗаполнитьЗначенияСвойств(Результат, ВыборкаДетальныеЗаписи);
	
	Возврат Результат;   	
		
КонецФункции // >> 26.08.2022, Мельников А.А., КРОК, Jira№ A2105505-325  

&НаКлиенте
Процедура ПослеПодтвержденияОбновленияНаименования(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	ИзмененыПунктыМаршрута = Ложь;
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьНаименованиеНаСервере(); 
 
КонецПроцедуры
 
&НаСервере
Процедура СформироватьНаименованиеНаСервере()
	
	ОбъектОбъект = РеквизитФормыВЗначение("Объект");
	ОбъектОбъект.СформироватьНаименование();
	ЗначениеВДанныеФормы(ОбъектОбъект, Объект);
	
КонецПроцедуры

#КонецОбласти
