﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоЭкземпляров = 1;
	НазначениеШаблона     = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок;
	ШаблонЭтикетки        = Справочники.ШаблоныЭтикетокИЦенников.ШаблонПоУмолчанию(НазначениеШаблона);
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресВХранилище) Тогда
		
		ТаблицаШтрихкодов = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		ШтрихкодыУпаковок.Загрузить(ТаблицаШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОбработкиПечатьЭтикетокИЦенников = ЦенообразованиеКлиент.ИмяОбработкиПечатьЭтикетокИЦенников();
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		ИмяОбработкиПечатьЭтикетокИЦенников,
		"ЭтикеткаШтрихкодыУпаковки",
		ПараметрКоманды,
		ЭтотОбъект,
		ПолучитьПараметрыДляШтрихкодовУпаковок());
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыДляШтрихкодовУпаковок()
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(
		ШтрихкодыУпаковок.Выгрузить(), УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки"        , ШаблонЭтикетки);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров" , КоличествоЭкземпляров);
	ПараметрыПечати.Вставить("СтруктураМакетаШаблона", Неопределено);
	
	Возврат ПараметрыПечати;
	
КонецФункции

#КонецОбласти