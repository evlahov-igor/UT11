﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("РежимОтображения", РежимОтображения);
	Параметры.Свойство("ПакетноеОтображение", ПакетноеОтображение);
	Параметры.Свойство("ОбластьЛегенды", ОбластьЛегенды);
	Параметры.Свойство("ОбластьПросмотра", ОбластьПросмотра);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОтображенияКИсполнениюПриИзменении(Элемент)

	ПриИзмененииРежимаПросмотра()
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтображенияМоиДокументыПриИзменении(Элемент)
	
	ПриИзмененииРежимаПросмотра()
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтображенияВсеДокументыПриИзменении(Элемент)
	
	ПриИзмененииРежимаПросмотра()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("РежимОтображения", РежимОтображения);
	Результат.Вставить("ПакетноеОтображение", ПакетноеОтображение);
	Результат.Вставить("ОбластьЛегенды", ОбластьЛегенды);
	Результат.Вставить("ОбластьПросмотра", ОбластьПросмотра);
			
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриИзмененииРежимаПросмотра()
	
	#Если МобильныйКлиент Тогда
		Закрыть(РежимОтображения);
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти
