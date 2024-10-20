﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтбор();
	
	// Элементы.Список - основной реквизит с динамическим списком
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	// обход автоматического сохранения пользовательских настроек для разных режимов, спасибо @stolya
	Если Параметры.РежимВыбора И Не ЗначениеЗаполнено(Параметры.КлючПользовательскихНастроек) Тогда
		Параметры.КлючПользовательскихНастроек = "РежимВыбора";
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Код");
    ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
    ЭлементОтбора.Использование = Истина;
    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
    ЭлементОтбора.ПравоеЗначение = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если Не ТекущиеДанные = Неопределено Тогда
		Оповестить("ДатаМобайл_ВыборТСД", ТекущиеДанные.Код);	
	КонецЕсли;	
	
КонецПроцедуры
