﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.ГруппаВыборГруппыСкладов.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки");
	
	РазрешитьРедактированиеВыборГруппыСкладов = Истина;
	РазрешитьРедактированиеРодитель  = Истина;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = Новый Массив;
	
	Если РазрешитьРедактированиеВыборГруппыСкладов Тогда
		Результат.Добавить("ВыборГруппы");
	КонецЕсли;
	
	Если РазрешитьРедактированиеРодитель Тогда
		Результат.Добавить("Родитель");
	КонецЕсли;
	
	Закрыть(Результат);

КонецПроцедуры // РазрешитьРедактирование()

#КонецОбласти

#КонецОбласти
